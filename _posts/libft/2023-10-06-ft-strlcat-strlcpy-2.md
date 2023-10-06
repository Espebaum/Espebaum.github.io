---
layout: post
title: "ft_strlcat, ft_strlcpy"
description: >
    "ft_strlcat, ft_strlcpy에 대하여"
category: libft
---

## ft_strlcpy

### <목차>
{:.lead}
[1. MY CODES](#1-my-codes)

[2. MAN STRLCAT & STRLCPY](#2-man-strlcat--strlcpy)

> strlcpy, strlcat -- size-bounded string copying and concatenation

## (1) MY CODES
~~~c
#include "libft.h"

size_t	ft_strlcpy(char *dest, const char *src, size_t dstsize)
{
	char	*c;
	size_t	cnt;

	c = (char *)src;
	cnt = 0;
	while (*c)
	{
		c++;
		cnt++;
	}
	if (dstsize)
	{
		while (*src && --dstsize)
		{
			*dest = *src;
			src++;
			dest++;
		}
		*dest = '\0';
	}
	return (cnt);
}
~~~

- strlcat, strlcpy는 매개변수를 받아 문자열을 복사하거나 연결하는 함수이다. 안전하지 못한 strncpy, strncat를 대체하기 위해 설계되었다.

## (2) MAN STRLCAT & STRLCPY
~~~plain
SYNOPSIS
	#include <string.h>

	size_t
		strlcpy(char * restrict dst, const char * restrict src, size_t dstsize);
	size_t
		strlcat(char * restrict dst, const char * restrict src, size_t dstsize);

DESCRIPTION
	The strlcpy() and strlcat() functions copy and concatenate strings with the 
	same input parameters and output result as snprintf(3). They are designed to be 
	safer, more consistent, and less error prone replacements for the easily misused
	functions strncpy(3) and strncat(3).

	strlcpy() and strlcat() take the full size of the destination buffer and guarantee 
	NUL-termination if there is room. Note that room for the NUL should be included 
	in dstsize.

	strlcpy() copies up to dstsize - 1 characters from the string src to dst, 
	NUL-terminating the result if dstsize is not 0.

	strlcat() appends string src to the end of dst. It will append at most 
	dstsize - strlen(dst) - 1 characters.  It will then NUL-terminate, unless
	dstsize is 0 or the original dst string was longer than dstsize (in practice this 
	should not happen as it means that either dstsize is incorrect or that dst is 
	not a proper string).

	If the src and dst strings overlap, the behavior is undefined.

RETURN VALUES
	Besides quibbles over the return type (size_t ver-sus int) and signal handler 
	safety (snprintf(3) is not entirely safe on some systems), the following 
	two are equivalent:

		n = strlcpy(dst, src, len);
		n = snprintf(dst, len, "%s", src);

	Like snprintf(3), the strlcpy() and strlcat() functions return the total length
	of the string they tried to create.  For strlcpy() that means the length of src.
	For strlcat() that means the initial length of dst plus the length of src.

	If the return value is >= dstsize, the output string has been truncated.
	It is the caller's responsibility to handle this.
~~~

- 대충 살펴봐도 개빡센 메뉴얼이다. 정리해보자면...

### * strlcpy(char *dst, const char *src, size_t dstsize) 개요
1.  `strlcpy()`는 src에서 dst로 dstsize - 1개의 문자를 복사하고 dstsize가 0이 아니라면 dst에 NUL을 추가한 후, 복사하고자 했던 src의 길이를 반환한다. dstsize가 0이라면 아무런 행동도 하지 않고 복사하고자 했던 src의 길이를 반환한다. 	dstsize는 src의 몇 글자를 dst에 복사할 것인지를 의미하는데, 이것이 0이라는 것은 복사가 이루어지지 않는다는 것을 의미한다.

1.  마찬가지로 src와 dst 문자열이 겹치는 경우 동작은 정의되지 않는다.

1.  `strlcat()`과 마찬가지로 **`strlcat()` 함수도 생성하려고 시도한 문자열의 총 길이를 반환한다**. 이것은 strlcpy()의 경우 src의 길이를 의미하고, strlcat()의 경우 dst의 초기 길이와 src 길이의 합계를 의미한다. 

1.  `strlcat()`과 마찬가지로 dstsize는 `strlcpy()`의 반환값이 아니며, `strlcpy()`의 반환값 src는 dstsize와 다를 수 있다. 이 함수도 	`strlcat()`처럼 dstsize와 반환값의 차이를 이용하여 플래그처럼 사용할 수 있지 않을까하고 생각한다(생각만...).

### * strlcpy(char *dst, const char *src, size_t dstsize) 코드 개요

~~~c
	...
	c = (char *)src;
	cnt = 0;
	while (*c)
	{
		c++;
		cnt++;
	}
	...
	return (cnt);
~~~
- 여기서 따로 포인터 변수를 만들어서 반환해야할 src의 길이를 구한 후,

~~~c
	...
	if (dstsize)
	{
		while (*src && --dstsize)
		{
			*dest = *src;
			src++;
			dest++;
		}
		*dest = '\0';
	}
	...
	return (cnt);
~~~
- dstsize만큼 복사한다. dstsize가 0이라면 아무런 행위도 하지 않고 반환된다
- 전위 연산을 사용해서(--dstsize) NUL이 들어갈 자리를 미리 빼주고, 복사가 끝나면 끝까지 밀린 dest 포인터를 역참조해서 NUL을 넣어서 유효한 문자열임을 보장해준다.