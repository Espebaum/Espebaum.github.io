---
layout: post
title: "ft_strjoin"
description: >
    "ft_strjoin에 대하여"
category: 42cursus
tags: libft
---
## ft_strjoin

### <목차>
* MY CODES
{:toc}
{:.lead}
[1. MY CODES](#1-my-codes)

[2. 사용](#2-사용)

> ft_strjoin -- 문자열 두 개를 스근하게 붙여보자

## (1) MY CODES
~~~c
#include "libft.h"

char	*ft_strjoin(char const *s1, char const *s2)
{
	char	*strjoin;
	size_t	len1;
	size_t	len2;

	len1 = ft_strlen(s1);
	len2 = ft_strlen(s2);
	strjoin = (char *)malloc(sizeof(char) * (len1 + len2 + 1));
	if (!strjoin)
		return (NULL);
	ft_memcpy(strjoin, s1, len1);
	ft_memcpy(strjoin + len1, s2, len2);
	strjoin[len1 + len2] = '\0';
	return (strjoin);
}
~~~
- 매개변수로 받은 const 문자열 두 개(s1, s2)를 받아서 s1뒤에 s2가 붙어있는 문자열 하나를 반환하는 함수.

## (2) 사용
~~~c
#include "libft.h"
#include <string.h>

void	*ft_memcpy(void *dest, const void *src, size_t n)
{
	unsigned char	*new_dest;
	unsigned char	*new_src;
	size_t			i;

	if (dest == src)
		return (dest);	// block self-copy
	new_dest = (unsigned char *) dest;
	new_src = (unsigned char *) src;
	i = 0;
	while (i++ < n)
		*new_dest++ = *new_src++;
	return (dest);
}

char	*ft_strjoin(char const *s1, char const *s2)
{
	char	*strjoin;
	size_t	len1;
	size_t	len2;

	len1 = strlen(s1); // ft_strlen(s1);
	len2 = strlen(s2); // ft_strlen(s2);
	strjoin = (char *)malloc(sizeof(char) * (len1 + len2 + 1));
	if (!strjoin)
		return (NULL);
	ft_memcpy(strjoin, s1, len1);
	ft_memcpy(strjoin + len1, s2, len2);
	strjoin[len1 + len2] = '\0';
	return (strjoin);
}

int	main()
{
	int		i = 0;
	char	s[] = "Apple";
	char	j[] = "Juice";
	char	*sj = ft_strjoin(s, j);
	printf("I love %s!\n", sj);
	return 0;
}
~~~
~~~plain
output:
	I love AppleJuice!
~~~
- C 문자열을 다룰때 strdup만큼이나 자주 사용하는 함수. 마찬가지로 malloc을 통해 s1과 s2가 들어갈 메모리 공간을 할당하기 때문에, join한 문자열의 사용이 끝났다면 해제해서 메모리 관리에 신경쓰는 편이 좋다.