---
layout: post
title: "ft_lstdelone, ft_lstclear"
description: >
    "ft_lstdelone, ft_lstclear에 대하여"
category: 42cursus
tags: libft
---
## [bonus] ft_lstdelone & ft_lstclear

### <목차>
{:.lead}
[1. MY CODES](#1-my-codes)

[2. 사용법](#2-사용법)

> ft_lstdelone -- Takes as a parameter a node and frees the memory of the node’s content using the function ’del’ given as a parameter and free the node. The memory of ’next’ must not be freed.

> ft_lstclear -- Deletes and frees the given node and every successor of that node, using the function ’del’ and free(3). Finally, the pointer to the list must be set to NULL.

## (1) MY CODES
~~~c
#include "libft.h"

typedef struct	s_list
{
	void			*content;
	struct s_list	*next;
}				t_list;

void	ft_lstdelone(t_list *lst, void (*del)(void *))
{
	del(lst->content);
	free(lst);
}

void	ft_lstclear(t_list **lst, void (*del)(void *))
{
	t_list	*tmp;
	t_list	*curr;

	curr = *lst;
	while (curr)
	{
		tmp = curr->next;
		ft_lstdelone(curr, del);
		curr = tmp;
	}
	*lst = NULL;
}
~~~

## (2) 사용법
~~~c
int main()
{
	char	*tom = (char*)malloc(sizeof(char) * 4);
	tom[0] = 'T'; tom[1] = 'o'; tom[2] = 'm'; tom[3] = '\0';
	char	*kim = (char*)malloc(sizeof(char) * 4);
	kim[0] = 'K'; kim[1] = 'i'; kim[2] = 'm'; kim[3] = '\0';
	char	*jay = (char*)malloc(sizeof(char) * 4);
	jay[0] = 'J'; jay[1] = 'a'; jay[2] = 'y'; jay[3] = '\0';
	// 이름 동적 할당

	t_list*		a = ft_lstnew(tom);
	t_list*		b = ft_lstnew(kim);
	t_list*		c = ft_lstnew(jay);

	ft_lstadd_front(&a, b);
	ft_lstadd_back(&b, c);

	printf("b->content : %s\n", b->content);
	printf("b->next->content : %s\n", b->next->content);
	printf("b->next->next->content : %s\n", b->next->next->content);

	ft_lstclear(&b, free_name); 
	// 함수 포인터 자리에 메모리 해제 함수를 포함시켜야 함.
	return 0;
}
~~~
~~~plain
output :
	b->content : Kim
	b->next->content : Tom
	b->next->next->content : Jay
	...
	0 leaks for 0 total leaked bytes.
~~~

- 여태까지 ft_lstnew, ft_lstadd 등을 설명하면서 예시 코드에 노드를 해제하는 코드를 넣을 때 아래와 같이 해제했었다.

~~~c
	...
	free(b->next->next);
	free(b->next);
	free(b);
	...
~~~

- 이렇게 해제해도 해제가 되기는 한다. 그러나 보기 좋은 방식은 아니라고 말할 수 있다. 또 content가 동적으로 할당된 메모리일 경우 추가로 b->content에 대한 해제도 필요하다. `ft_lstdelone(t_list *lst, void (*del)(void *))`은 **노드 하나와 그 안의 content를 해제**하고, `ft_lstclear(t_list **lst, void (*del)(void *))`는 **연결 리스트 전체(전체 노드, 그 안의 모든 content들)**를 해제한다. [함수 포인터와 콜백 함수](https://espebaum.github.io/libft/2023-10-05-ft-striteri/)에서 공부한 바 있듯이, 두 함수 모두 **콜백 함수**이다. 살펴보았을 때 함수 포인터에 매개 변수로 들어갈 함수는 **최소한 void 포인터인 b->content에 대한 메모리 해제 라인을 반드시 포함**하고 있어야 할 것이다. 

### * 예제 함수 freeWord
~~~c
void	free_name(void	*content)
{
	free(content);
}	// ft_lstdelone()에서 해당 함수 호출
~~~

- `ft_lstclear(t_list **lst, void (*del)(void *))`는 반복문을 돌면서 연결 리스트 전체를 해제하고, 마지막으로 시작점인 *lst를 NULL로 정해줌으로써, 연결 리스트가 비어있음을 나타낸다.

- curr을 해제하면, 다시 curr로 접근할 수 없으므로 미리 다음 노드의 주소를 tmp = curr->next로 따준 이후 해제했다.

~~~c
	...
	while (curr)
	{
		tmp = curr->next;
		ft_lstdelone(curr, del);
		curr = tmp;
	}
	...
~~~

