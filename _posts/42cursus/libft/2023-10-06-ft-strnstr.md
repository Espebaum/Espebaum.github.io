---
layout: post
title: "ft_strnstr"
description: >
    "ft_strnstr에 대하여"
category: libft
---

## ft_strnstr

### <목차>
{:.lead}
[1. MY CODES](#1-my-codes)

[2. MAN STRNSTR](#2-man-strnstr)

[3. 반환값과 예외 처리](#3-반환값과-예외-처리)

> strstr, strcasestr, strnstr -- locate a substring in a string

## (1) MY CODES
~~~c
#include "libft.h"

char	*ft_strnstr(const char *haystack, const char *needle, size_t len)
{
	size_t	h_len;
	size_t	n_len;

	if (*needle == '\0')
		return ((char *)haystack);
	h_len = ft_strlen(haystack);
	n_len = ft_strlen(needle);
	if (h_len < n_len || len < n_len)
		return (NULL);
	while (len-- >= n_len && *haystack)
	{
		if (ft_memcmp(haystack, needle, n_len) == 0)
			return ((char *)haystack);
		haystack++;
	}
	return (NULL);
}
~~~
- strnstr() 함수는 널 종료된 문자열 needle을 문자열 haystack에서 찾아서, 존재한다면 그 첫 번째 위치의 포인터를 반환한다. '\0' 문자 이후에 나타나는 문자들은 탐색하지 않는다. 이게 무슨 말인가 싶을 수도 있는데, man에 친절하게 예시가 나와있다. 

## (2) MAN STRNSTR

~~~plain
SYNOPSIS
	#include <string.h>

	char* strstr(const char *haystack, const char *needle);
	char* strcasestr(const char *haystack, const char *needle);
	char* strnstr(const char *haystack, const char *needle, size_t len);

DESCRIPTION
	The strstr() function locates the first occurrence of the null-terminated
	string needle in the null-terminated string haystack.

	The strcasestr() function is similar to strstr(), but ignores the case of
	both strings.

	The strnstr() function locates the first occurrence of the null-termi-
	nated string needle in the string haystack, where not more than len char-
	acters are searched.  Characters that appear after a `\0' character are
	not searched.

RETURN VALUES
	If needle is an empty string, haystack is returned; if needle occurs
	nowhere in haystack, NULL is returned; otherwise a pointer to the first
	character of the first occurrence of needle is returned.

EXAMPLES
	The following sets the pointer ptr to the "Bar Baz" portion of
	largestring:

		const char *largestring = "Foo Bar Baz";
		const char *smallstring = "Bar";
		char *ptr;

		ptr = strstr(largestring, smallstring); -> "Bar Baz" 

	The following sets the pointer ptr to NULL, because only the first 4
	characters of largestring are searched:

		const char *largestring = "Foo Bar Baz";
		const char *smallstring = "Bar";
		char *ptr;

		ptr = strnstr(largestring, smallstring, 4); -> NULL;
~~~

- `strstr()`함수는 어떤 Large String 내에, Small String이 포함되어 있다면, Large String 내에서 포인터를 옮겨 Small String이 시작하는 지점에서 반환시킨다. 위에 EXAMPLE에 용례가 등장한다.

- Large String이 "Foo Bar Baz"고 그 안에서 Small String인 "Bar"를 strstr을 이용하여 찾는데, Bar가 Foo Bar Baz안에 포함되어 있기 때문에, Large String내에서 포인터를 옮겨 Small String이 시작하는 지점에서 반환시킨다. 즉

~~~c
const char *largestring = "Foo Bar Baz";
const char *smallstring = "Bar";
char *ptr = strstr(LargeString, SmallString);
printf("%s\n", ptr);
~~~

- 반환된 포인터 ptr를 출력시키면 

~~~plain
output:
	Bar Baz
~~~

- Bar Baz를 출력시킨다 **(Bar가 출력되는 게 아니다!!!)**. `strstr()`은 small string 자체를 반환시키는 함수가 아니다!!!
- `strcasestr()`는 `strstr()`와 비슷한 작동을 하는데 두 문자열의 대소문자 차이를 고려하지 않는다.

- `strnstr()` 또한 large string 내에서 포인터를 옮겨서 small string이 시작하는 지점에서 반환시키는 점은 동일한데, 매개변수로 들어온 len 길이만큼만 탐색한다. 마찬가지로 EXAMPLE에 용례가 있다.

~~~c
const char *largestring = "Foo Bar Baz";
const char *smallstring = "Bar";
char *ptr = strnstr(LargeString, SmallString, 4);
printf("%s\n", ptr);
~~~

- 반환된 포인터 ptr를 출력시키면 

~~~plain
output:
	(NULL)
~~~

- "Foo Bar Baz"를 4번 탐색하는 동안, Bar가 등장하지 않았기 때문에 NULL 포인터를 반환시킨다.

## (3) 반환값과 예외 처리
- 이 함수(ft_strnstr)도 값을 반환하고, 예외를 처리하는 것이 꽤 어지러운 함수이기도 하다. man을 보면서 살펴보자.
### * 반환값

**- If needle is an empty string, haystack is returned**
  -> 찾으려는 문자열이 빈 문자열이면, 대상 문자열의 첫 포인터를 그대로 반환한다. 사실상 아무것도 찾지 않는다는 것과 같기 때문에 아무런 작동도 하지 않고 함수를 종료시킨다.

**- If needle occurs nowhere in haystack, NULL is returned; otherwise a pointer to the first character of the first occurrence of needle is returned**
  -> 찾으려는 문자열(needle)이 대상 문자열(haystack)에 없으면 NULL을 반환한다; 그렇지 않다면 살펴보았듯이, 대상 문자열내에서 찾으려는 문자열이 처음으로 등장하는 포인터를 반환한다.
### * 예외 처리

**- 찾으려는 문자열의 길이(needle)가 대상 문자열(haystack)보다 길거나, 탐색하는 길이 len이 needle의 길이보다 짧을 때**
  -> NULL을 반환시킨다.
    - `apple`안에서 `applejuice`를 찾는다고 하면 말이 안된다. 또 `applejuice`에서 `apple`을 찾을 건데, 탐색을 3번만 하면 함수를 백만번을 실행시켜도 apple을 찾을 수가 없을 것이다.

**- 대상 문자열(haystack)이 NULL이거나, 찾으려는 문자열(needle)이 NULL인 경우**

 (1) haystack이 NULL인 경우

~~~c
#include <stdio.h>
#include <string.h>

int main() 
{
    const char *haystack = NULL; // NULL
    const char *needle = "juice";
    size_t len = strlen(haystack);

    char *ptr = strnstr(haystack, needle, len);

    if (ptr)
        printf("%s\n", result);

    return 0;
}
~~~

 (2) needle이 NULL인 경우

~~~c
#include <stdio.h>
#include <string.h>

int main() 
{
    const char *haystack = "applejuice";
    const char *needle = NULL; // NULL
    size_t len = strlen(haystack);

    char *ptr = strnstr(haystack, needle, len);

    if (ptr)
        printf("%s\n", result);

    return 0;
}
~~~

~~~plain
❯ ./a.out
zsh: segmentation fault  ./a.out
~~~

- 원본 strnstr의 경우, haystack이나 needle이 NULL이라면 segmentation fault가 발생한다. 원본 함수의 구현을 따라간다면 문자열들이 NULL인 것에 대한 예외 처리는 할 필요가 없다. 