---
layout: post
title: "ft_isalnum & ft_isalpha & ft_isdigit"
description: >
    "ft_isalnum, ft_isalpha, ft_isdigit에 대하여"
category: 42cursus
tags: libft
---
## ft_isalnum & ft_isalpha & ft_isdigit

### <목차>
{:.lead}
[1. MY CODES](#1-my-codes)

[2. 이야깃거리](#2-이야깃거리)

## (1) MY CODES

~~~c
#include "libft.h"

int	ft_isdigit(int c)
{
	return (c >= '0' && c <= '9');
}

int	ft_isalpha(int c)
{
	return ((c >= 'a' && c <= 'z) || (c >= 'A' && c <= 'Z'));
}

int	ft_isalnum(int c)
{
	return (ft_isalpha(c) || ft_isdigit(c));
}
~~~

## (2) 이야깃거리
- 정수 c를 매개 변수로 받아 그것이 아스키 번호 상의 알파벳인지, 숫자인지 판별하는 간단한 함수들이다. 위에서는 bool을 그대로 반환했는데 당시에 만들때는 얌전하게 if, else로 반환했었다. 

~~~c
#include "libft.h"

int	ft_isalnum(int c)
{
	if (ft_isalpha(c) || ft_isdigit(c))
		return (1);
	else
		return (0);
}
~~~

- 이렇게...
- 지금보니 else도 필요없다.

~~~c
#include "libft.h"

int	ft_isalnum(int c)
{
	if (ft_isalpha(c) || ft_isdigit(c))
		return (1);
	return (0);
}
~~~

- else만 없어졌을 뿐인데 훨씬 보기 좋아진 모습.
