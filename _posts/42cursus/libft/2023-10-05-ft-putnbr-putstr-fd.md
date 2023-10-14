---
layout: post
title: "ft_putnbr_fd & ft_putstr_fd"
description: >
    "ft_putnbr_fd, ft_putstr_fd에 대하여"
category: 42cursus
tags: libft
---
## ft_putnbr_fd & ft_putstr_fd

### <목차>
{:.lead}
[1. MY CODES](#1-my-codes)

> putnbr --- output a number to a stream

> putstr --- output a string to a stream

## (1) MY CODES

~~~c
#include "libft.h"

// putnbr, used recursion
void	ft_putnbr_fd(int n, int fd)
{
	long long	num;
	char		c;

	num = (long long) n; // num을 long long n으로 받지 않으면 예외 발생(-2147483648)
	if (num < 0)
	{
		write(fd, "-", 1);
		num *= -1;
	}
	if (num >= 10)
		ft_putnbr_fd(num / 10, fd);
	c = num % 10 + '0';
	write(fd, &c, 1);
}

// putstr
void	ft_putstr_fd(char *s, int fd)
{
	write(fd, s, ft_strlen(s));
}
~~~

- putstr의 경우 문자열과 파일 디스크립터를 매개변수로 받아서, 문자열의 바이트 수만큼 fd에 출력하는 간단한 함수이다.
- putnbr의 경우 마찬가지로 정수와 파일 디스크립터를 매개변수로 받아서 정수를 fd에 출력하는 함수인데, 하나 눈여겨볼 것은 정수가 캐릭터로 바뀌는 방식이다. 위 코드에서는 재귀를 사용했는데, 재귀를 사용한 코드가 으레 그렇듯이 반복문을 사용할 수도 있다(ft_itoa와 비슷한 컨셉).

### * 반복문을 사용한 코드
~~~c
// putnbr, used while loop
void	ft_putnbr_fd(int n, int fd)
{
	long long	num;
	long long	num2;
	int			idx;
	int			i;
	char		*buf;

	idx = 0;
	i = 0;
	num = (long long) n; // num을 long long n으로 받지 않으면 예외 발생(-2147483648)
	if (num < 0)
	{
		write(fd, "-", 1);
		num *= -1;
	}
	num2 = num;
	while (num != 0)
	{
		idx++;
		num /= 10;
	}
	buf = (char *) malloc(sizeof(char) * (idx + 1));
	while (num2 != 0)
	{
		buf[i++] = num2 % 10 + '0';
		num2 /= 10;
	}
	while (idx > 0)
		write(1, &buf[--idx], 1);
}
~~~
- 재귀를 사용하지 않고 반복문을 사용하게 되면 이슈가 좀 있다. 정수의 나머지를 출력한다는 방식 자체는 똑같은데, 정방향으로 while문을 돌면서 출력하면 나머지 연산의 특성상 **역순**으로 출력된다. 예를 들어 1234를 출력한다고 했을때, 1234 % 10인 4를 맨 먼저 출력하고, 그 다음으로 123 % 10인 3을 출력하고..., 결과적으로 4321을 출력하게 된다. 이것은 우리가 의도한 바가 아니다.
- 그래서 매개 변수로 들어온 정수의 자릿수를 세어서 그만큼의 문자열을 동적 할당하고 나머지 연산으로 그 문자열을 채워넣은 다음, **역순**으로 읽어서 스트림에 출력해야 한다. 아무래도 재귀를 사용할 때보다는 훨씬 해야할 일이 많다...
- 여기서도 ft_itoa에서 겪었던 이슈인 **num = (long long) n;** 라인이 등장한다. num이 long long이 아니라면 -2147483648에서 -를 지우기 위해 -1을 곱할 때 발생하는 오버플로우로 값이 변형되기 떄문에, 마찬가지로 num은 반드시 long long이어야만 한다.
- 아무래도 norminette에 부합하는 코드를 짜기 위해서는 자릿수를 세는 함수를 따로 만들어야 할 것 같다. ft_itoa에서는 ft_len이라는 함수를 따로 만들어서 자릿수를 세었었다.