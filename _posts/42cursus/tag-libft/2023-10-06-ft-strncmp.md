---
layout: post
title: "ft_strncmp"
description: >
    "ft_strncmp에 대하여"
category: 42cursus
tags: libft
---

## ft_strncmp

### <목차>
* MY CODES
{:toc}
{:.lead}
[1. MY CODES](#1-my-codes)

[2. MAN STRNCMP](#2-man-strncmp)

> strcmp, strncmp -- compare strings

## (1) MY CODES
~~~c
#include "libft.h"

int	ft_strncmp(const char *s1, const char *s2, size_t n)
{
	unsigned int	i;

	i = 0;
	while ((s1[i] || s2[i]) && i < n)
	{
		if (s1[i] != s2[i])
			break ;
		i++;
	}
	if (i == n)
		return (0);
	return ((unsigned char)s1[i] - (unsigned char)s2[i]);
}
~~~
- 매개변수로 들어온 const 문자열 s1, s2를 사전순으로 비교한다.

## (2) MAN STRNCMP
~~~plain
SYNOPSIS
     #include <string.h>

     int	strcmp(const char *s1, const char *s2);

     int	strncmp(const char *s1, const char *s2, size_t n);

DESCRIPTION
     The strcmp() and strncmp() functions lexicographically compare the null-
     terminated strings s1 and s2.

     The strncmp() function compares not more than n characters.  Because
     strncmp() is designed for comparing strings rather than binary data,
     characters that appear after a `\0' character are not compared.

RETURN VALUES
     The strcmp() and strncmp() functions return an integer greater than,
     equal to, or less than 0, according as the string s1 is greater than,
     equal to, or less than the string s2.  The comparison is done using
     unsigned characters, so that `\200' is greater than `\0'.
~~~

- [ft_memcmp](https://espebaum.github.io/libft/2023-09-25-ft-memcmp/)에서 비슷한 코드를 작성한 바 있다.

~~~c
int	ft_memcmp(const void *s1, const void *s2, size_t n);
int	ft_strncmp(const char *s1, const char *s2, size_t n);
~~~

- ft_memcmp는 매개변수로 const void 포인터를 받지만 내부적으로 void 포인터가 unsigned char 포인터로 변환된다는 점을 생각하면, 두 함수는 거의 비슷한 형태를 가졌다고 생각할 수 있다.

- 다만 차이점이 있다면 strncmp 함수는 **애초에 문자열을 비교하기 위해 설계되었다**는 점이다. 즉 문자열이 '\0'을 만나게 되면 n을 넘지 않았더라도 비교가 중단된다. memcmp는 그런 제약없이 정확히 n개를 비교한다.

~~~c
	...
	while ((s1[i] || s2[i]) && i < n)
	{
		if (s1[i] != s2[i])
			break ;
		i++;
	}
	...
~~~

- `i < n` 조건 이외에 `(s1[i] || s2[i])` 조건이 존재한다. 둘 모두 '\0'이 아닌 이상 비교를 진행하게 된다.
  - 그러나 둘 중 하나가 널이라면, 스코프 내의 if문 조건 `(s1[i] != s2[i])`에 반드시 걸리게 되어 while문을 탈출하게 된다.

- s1 문자열이 s2 문자열보다 크거나 같거나 작은지에 따라 0보다 큰 정수, 0과 같거나, 0보다 작은 정수를 반환한다. 이 또한 memcmp와 동일하다. 다만 반환하는 정수를 계산하는 부분에서, **unsigned char로 캐스팅하여 계산**하기 때문에 확장 아스키 문자도 비교할 수 있다. man에 따르면, '\200'은 '\0'보다 큰 캐릭터이다.