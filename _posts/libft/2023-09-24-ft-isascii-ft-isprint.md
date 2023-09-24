---
layout: post
title: "ft_isascii & ft_isprint"
description: >
    "ft_isascii, ft_isprint에 대하여"
category: libft
---
## ft_isascii & ft_isprint

### <목차>
{:.lead}
[1. MY CODES](#1-my-codes)
[2. 이야깃거리](#2-이야깃거리)

## (1) MY CODES

~~~c
#include "libft.h"

int	ft_isascii(int c)
{
	return (c >= '0' && c <= '127');
}

int	ft_isprint(int c)
{
	return (c >= 32 && c <= 126);
}
~~~

- 정수를 매개 변수로 받아 그것이 아스키 코드에 속하는지, 출력 가능한 문자인지 판별하는 간단한 함수.

## (2) 확장 아스키 코드

[이미지출처 : http://fsymbols.com/images/ascii.png]

 ![e-ascii](/assets/img/libft/ascii.png)


 - 우리가 흔히 아스키 코드라고 부르는 문자들은 주로 0번부터 127번까지를 뜻한다. 크게 세 가지 부분으로 나눌 수 있다.

 (1) 0 ~ 31번, 127번
	- 제어 코드로 출력 불가능하다. 주변 기기들을 제어할 때 사용된다. 출력이 안되기 때문에 정해진 형태가 없어 위 이미지에는 임의의 그림으로 채워져 있다.

 (2) 32 ~ 126번
	- 인쇄 가능한 문자이다. 숫자, 문자, 그 외 출력 가능한 특수 문자들이 속해 있다.

 (3) 128 ~ 255번
	- 확장 아스키 코드이다. 만날 일이 흔하지 않다.
