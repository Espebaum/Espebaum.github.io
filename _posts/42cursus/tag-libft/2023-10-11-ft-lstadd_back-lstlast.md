---
layout: post
title: "ft_lstlast, ft_lstadd_back"
description: >
    "ft_lstlast, ft_lstadd_back에 대하여"
category: 42cursus
tags: libft
---
## [bonus] ft_lstlast & ft_lstadd_back

### <목차>
* MY CODES
{:toc}
{:.lead}
[1. MY CODES](#1-my-codes)

[2. 사용법](#2-사용법)

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

t_list	*ft_lstlast(t_list *lst)
{
	if (!lst)
		return (NULL);
	while (lst->next)
		lst = lst->next;
	return (lst);
}

void	ft_lstadd_back(t_list **lst, t_list *new)
{
	t_list	*last;

	if (*lst == NULL)
	{
		*lst = new;
		return ;
	}
	last = ft_lstlast(*lst);
	last->next = new;
}
~~~

## (2) 사용법
~~~c
int main()
{
	t_list*		a = ft_lstnew("gyopark");
	t_list*		b = ft_lstnew("eunrlee");
	t_list*		c = ft_lstnew("sanghyol");

	ft_lstadd_front(&a, b);
	ft_lstadd_back(&b, c);

	printf("b->content : %s\n", b->content);
	printf("b->next->content : %s\n", b->next->content);
	printf("b->next->next->content : %s\n", b->next->next->content);

	free(b->next->next);
	free(b->next);
	free(b);
	return 0;
}
~~~
~~~plain
output :
	b->next->next->content : sanghyol
	b->next->content : gyopark
	b->content : eunrlee
~~~

- [ft_lstadd_front](https://espebaum.github.io/42cursus/ft-lstadd-front-lstsize.html) 과제에서 a, b 노드를 만들고, a 노드 앞에 b 노드를 add_front하여 b -> a -> NULL 모양의 연결 리스트를 만들어내었었다. 위 코드에서는 b -> a -> NULL인 연결 리스트에 c를 add_back 하여 b -> a -> c -> NULL인 연결 리스트를 만들었다. 아래 그림을 보자.

 ![ex3-list](/assets/img/libft/ex3-linked-list.png){:.lead width="800" height="150"}

- `ft_lstadd_front(t_list **lst, t_list *new)`함수는 연결 리스트의 head의 포인터(t_list **lst)와, 새롭게 맨 앞에 둘 노드 new를 매개 변수로 받아 new 노드를 맨 앞으로 옮기고 시작점 head(t_list *lst)를 (t_list *) new로 변경했지만, `ft_lstadd_back(t_list **lst, t_list *new)`에서는 new 노드를 연결 리스트의 맨 뒤에 이어 붙인다. `ft_lstnew()`로 노드를 만들 때, 끝은 NULL로 처리되었으므로 따로 끝처리는 할필요가 없고, 또 시작 부분은 바뀌지 않았으므로 head를 손댈 필요도 없다. new 노드를 맨 뒤에 붙이는데 사용한 함수가 `ft_lstlast(t_list *lst)`이다.

- `ft_lstlast(t_list *lst)`는 예의 반복문
~~~c
...
	while (lst->next)
		lst = lst->next;
	return (lst);
...
~~~

- 을 순회하면서 마지막 노드인 lst를 찾아 반환한다. while 문의 조건이 `lst->next`인 이유는 lst->next인 노드가 마지막 노드이기 때문이다. 