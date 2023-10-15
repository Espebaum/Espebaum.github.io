---
layout: post
title: "ft_strrchr"
description: >
    "ft_strrchr에 대하여"
category: 42cursus
tags: libft
---
## ft_strrchr

### <목차>
* MY CODES
{:toc}
{:.lead}
[1. MY CODES](#1-my-codes)

[2. MAN STRRCHR](#2-man-strchr)

> strrchr -- locate character in string

## (1) MY CODES
~~~c
#include "libft.h"

char	*ft_strrchr(const char *s, int c)
{
	char	src;
	int		end;

	src = c;
	end = ft_strlen(s);
	while (end >= 0)
	{
		if (s[end] == src)
			return ((char *)(s + end));
		end--;
	}
	return (0);
}
~~~

## (2) MAN STRCHR
~~~plain
SYNOPSIS
	#include <string.h>

	char *strchr(const char *s, int c);
	char *strrchr(const char *s, int c);

DESCRIPTION
     The strchr() function locates the first occurrence of c (converted to a
     char) in the string pointed to by s. The terminating null character is
     considered to be part of the string; therefore if c is `\0', the func-
     tions locate the terminating `\0'.

     The strrchr() function is identical to strchr(), except it locates the
     last occurrence of c.

RETURN VALUES
     The functions strchr() and strrchr() return a pointer to the located
     character, or NULL if the character does not appear in the string.
~~~

- strrchr은 매개 변수로 const 문자열과 int c를 받아서 문자열 내에서 c가 마지막 등장하는 부분을 찾아서 포인터를 그쪽으로 옮긴 후, 그 char 포인터를 반환한다. 이 과정에서 c는 char로 변환되며, **문자열의 NULL 또한 문자열의 일부로 처리되기 때문에** 찾는 c가 '\0'이라면 반환되는 값 또한 문자열의 '\0'이다.

- [ft_strchr](https://espebaum.github.io/libft/2023-10-05-ft-strchr/)와 똑같이 작동하지만, 탐색을 역순으로 진행한다는 점이 특징이다.