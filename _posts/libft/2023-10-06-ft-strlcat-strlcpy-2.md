---
layout: post
title: "ft_strlcat, ft_strlcpy"
description: >
    "ft_strlcat, ft_strlcpy에 대하여"
category: libft
---

## ft_strlcpy (2)

### <목차>
{:.lead}
[1. MY CODES](#1-my-codes)

[2. MAN STRLCAT & STRLCPY](#2-man-strlcat--strlcpy)

> strlcpy, strlcat -- size-bounded string copying and concatenation

## (1) MY CODES
~~~c
#include "libft.h"

size_t	ft_strlcpy(char *dest, const char *src, size_t size)
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
	if (size)
	{
		while (*src && --size)
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



- 변수를 많이 써서 복잡해보이는데 결국 dst의 끝에서부터 src의 첫 번째 글자를 dstsize만큼 채워넣는데, NUL이 들어갈 하나를 남겨두고 붙이는 과정이다(dstsize - strlen(dst) - 1개). src를 전부 붙여서 src의 인덱스가 NUL이거나 혹은 최종 dst의 길이가 dstsize에 도달하게 되면 멈춘다. 짧은 라인이지만 꽤 난이도가 있지 않나하고 생각한다...

strlcpy()와 strlcat()은 대상 버퍼의 전체 크기를 가져와 여유가 있다면 NUL-종료를 보장합니다. NUL을 위한 공간은 dstsize에 포함되어야 합니다. strlcpy()는 문자열 src에서 dst로 dstsize - 1개의 문자를 복사하고, dstsize가 0이 아닌 경우 결과에 NUL을 추가합니다.

strlcat()은 문자열 src을 dst의 끝에 추가합니다. 최대 dstsize - strlen(dst) - 1개의 문자를 추가합니다. 그런 다음 NUL을 추가합니다. dstsize가 0이거나 원래 dst 문자열이 dstsize보다 길었던 경우에만 NUL을 추가하지 않습니다 (실제로 이러한 경우는 발생하지 않아야 합니다. 이것은 dstsize가 잘못되었거나 dst가 올바른 문자열이 아님을 의미합니다).

src와 dst 문자열이 겹치는 경우 동작은 정의되지 않습니다.

반환 값
반환 유형 (size_t 대 int) 및 시그널 핸들러 안전성 (일부 시스템에서 snprintf(3)은 완전히 안전하지 않음)에 대한 논쟁을 제외하고 다음 두 가지는 동등합니다:

n = strlcpy(dst, src, len);
n = snprintf(dst, len, "%s", src);

snprintf(3)과 마찬가지로 strlcpy()와 strlcat() 함수는 생성하려고 시도한 문자열의 총 길이를 반환합니다. strlcpy()의 경우 src의 길이를 의미하고, strlcat()의 경우 dst의 초기 길이와 src의 길이를 의미합니다.

반환 값이 dstsize 이상인 경우 출력 문자열이 자르기되었습니다. 이를 처리하는 것은 호출자의 책임입니다.

