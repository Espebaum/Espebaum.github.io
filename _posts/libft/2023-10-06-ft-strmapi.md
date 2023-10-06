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
