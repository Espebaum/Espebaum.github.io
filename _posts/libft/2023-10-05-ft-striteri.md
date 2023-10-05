---
layout: post
title: "ft_striteri"
description: >
    "ft_striteri에 대하여"
category: libft
---
## ft_striteri & Function pointer

### <목차>
{:.lead}
[1. MY CODES](#1-my-codes)

> striteri -- 함수 포인터를 사용하여 문자열에 함수를 적용해보자

## (1) MY CODES
~~~c
#include "libft.h"

void	ft_striteri(char *s, void (*f)(unsigned int, char*))
{
	size_t	i;

	i = 0;
	while (s[i])
	{
		f(i, &s[i]);
		i++;
	}
}
~~~
- 매개변수로 함수를 적용할 문자열과, 적용할 함수의 포인터를 받는다.
- 여기서 함수 포인터 f가 가리키는 함수는 unsigned int와 문자열을 매개변수로 받고, 반환값은 존재하지 않는다.

## (2) 함수 포인터
- 함수 포인터, 사용할 일이 생길때마다 다시 공부하게 되는 악질적인 녀석이다. 사용할 일이 거의 없지만, 작동 방식은 이해해두는 것이 좋다고 생각한다.

> 함수에도 주소가 있다.

- 우리가 변수의 포인터는 줄기차게 사용하기 때문에 익숙하지만, 함수의 포인터는 그렇지 않기 때문에 잘 와닿지 않는 사실이다. 매개변수 포인터 값을 출력할 수 있는 것처럼 함수 포인터 값도 출력할 수 있다.

~~~c
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int	foo()
{
	return 5;
}

int main()
{
	char	*num = "apple";
	printf("%p %p\n", num, foo);
}
~~~
~~~plain
output:
	0x105bf8f9e 0x105bf8f30
~~~
- 결과값을 보면 알 수 있다시피, apple의 포인터값은 "0x105bf8f9e"이고, 함수 foo의 포인터값은 "0x105bf8f30"이다. 함수 포인터의 크기의 경우 컴파일러와 아키텍처에 따라 달라질 수 있는데, 일반적으로 대부분의 현대 32-bit 시스템에서는 함수 포인터는 4바이트 크기를 가지며, 64-bit 시스템에서는 8바이트 크기를 가진다. 이것이 대부분의 컴파일러에서 사용하는 표준 크기로 알려져 있다. 함수 포인터의 대략적인 사용에 대해 살펴보자.

~~~c
#include <stdio.h>

int add(int a, int b) { return a + b; }

int subtract(int a, int b) { return a - b; }

int main() 
{
    int (*operation)(int, int); // 함수 포인터 선언

    operation = add; // 함수 포인터 초기화
    int result = operation(5, 3); // 함수 포인터를 사용하여 add 함수 호출
    printf("Result : %d\n", result);

    operation = subtract; // 함수 포인터를 subtract 함수로 변경
    result = operation(5, 3);
    printf("Result : %d\n", result);

    return 0;
}
~~~

### (1) 함수 포인터 선언
~~~c
	int (*operation)(int, int);
~~~
- 여느 변수와 같이 맨 앞의 int는 반환형이다. (*operation)은 함수 포인터의 이름이다. 마음대로 지어도 된다. (int, int)는 함수가 받는 매개변수를 의미한다. operation이 가리키는 함수는 한 쌍의 int를 매개변수로 받는다. 괄호가 비어있으면 매개변수가 없다는 것을 의미한다(void).
~~~c
	void (*func)();
~~~
- 이 함수 포인터는 void 형이며, 이름은 func이고, 가리키는 함수는 매개변수를 받지 않는 함수이다.

### (2) 함수 포인터 초기화 및 호출
~~~c
#include <stdio.h>

int add(int a, int b) { return a + b; }
...
	operation = add; // 함수 포인터 초기화
	int result = operation(5, 3); // 함수 포인터를 사용하여 add 함수 호출
	printf("Result : %d\n", result); // output: 8
...
~~~
- 이렇게 보니 그냥 보통 변수랑 사용 방법이 다른게 거의 없다. 함수이기 때문에 결과값은 int 변수에 담을 수 있다는 점이 눈에 띈다. 이렇게 줄줄 써놓고 나니, 왜 함수 포인터를 사용하는지에 대한 의문이 생겨난다. 
- **함수에 주소가 존재하고, 함수를 매개변수로 담을 수 있다는**