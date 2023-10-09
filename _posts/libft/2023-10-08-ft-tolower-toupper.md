---
layout: post
title: "ft_tolower & ft_toupper"
description: >
    "ft_tolower, ft_toupper에 대하여"
category: libft
---
## ft_tolower & ft_toupper

### <목차>
{:.lead}
[1. MY CODES](#1-my-codes)

> toupper, tolower -- convert uppercase or lowercase


## (1) MY CODES
~~~c
#include "libft.h"

// tolower
int	ft_tolower(int c)
{
	if (c >= 'A' && c <= 'Z')
		return (c + 32);
	return (c);
}

// toupper
int	ft_toupper(int c)
{
	if (c >= 'a' && c <= 'z')
		return (c - 32);
	return (c);
}
~~~

- [ft_isascii](https://espebaum.github.io/libft/2023-09-24-ft-isascii-ft-isprint/)에서 살펴본 바 있는, 아스키 문자 계산을 통해 대문자를 소문자로, 소문자를 대문자로 바꾸는 함수들이다.
- 위 코드에서는 32를 더하고, 32를 빼는데, 이것은 아스키 코드상 65인 'A'와 97인 'a'간의 연산이다. 대문자, 혹은 소문자로 바꾸고자 하는 알파벳에 32를 빼거나 더하면 된다. 가독성을 위해 아래처럼 쓰기도 한다. 이는 개인의 취향이다.

~~~c
int	ft_tolower(int c)
{
	if (c >= 'A' && c <= 'Z')
		return (c + 'a' - 'A');
	return (c);
}

// toupper
int	ft_toupper(int c)
{
	if (c >= 'a' && c <= 'z')
		return (c - 'a' + 'A');
	return (c);
}
~~~