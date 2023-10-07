---
layout: post
title: "ft_strtrim"
description: >
    "ft_strtrim에 대하여"
category: libft
---
## ft_strtrim

### <목차>
{:.lead}
[1. MY CODES](#1-my-codes)
[2. C TRIM](#2-trim-ltrim-rtrim)
[3. ft_strtrim]

> ft_strtrim -- 문자열과 구분자를 받아서, 문자열 좌우로 포함된 구분자를 모두 쳐낸 문자열을 할당하여 반환한다.

## (1) MY CODES
~~~c
#include "libft.h"

char	*ft_strtrim(char const *s1, char const *set)
{
	size_t	start;
	size_t	end;
	char	*result;

	start = 0;
	end = ft_strlen(s1);
	while (s1[start] && ft_strchr(set, s1[start]))
		start++;
	while (end && s1[end - 1] && ft_strchr(set, s1[end - 1]))
		end--;
	if (start > end)
		return (ft_strdup(""));
	result = ft_substr(s1, start, end - start); 
	// substr, s1의 start 문자부터 end 문자까지가 들어간 새로운 문자열을 할당하여 반환한다.
	return (result);
}
~~~

- 문자열을 trim한다고 하면 보통 특정 문자를 좌우로 걷어내는 함수들을 떠올린다. trim, ltrim, rtrim 등을 생각해볼 수 있다. 그러나 C 언어는 기본적으로 이런 trim 함수들을 지원하지 않는다(C 언어는 문자열을 다루는 함수가 제한적이다). trim 함수들을 직접 구현해보면서 연습해보는 것도 나쁘지 않을 것 같다. 

## (2) trim, ltrim, rtrim
- trim 함수는 보통 좌우로 **공백**을 지워내는 용도로 사용되는 경우가 많은데, 그것부터 구현해보자.

### * trim, 좌우의 공백을 지워낸다.
~~~c
char*	my_trim(char *s);
~~~
- 프로토 타입은 위와 같다. 문자열을 받아서 좌우로 공백을 지우고, 메모리를 할당해서 문자열을 반환한다. 

~~~c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char*	my_trim(char	*s)
{
	int left = 0;
	int	right = strlen(s);
	int idx = 0;

	while (s[left] == ' ')
		left++;
	while (s[--right] == ' ')
		;
	if (right - left + 1 < 0) // right - left + 1, 새로 할당할 문자열의 길이
		return (strdup("")); // 인덱스가 유효하지 않다면 빈 문자열 반환
	char	*newstr = (char*)malloc(sizeof(char) * (right - left + 1));
	while (left < right + 1)
		newstr[idx++] = s[left++];
	newstr[idx] = '\0';
	return newstr;
}

int main() 
{
	char	s[] = "   Hello World !  ";
	char	*ts = my_trim(s);
	printf("%s\n", ts);
	free(ts);
	return 0;
}
~~~
~~~plain
output :
	Hello World !
~~~
- 좌우로 공백이 아닐 때까지 인덱스를 당긴 후, 좌우간 인덱스에 1을 더한 만큼 문자열을 새로 할당한 후 채워넣고 반환한다. 문자열을 새로 채워넣고 반환하는 과정을 거치다보니 포인터만 옮겨서 반환하는 것보다 코드가 길어졌다.

### * ltrim, rtrim => 좌 공백, 우 공백을 지워낸다.
~~~c
char*	my_ltrim(char *s);
char*	my_rtrim(char *s);
~~~
- trim을 제대로 만들어놨다면 ltrim, rtrim은 쉽다. ltrim은 left 인덱스만 좁히면 되고, rtrim은 right 인덱스만 좁히면 된다. 위 코드에서는 left를 더하는 부분, right를 빼는 부분을 만들고자 하는 함수별로 주석 처리를 하면 된다.
~~~c
#include <stdio.h>
#include <string.h>

char*	my_ltrim(char	*s)
{
	int left = 0;
	int	right = strlen(s);
	int idx = 0;

	while (s[left] == ' ') 
		left++;
	// while (s[--right] == ' ') // ltrim은 여기를 주석처리, 오른쪽 인덱스를 좁히지 않음 
		// ;
	if (right - left + 1 < 0) // right - left + 1, 새로 할당할 문자열의 길이
		return (strdup("")); // 인덱스가 유효하지 않다면 빈 문자열 반환
	char	*newstr = (char*)malloc(sizeof(char) * (right - left + 1));
	while (left < right + 1)
		newstr[idx++] = s[left++];
	newstr[idx] = '\0';
	return newstr;
}

char*	my_rtrim(char	*s)
{
	int left = 0;
	int	right = strlen(s);
	int idx = 0;

	// while (s[left] == ' ') // rtrim은 여기를 주석처리, 왼쪽 인덱스를 좁히지 않음 
		// left++;
	while (s[--right] == ' ')
		;
	if (right - left + 1 < 0) // right - left + 1, 새로 할당할 문자열의 길이
		return (strdup("")); // 인덱스가 유효하지 않다면 빈 문자열 반환
	char	*newstr = (char*)malloc(sizeof(char) * (right - left + 1));
	while (left < right + 1)
		newstr[idx++] = s[left++];
	newstr[idx] = '\0';
	return newstr;
}

int main()
{
	char	s[] = "  abc  ";
	char	*ls = my_ltrim(s);
	char	*rs = my_rtrim(s);
	printf("%s\n%s\n", ls, rs);
	free(ts);
	return 0;
}
~~~
~~~plain
output :
	abc
	  abc
~~~
- 실행이 잘 된다.

## (3) ft_strtrim
- 과제에서 요구하는 strtrim은 조금 다르게 생겼다. 처리할 문자열(s)과 함께, 지워야 할 **문자열(set)**을 받는다. 단순히 좌우로 문자 하나씩을 걷어내는게 들어온 s의 좌우에, set의 문자들 중 하나라도 포함되어 있으면 지워야 한다. 대략 다음과 같다.
~~~c
...
	char*	s = ft_strtrim("abc123ab", "abc");
	printf("%s\n", s);
...
~~~
~~~plain
output:
	123
~~~
- 왼쪽에서 abc가, 오른쪽에서 ab가 trim되어서 123만이 남게 되었다. 지워야 할 대상 문자가 하나가 아니기 때문에 그것을 확인하는 절차가 추가되어야 한다. 나의 경우 strchr을 사용했다.
~~~c
	...
	while (s1[start] && ft_strchr(set, s1[start]))
		start++;
	while (end && s1[end - 1] && ft_strchr(set, s1[end - 1]))
		end--;
	...
~~~
- [ft_strchr](https://espebaum.github.io/libft/2023-10-05-ft-strchr/)에서 공부했듯이, strchr는 매개변수로 들어온 문자열에, 매개변수로 들어온 문자가 존재한다면 그 포인터를 반환한다. 여기서는 그 포인터의 위치는 중요하지 않고, NULL인지 아닌지만을 확인한다. 이러면 복수의 문자열도 손쉽게 확인할 수 있다.
- 그 이후로는 my_trim과 동일한데, ft_substr을 사용했다. 사실 my_trim 함수에서 right - left + 1만큼의 메모리를 할당하고 원본 문자열에서 하나씩 문자를 집어넣는 부분이 ft_substr안에 구현되어있는 것이나 마찬가지기 때문에, 동일한 작업이 맞다.