---
layout: post
title: "ft_lstlast, ft_lstadd_back"
description: >
    "ft_lstlast, ft_lstadd_back에 대하여"
category: libft
---
## [bouns] ft_lstlast & ft_lstadd_back

### <목차>
{:.lead}
[1. MY CODES](#1-my-codes)

> ft_lstlast -- Returns the last node of the list

> ft_lstadd_back -- Adds the node ’new’ at the end of the list.

## (1) MY CODES
~~~c
#include "libft.h"

typedef struct	s_list
{
	void			*content;
	struct s_list	*next;
}				t_list;

~~~

