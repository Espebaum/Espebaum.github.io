---
layout: post
title: "ft_strlcat, ft_strlcpy"
description: >
    "ft_strlcat, ft_strlcpy에 대하여"
category: 42cursus
tags: libft
image: "/assets/img/libft/libft.webp"
---

## ft_strlcat

### <목차>
* MY CODES
{:toc}
{:.lead}
[1. MY CODES](#1-my-codes)

[2. MAN STRLCAT & STRLCPY](#2-man-strlcat--strlcpy)

> strlcpy, strlcat -- size-bounded string copying and concatenation

## (1) MY CODES
~~~c
#include "libft.h"

size_t	ft_strlcat(char *dst, const char *src, size_t dstsize)
{
	size_t	p_dst;
	size_t	p_src;
	size_t	dst_len;
	size_t	src_len;

	dst_len = ft_strlen(dst);
	src_len = ft_strlen(src);

	p_dst = dst_len;
	p_src = 0;

	if (dst_len >= dstsize)
		return (src_len + dstsize);

	while (src[p_src] && (p_src + dst_len + 1) < dstsize)
		dst[p_dst++] = src[p_src++];
		
	dst[p_dst] = '\0';
	return (src_len + dst_len);
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

### * strlcat(char *dst, const char *src, size_t dstsize) 개요
1.  strlcat함수는 오용되기 쉬운 함수인 strncat의 안전하고 일관적이며 오류가 적은 대체품으로 설계되었다.

1.  `strlcat(char *dst, const char *src, size_t dstsize)`은 문자열 src를 dst의 끝에 추가한다. 이때 **최대 dstsize - strlen(dst) - 1개**의 문자를 추가한다. 그 후 NUL을 추가한다. NUL을 추가하는 것으로 반환된 문자열이 유효하다는 것을 보장한다. -1의 의도는 NUL의 자리를 항상 비워주기 위한 것으로 보인다.

1.  그런데 **dstsize가 0이거나 dst 문자열이 dstsize보다 긴 경우**, NUL을 추가하지 않는다. 이러한 경우는 발생하지 않아야 하는데, 이것은 dstsize가 잘못되었거나 dst가 올바른 문자열이 아님을 의미한다.
  - 그러니까 **dstsize는 함수가 실행되고, src의 문자열이 합쳐진 dst의 최종적인 길이**일 것으로 생각할 수 있는데, 이게 0이거나 dst의 원래 길이보다 작다면 애초에 말도 안되는 input이라고 볼 수 있다. dst에 문자열을 붙였는데 dstsize가 원래 dst 길이보다 짧거나, 0이라는 것은 이상하다.
  - 이 경우 아무런 작동없이 src의 길이에 dstsize를 더해 반환한다.

1. src와 dst 문자열이 겹치는 경우 **undefined behavior**다.
  - 보통 src와 dst가 겹치는 경우 자기 복제를 방지하기 위해 다음과 같이 곧바로 return 시키는데
~~~c
...
	if (src == dst)
			return ;
...
~~~
  - 이 경우 행동이 정의되어 있지 않으므로 이 부분을 코드에 구현할 필요는 없다.

1.  **`strlcat()` 함수는 생성하려고 시도한 문자열의 총 길이를 반환한다. `strlcat()`의 경우 dst의 초기 길이와 src의 길이를 의미한다. 반환 값(dstlen + srclen)이 dstsize 이상인 경우 출력 문자열이 잘릴 수 있는데(truncate), 이것을 처리하는 것은 호출자의 책임이다.
  - **함수의 반환값이 dstsize와 다를 수 있다**는 것을 나타낸다.

### * strlcat() 코드 개요
- 솔직히 strlcat이나 strlcpy 모두 짜면서 인터넷을 많이 찾아봤었다. 그 정도로 작성하기 까다로운 코드였던 기억이 있다. 코드를 하나씩 뜯어서 분석해보자. 
- 아래 코드는 붙혀넣는 과정을 제외한 부분이다.

~~~c
#include "libft.h"

size_t	ft_strlcat(char *dst, const char *src, size_t dstsize)
{
	size_t	p_dst, p_src, dst_len, src_len;

	dst_len = ft_strlen(dst); // 원래 dst의 길이
	src_len = ft_strlen(src); // 원래 src의 길이
	p_dst = dst_len; // dst의 길이 인덱스부터 
	p_src = 0; // src의 0번째 글자를 붙힌다.

	if (dst_len >= dstsize)
		return (src_len + dstsize); 
		// dstsize가 올바른 값이 아닐 경우의 반환값, 아무런 작동 없이 함수를 종료한다.

	// ... implementation

	return (src_len + dst_len); 
	// dstsize가 올바른 값일 때의 반환값, dstsize와 달라질 수 있다.
}
~~~

- 변수를 4개나 쓴다, 4개 모두가 의미가 있는 것들이다. 반환값을 구하고, src의 첫 번째 문자부터 dst의 끝부터 붙혀나가는 구현 사항을 충족하기 위해 사용된다. 

- 봤다시피 **dstsize는 strlcat의 반환값이 아니다**. 심지어 strlcat이 반환값은 dstsize가 유효한 값인지, 아닌지에 따라 두 가지로 나뉜다. dstsize가 유효한 값이 아니라면 src의 길이에 dstsize를 더한 값을 반환하고, dstsize가 유효한 값이라면 src의 길이에 원본 dst의 길이를 더한 값을 반환한다. strlcat의 반환값이 왜 이렇게 설계되었는지에 대한 고찰이 담긴 글의 링크를 소개한다.

> [strlcat 반환값에 대한 고찰](https://ksabs.tistory.com/216)

- 함수 자체가 일종의 플래그가 될 수 있다고 생각한다면, 반환값을 둘로 나뉘도록 설계해서 문자열을 더 안전하게 관리한다는 것이 그다지 이질적인 부분은 아닌 것 같다. (C 과제를 진행하면서 세웠던 수많은 플래그들이 아른거린다...)

- 아래 코드는 문자열을 붙혀넣는 과정이다.

~~~c
	while (src[p_src] && (p_src + dst_len + 1) < dstsize)
		dst[p_dst++] = src[p_src++];
~~~

- 변수를 많이 써서 복잡해보이는데 결국 dst의 끝에서부터 src의 첫 번째 글자를 dstsize만큼 채워넣는데, NUL이 들어갈 하나를 남겨두고 붙이는 과정이다(dstsize - strlen(dst) - 1개). src를 전부 붙여서 src의 인덱스가 NUL이거나 혹은 최종 dst의 길이가 dstsize에 도달하게 되면 멈춘다. 짧은 라인이지만 꽤 난이도가 있지 않나하고 생각한다...
- 이렇게 구현할 수가 있는데

~~~c
	while (src[p_src] && (p_src + dst_len) < dstsize - 1)
		dst[p_dst++] = src[p_src++];
~~~

- 이 경우 dstsize가 음수가 될 수 있기 때문에 dstsize에 1을 빼는 것은 권장하지 않는 방식이다. 