---
layout: post
title: "ft_putchar_fd & ft_putendl_fd"
description: >
    "ft_putchar_fd, ft_putendl_fd에 대하여"
category: libft
---
## ft_putchar_fd & ft_putendl_fd

### <목차>
{:.lead}
[1. MY CODES](#1-my-codes)

[2. MAN PUTCHAR](#2-man-putchar)

[3. 이야깃거리](#3-이야깃거리)

> putchar --- output a character or word to a stream

## (1) MY CODES

~~~c
#include "libft.h"

void	ft_putchar_fd(char c, int fd)
{
	write(fd, &c, 1);
}

void	ft_putendl_fd(char *s, int fd)
{
	write(fd, s, ft_strlen(s));
	write(fd, "\n", 1);
}
~~~

## (2) MAN PUTCHAR
~~~plain
NAME
	fputc, putc, putc_unlocked, putchar, putchar_unlocked, putw 
		-- output a character or word to a stream
SYNOPSIS
	#include <stdio.h>

		int	fputc(int c, FILE *stream);
		int	putc(int c, FILE *stream);
		int	putchar(int c);
		int	putw(int w, FILE *stream);

DESCRIPTION
	The fputc() function writes the character c (converted to an ``unsigned
	char'') to the output stream pointed to by stream.

	The putc() macro acts essentially identically to fputc(), but is a macro
	that expands in-line.  It may evaluate stream more than once, so argu-
	ments given to putc() should not be expressions with potential side
	effects.

	The putchar() function is identical to putc() with an output stream of
	stdout.

	The putw() function writes the specified int to the named output stream.

RETURN VALUES
	The functions, fputc(), putc(), putchar(), return the character written.  
	If an error occurs, the value EOF is returned. The putw() function returns
	0 on success; EOF is returned if a write error occurs, or if an attempt 
	is made to write a read-only stream.
~~~
- 스트림에 캐릭터나 단어를 출력한다.

## (3) 이야깃거리

### 1. fputc & putc & putchar
- fputc() 함수는 매개변수로 들어온 int c를, 매개변수로 들어온 파일 스트림(stream)에 출력한다. 이때 c는 unsigned char로 변환된다.
- putc()는 fputc()와 동일한 작동을 하지만, **인라인 함수**로 선언되어 있다.
- putchar() 함수는 매개변수로 들어온 int c를 표준 출력(stdout)에 출력한다.
- 세 함수는 공통적으로 출력된 캐릭터 자체를 반환한다. 오류가 발생했을 때는 EOF가 반환된다.

### 2. ft_putchar_fd & ft_putendl_fd
- ft_putchar_fd는 캐릭터 c와 파일 디스크립터(fd)를 매개변수로 받아, 파일 디스크립터에 캐릭터 c를 출력한다.
- 마찬가지로 ft_putendl_fd는 문자열 s와 파일 디스크립터(fd)를 매개변수로 받아, 파일 디스크립터에 문자열 s를 출력하고 개행을 출력한다('\n').

### 3. 매크로 함수와 인라인 함수
- 보통 매크로 함수와 인라인 함수를 한묶음으로 이야기한다.

**- 매크로 함수**
~~~c
#include <stdio.h>

#define square(X) X*X
#define square2(X) ((X)*(X))

int main() 
{
    int x = 1;
    printf("%d %d\n", square(x + 3), square2(x + 3));
	return 0;
}
~~~
~~~plain
output:
	7 16
~~~
- 매크로 함수는 #define을 통해서 함수처럼 동작하는 매크로를 말한다. 매크로의 경우 **단순 치환**이므로 괄호를 씌운다던가 해서 관리를 빡세게 해주지 않으면 원하지 않는 결과값이 반환될 수 있다.

- 매크로 함수의 장단은 모두 작동 방식이 **단순 치환**이기 때문에 생겨난다. 매크로 함수의 장점은 **인수의 타입을 신경쓰지 않아도 된다**는 점과, **성능 저하가 없다는 점**이 있다. 매크로 함수의 단점은 **복잡한 기능을 하는 함수는 구현이 어렵다는 점**이고, 또 **괄호로 감싸야 하기 때문에 읽기가 힘들다**는 점이 있다. 사칙 연산 딴의 매크로라면 내부적으로 오버로딩이 되어있을 테니 타입은 신경쓰지 않고 매크로로 치환시켜 사용해도 되기 때문에 그 점은 편리한 것이고, 단순 치환이기 때문에 너무 복잡한 구현 사항은 만들어내기 어려울 것이니 그 점은 단점인 것이다.

**- 인라인 함수**
~~~c
#include <stdio.h>

inline int square(int x){
  return x * x;
}

int main()
{
    printf("%d\n", square(3));
}

~~~
~~~plain
output:
	9
~~~
- 인라인 함수는 **실행 속도**에서 이점을 가져갈 수 있다. 인라인 함수는 경우에 따라 일반 함수보다 실행 속도가 빠른데 두 방법이 함수를 호출하는 방식이 다르기 때문이다. 일반 함수의 자세한 호출 방식은 아래 링크의 스택 세그먼트(stack segment) 부분을 참조하자.

[소년코딩, C++ 08.10 - 스택과 힙 (Stack and Heap)](https://boycoding.tistory.com/235)

- 일반 함수를 호출하면 스택 세그먼트에 함수 호출이 발생되고, 스택 세그먼트(stack segment)에 함수의 매개 변수, 지역 변수, 함수가 종료되면 복귀할 주소 등등이 들어있는 스택 프레임(stack frame)이 push된 이후 CPU가 함수의 시작점으로 스코프를 옮기고 함수를 실행한다.
- 함수가 종료된 이후에는 스택 프레임이 pop되면서 지역 변수, 매개 변수에 할당된 메모리들이 해제되고, 반환 값이 처리되며 CPU는 반환 지점에서 다시 함수를 실행시킨다.

- 인라인 함수는 이런 과정을 거치지 않고 곧바로 코드를 실행시킨다. 이게 무슨 말이냐면...
~~~c
...
	inline int square(int x){ return x * x; }
...
	printf("%d\n", square(3));
...
~~~
- 이 코드를 실행할 때 위 설명처럼 스택을 타고 들어가서 square 함수를 실행시킨 이후 스택을 빠져나오는게 아니라

~~~c
	printf("%d\n", 3 * 3);
~~~
- 이렇게 실행해버린다는 것이다. 스택을 타는 과정이 없이 곧바로 코드가 치환되어 실행되기 때문에 실행 속도가 더 빠른 것이다.
- 물론 인라인 함수에도 단점은 존재한다. 아까 매크로 함수에서는 타입을 고려하지 않아도 상관없었는데, **인라인 함수의 경우 실행시킬 때 타입을 고려해야 한다**. 만약 아래 코드를 실행한다면 어떨까?

~~~c
...
	inline int square(int x){ return x * x; }
...
	printf("%d\n", square(3.1));
...
~~~
~~~plain
	main.c:9:27: warning: implicit conversion from 'double' to 'int' changes value from
		3.1 to 3 [-Wliteral-conversion]
		printf("%d\n", square(3.1));
				~~~~~~ ^~~
	1 warning generated.
~~~
- square는 매개변수 int형에 대해서만 정의되어 있고, double에 대해서는 정의되어 있지 않기 때문에 double이 int로 캐스팅되는 과정에서 **값의 손실**이 일어나게 된다. 이걸 막기 위해서는 double에 대한 square를 오버로딩하거나 템플릿을 사용해야 한다. 이 과정에서 오히려 코드가 길어질 수 있다.
- 또 함수 호출 단에서 치환되기 때문에 추가 메모리 할당인 필요하고, 그렇기 때문에 **메모리 측면에서는 일반 함수보다 비효율적**이라고 한다.
- inline 함수는 컴파일러에게는 일종의 권장 사항이라고 한다. 컴파일러는 inline 함수를 사용하는 것이 효율적이라면 inline 함수를 사용하고, 그렇지 않다면 사용하지 않을 수도 있다.

### 4. endl과 \n
- 둘 모두 개행을 위해 사용한다. endl은 출력 버퍼를 비우는 과정(flush)이 들어가 있어서 \n보다 느리다.
- 문자를 출력한다는 것은 대략 (1) 버퍼에 담는다, (2) 버퍼를 비우면서 출력한다의 두 과정으로 이루어지는데, endl을 사용하게 되면 1번과 2번이 동시에 실행되는 것이고, \n을 사용하면 1번 과정만 실행한다고 보면 된다. 아래 코드를 보자

~~~c 
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main()
{
	printf("%s", "abc");
	sleep(5);
	return 0;
}
~~~

- output은 알다시피, abc가 나오게 되는데 5초를 쉬고 abc가 나오게 된다. printf는 특성상 '\n'나 '\0'가 나올 때까지 문자들을 버퍼에 담아두었다가 출력되는데 abc에 '\n'이나 '\0'이 없었기 때문에 버퍼에 abc가 담긴 채로 5초를 기다리고, 함수가 끝나면서 커널에 의해 버퍼가 비워지면서 abc가 출력된다.

~~~cpp
#include <iostream>
#include <unistd.h>

int        main(void)
{
    std::cout << "hello" << std::endl;
    sleep(5);
    return (0);
}
~~~
- 이 경우, hello를 버퍼에 담고 버퍼를 비우면서 바로 출력하기 때문에 hello가 출력되고 5초를 기다렸다가 프로그램이 종료된다.