---
layout: post
title: "ft_memmove"
description: >
    "ft_memmove에 대하여"
category: libft
---
## ft_memmove

### <목차>
{:.lead}
[1. MY CODES](#1-my-codes)

> memmove --- copy memory area

## (1) MY CODES

~~~c
#include "libft.h"

void	*ft_memmove(void *dest, const void *src, size_t n)
{
	unsigned char	*new_dest;
	unsigned char	*new_src;

	if (dest == src)
		return (dest);
	if (dest < src)
	{
		new_dest = (unsigned char *)dest;
		new_src = (unsigned char *)src;
		while (n--)
			*new_dest++ = *new_src++;
	}
	else
	{
		new_dest = (unsigned char *) dest + (n - 1);
		new_src = (unsigned char *) src + (n - 1);
		while (n--)
			*new_dest-- = *new_src--;
	}
	return (dest);
}
~~~

## (2) MAN MEMMOVE
