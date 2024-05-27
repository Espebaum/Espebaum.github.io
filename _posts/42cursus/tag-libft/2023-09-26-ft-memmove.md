---
layout: post
title: "ft_memmove"
description: >
    "ft_memmove에 대하여"
category: 42cursus
tags: libft
image: "/assets/img/libft/libft.webp"
---
## ft_memmove

### <목차>
* MY CODES
{:toc}
{:.lead}
[1. MY CODES](#1-my-codes)

[2. MAN MEMMOVE](#2-man-memmove)

[3. 메모리 비교](#3-메모리-비교)

[4. 반환값](#4-반환값)

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
- src로부터 dst에 n 바이트만큼을 복사해 넣는다. 두 문자열은 overlap 될 수 있다. 복사는 언제나 가능하며 비파괴적인 방법이다.

## (2) MAN MEMMOVE
~~~plain
SYNOPSIS
	#include <string.h>

	void *memmove(void *dst, const void *src, size_t len);

DESCRIPTION
	The memmove() function copies len bytes from string src to string dst.  
	The two strings may overlap; the copy is always done in a non-destructive manner.

RETURN VALUES
	The memmove() function returns the original value of dst.
~~~
- memcpy의 문제점이었던 메모리가 겹쳤을 때의 문제가 개선된 버전의 메모리 복사 함수이다. 메모리가 겹쳤을 때의 행동이 정해지지 않았던 memcpy와 달리(undefined behavior), memmove의 메모리 복사는 언제나 성공한다. 어떻게 그것이 가능할까?

## (3) 메모리 비교
~~~c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main()
{
	char	*str1 = "apple";
	char	*str2 = "banana";
	printf("str1: %p, str2: %p\n", str1, str2);

	if (str1 > str2)
		printf("str1 is bigger\n");
	else
		printf("str2 is bigger\n");

	return 0;
}
~~~
~~~plain
> output :
str1: 0x10af59f72, str2: 0x10af59f78
str2 is bigger
~~~
- 위 코드는 두 문자열을 선언하고, 메모리 포인터 값의 대소를 비교해보는 코드이다. 결과값은 매번 바뀔 수 있는데, 위 결과에서 확실한 것은 str2의 메모리가 str1보다 크다는 것이다. 이는 메모리 블록 위에 apple이 banana보다 앞에 위치하고 있다는 것을 의미한다. 또 메모리 값을 살펴보면 apple뒤에 바로 banana가 이어지고 있다는 점 또한 확인할 수 있다. 72부터 77까지가 각각 a, p, p, l, e, '\0'이고 78부터 'b'로 이어진다.
- memmove에서 메모리 overlap문제를 해결하는 방법은 메모리의 대소를 비교하여 각각의 경우 메모리가 겹칠 때 적절한 순서로 메모리 복사를 실행하는 것이다.

### * case 1
~~~c
.
.
.
	else
	{
		new_dest = (unsigned char *) dest + (n - 1);
		new_src = (unsigned char *) src + (n - 1);
		while (n--)
			*new_dest-- = *new_src--;
	}
.
.
.
~~~
- src의 메모리를 dest에 하나씩 복사하고자 한다. 위 경우, 메모리 블록 상 dest가 src보다 먼저 등장한다.
~~~plain
dest : 1 2 3 4 5 6 7
src  :     3 4 5 6 7 8 9
 -> dest의 포인터 값은 1의 주소이며, src의 포인터 값은 3의 주소이다. 편의상 dest와 src로 나누었지만
실제 메모리는 아래와 같이 존재한다.
mem  : 1 2 3 4 5 6 7 8 9
~~~
- 이 경우 우리가 평소에 하던 것과 같이 src의 처음부터 하나씩 dest에 복사해 넣는다. 이때 메모리가 overlap되어도 문제가 없다. memcpy에서도 보았듯이 메모리가 overlap 되었을 때 복사를 실행하는 과정에서 복사할 src가 변조될 수 있기 때문에 문제가 생기게 되는데 dest가 src보다 앞에 있다는 것이 보장되기 때문에 src가 변조될 일이 없다.

### * case 2
~~~c
.
.
.
	if (dest < src)
	{
		new_dest = (unsigned char *)dest;
		new_src = (unsigned char *)src;
		while (n--)
			*new_dest++ = *new_src++;
	}
.
.
.
~~~
- src의 메모리를 dest에 하나씩 복사하고자 한다. 위 경우, 메모리 블록 상 src가 dest보다 먼저 등장한다.
~~~plain
src  : 3 4 5 6 7 8 9
dest :     5 6 7 8 9 1 2
 -> src의 포인터 값은 3의 주소이며, dest의 포인터 값은 5의 주소이다. 편의상 src와 dest로 나누었지만
실제 메모리는 아래와 같이 존재한다.
mem  : 3 4 5 6 7 8 9 1 2
~~~
- 이 경우 src의 처음부터 dest에 복사하게 되면 src가 변조될 것이다. 구체적으로 말하면 메모리를 3개 이상 복사하게 되면 문제가 생길 것으로 볼 수 있다. 3을 5가 있는 자리에 복사하고, 4를 6이 있는 자리에 복사한 이후 5를 7이 있는 자리에 복사해야하는데 이미 5가 3으로 바뀌게 되기 때문이다. 이것을 방지하기 위해, src의 끝부터 처음까지 역순으로 dest에 복사하게 된다. 이렇게 되면 src가 dest보다 앞에 있다는 것이 보장되기 때문에 src가 변조될 일이 없다.

## (4) 반환값
- 매개변수로 들어온 dest를 그대로 반환한다.