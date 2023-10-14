---
layout: post
title: "ft_calloc & ft_memset"
description: >
    "ft_calloc, ft_memset에 대하여"
category: 42cursus
tags: libft
---
## ft_calloc & ft_memset

### <목차>
{:.lead}
[1. MY CODES](#1-my-codes)

[2. MAN CALLOC](#2-man-calloc)

[3. MAN MEMSET](#3-man-memset)

[4. MEMSET 주의점](#4-memset-주의점)

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

  void *malloc(size_t size);

  void *calloc(size_t count, size_t size);

DESCRIPTION
 The malloc() function allocates size bytes of memory and returns a pointer to the allocated memory.

 The calloc() function contiguously allocates enough space for count objects
 that are size bytes of memory each and returns a pointer to the allocated
 memory. The allocated memory is filled with bytes of value zero.
~~~

 - `malloc()`의 경우, size bytes 만큼의 메모리를 할당하고, 그 첫 번째 주소를 반환한다.
 - `calloc()`의 경우, 연속적으로 count만큼의 영역에, size bytes 만큼의 메모리를 할당한다. 할당된 메모리는 0으로 초기화된다.
 - 두 함수의 사용법이 미묘하게 다른데, 본질적으로는 동일하게 사용된다. 아래는 5개짜리 int 배열을 만들고 0으로 초기화하는 간단한 코드이다.

 - **count나 size가 0이면 calloc()은 NULL을 반환하거나, 이후 free()에 무사히 전달할 수 있는 고유한 포인터 값을 반환한다.**

   -> [calloc(3) - Linux man page](https://linux.die.net/man/3/calloc) 
   
   " The calloc() function allocates memory for an array of nmemb elements of size bytes each and returns a pointer to the allocated memory. The memory is set to zero. **If nmemb or size is 0, then calloc() returns either NULL, or a unique pointer value that can later be successfully passed to free().** "

 - **count와 size의 곱이 정수 오버플로우를 일으킬 경우 calloc()은 errno를 설정하고(ENOMEM) NULL을 반환한다.** 

~~~c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main()
{
	int*	arr = malloc(sizeof(int) * 5);
	memset(arr, 0, 5 * sizeof(int));
	int*	arr_c = calloc(5, sizeof(int) * 5);

	printf("%d, %d\n", arr[0], arr_c[0]);
}
~~~
~~~plain
output: 0, 0
~~~

 - malloc은 기본적으로 할당한 메모리를 초기화하지 않기 때문에, **별도의 초기화 작업**이 반드시 필요하다. 이 부분을 소홀히 하면 나중에 난리가 날 수 있기 때문에 신경써주도록 하자...

## (3) MAN MEMSET
~~~plain
SYNOPSIS
 #include <string.h>

  void *memset(void *b, int c, size_t len);

DESCRIPTION
 The memset() function writes len bytes of value c (converted to an unsigned char) to the string b.

RETURN VALUES
 The memset() function returns its first argument.
~~~

- 첫 번째 인자는 초기화하고자 하는 메모리의 첫 번째 주소, 두 번째 인자는 세팅하고자 하는 값 value, 세 번째 인자는 시작 메모리로부터 초기화하고자 하는 메모리의 size이다.
- 성공하면 초기화한 메모리의 첫 번째 주소를 반환하고 실패하면 NULL을 반환하는데, 보통은 반환받지 않고 동적 할당한 메모리를 초기화하는 용도로 주로 사용했던 기억이 난다.

## (4) MEMSET 주의점
~~~c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main()
{
	int*	arr = malloc(sizeof(int) * 5);
	memset(arr, 1, 5 * sizeof(int));

	for (int i = 0; i < 5; i++)
		printf("arr[%d] : %d\n", i, arr[i]);
}
~~~
~~~plain
output:
        arr[0] : 16843009
        arr[1] : 16843009
        arr[2] : 16843009
        arr[3] : 16843009
        arr[4] : 16843009
~~~

 - 정수로 초기화하겠다는 것은 4 bytes로 초기화하겠다는 것을 의미한다. 그러나 `memset()`은 1바이트씩 초기화하기 때문에 예상할 수 없는 방식으로 작동한다.
 - 따라서 0으로만 초기화하거나, 제한적으로 char만을 사용하여 초기화하는 것이 안전한 방법이다.
~~~plain
     0001  0001  0001  0001 => 16843009
    1byte 1byte 1byte 1byte

     0000  0000  0000  0001 => 1
                     4bytes
~~~
 - 저 16843009의 경우, 위와 같은 모습때문에 등장하게 된 숫자이다. memset에 0이외의 정수를 넣고 초기화하는 것이 어떤 식으로 작동하게 될 지 간접적으로 볼 수 있는 예제이기도 하다.