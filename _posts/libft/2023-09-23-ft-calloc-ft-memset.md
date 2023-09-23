---
layout: post
title: "ft_calloc & ft_memset"
description: >
    "ft_calloc, ft_memset에 대하여"
category: libft
---
## ft_calloc & ft_memset

### <목차>
{:.lead}
[1. MY CODES](#1-my-codes)

[2. MAN CALLOC](#2-man-calloc)

> **calloc** --- Memory Allocation

> **memset** --- fill a byte string with a byte value

## (1) MY CODES

~~~c
#include "libft.h"

// here ft_calloc()
void	*ft_calloc(size_t count, size_t size)
{
	void	*ptr;

	ptr = malloc(count * size);
	if (!ptr)
		return (NULL);
	ft_memset(ptr, 0, count * size);
	return (ptr);
}

// here ft_memset()
void	*ft_memset(void *dest, int c, size_t n)
{
	unsigned char	*new_dest;
	unsigned char	src;
	size_t			i;

	new_dest = dest;
	src = c;
	i = 0;
	while (i++ < n)
		*new_dest++ = src;
	return (dest);
}
~~~

## (2) MAN CALLOC
~~~plain
SYNOPSIS
 #include <stdlib.h>

     void *calloc(size_t count, size_t size);

DESCRIPTION
 The calloc() function contiguously allocates enough space for count objects
 that are size bytes of memory each and returns a pointer to the allocated
 memory. The allocated memory is filled with bytes of value zero.
~~~

