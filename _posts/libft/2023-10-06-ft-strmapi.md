---
layout: post
title: "ft_strmapi"
description: >
    "ft_strmapi에 대하여"
category: libft
---

## ft_strmapi

### <목차>
{:.lead}
[1. MY CODES](#1-my-codes)

[2. 용례](#2-용례)

> ft_strmapi -- 문자열과 함수 포인터를 매개변수로 받아 함수를 적용시킨 새로운 문자열을 반환하자 

## (1) MY CODES
~~~c
#include "libft.h"

char	*ft_strmapi(char const *s, char (*f)(unsigned int, char))
{
	unsigned int	len;
	char			*new_s;
	unsigned int	index;

	index = 0;
	len = ft_strlen(s);
	new_s = (char *)malloc(sizeof(char) * (len + 1));
	if (!(new_s))
		return (NULL);
	while (index < len)
	{
		new_s[index] = f(index, s[index]);
		index++;
	}
	new_s[len] = '\0';
	return (new_s);
}
~~~
- `ft_striteri()`와 같이 문자열과 함수 포인터를 매개변수로 받아서 새로운 문자열이 들어갈 메모리를 할당하고, 함수 포인터가 가리키는 함수를 문자열에 적용해 그 새로운 문자열을 채워넣어 반환한다.

- 함수 포인터에 대해서는 이전의 글 [ft_striteri()](https://espebaum.github.io/libft/2023-10-05-ft-striteri/)를 참조하자.

## (2) 용례
~~~c
#include "libft.h"

char	MyUpperCase(unsigned int idx, char c) 
{
    if (c >= 'a' && c <= 'z') 
        c -= 32; // 소문자를 대문자로 변환
	return c;
}

char*	ft_strmapi(char const *s, char (*f)(unsigned int, char))
{
	unsigned int	len;
	char			*new_s;
	unsigned int	index;

	index = 0;
	len = strlen(s); // ft_strlen
	new_s = (char *)malloc(sizeof(char) * (len + 1));
	if (!(new_s))
		return (NULL);
	while (index < len)
	{
		new_s[index] = f(index, s[index]);
		index++;
	}
	new_s[len] = '\0';
	return (new_s);
}

int main()
{
	char	s[] = "apple";
	char	(*upper)(unsigned int, char); // 함수 포인터 선언
	upper = MyUpperCase; // 함수 포인터 초기화

	char	*bs = ft_strmapi(s, upper); // 문자열 s에 함수 적용
	printf("New string: %s\n", bs);
	free(bs);
	return 0;
}
~~~
~~~plain
output:
	New string: APPLE
~~~

- 새로운 문자열을 위한 메모리를 새로 할당하는 만큼, 해제를 통해 메모리를 관리해야 할 것이다.