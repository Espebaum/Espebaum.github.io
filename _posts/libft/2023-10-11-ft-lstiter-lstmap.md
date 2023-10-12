---
layout: post
title: "ft_lstiter, ft_lstmap"
description: >
    "ft_lstiter, ft_lstmap에 대하여"
category: libft
---
## [bouns] ft_lstiter & ft_lstmap

### <목차>
{:.lead}
[1. MY CODES](#1-my-codes)

[2. 사용법](#2-사용법)

> ft_lstiter -- Iterates the list ’lst’ and applies the function ’f’ on the content of each node.

> ft_lstmap -- Iterates the list ’lst’ and applies the function ’f’ on the content of each node. Creates a new list resulting of the successive applications of the function ’f’. The ’del’ function is used to delete the content of a node if needed.

## (1) MY CODES
~~~c
#include "libft.h"

typedef struct	s_list
{
	void			*content;
	struct s_list	*next;
}				t_list;

void	ft_lstiter(t_list *lst, void (*f)(void *))
{
	while (lst)
	{
		f(lst->content);
		lst = lst->next;
	}
}

t_list	*ft_lstmap(t_list *lst, void *(*f)(void *), void (*del)(void *))
{
	t_list	*ptr;
	t_list	*tmp;
	void	*new_content;

	ptr = NULL;
	while (lst)
	{
		new_content = f(lst->content);
		tmp = ft_lstnew(new_content);
		if (!tmp)
		{
			del(new_content);
			ft_lstclear(&ptr, del);
			return (NULL);
		}
		ft_lstadd_back(&ptr, tmp);
		tmp = tmp->next;
		lst = lst->next;
	}
	return (ptr);
}
~~~

## (2) 사용법
~~~c
void	*Mylower(void	*content)
{
	int	idx = 0;
	int	len = strlen((char*)content);
	char	*lower = (char*) malloc(len + 1);
	while (idx < len)
	{
		lower[idx] = tolower(((char *)content)[idx]);
		idx++;
	}
	lower[idx] = '\0';
	return lower; 
}

void	MyUpper(void	*content)
{
	int	idx = 0;
	int	len = strlen((char*)content);
	char	*upper = (char*) malloc(len + 1);
	while (idx < len)
	{
		upper[idx] = toupper(((char *)content)[idx]);
		idx++;
	}
	idx = 0;
	while (idx < len)
	{
		((char *)content)[idx] = upper[idx];
		idx++;
	}
	upper[idx] = '\0';
}

int main()
{
	char	*tom = (char*)malloc(sizeof(char) * 4);
	tom[0] = 'T'; tom[1] = 'o'; tom[2] = 'm'; tom[3] = '\0';
	char	*kim = (char*)malloc(sizeof(char) * 4);
	kim[0] = 'K'; kim[1] = 'i'; kim[2] = 'm'; kim[3] = '\0';
	char	*jay = (char*)malloc(sizeof(char) * 4);
	jay[0] = 'J'; jay[1] = 'a'; jay[2] = 'y'; jay[3] = '\0';

	t_list*		a = ft_lstnew(tom);
	t_list*		b = ft_lstnew(kim);
	t_list*		c = ft_lstnew(jay);

	ft_lstadd_front(&a, b);
	ft_lstadd_back(&b, c);
	ft_lstiter(b, MyUpper); 
	// b로 시작하는 연결 리스트에 MyUpper 함수 적용

	printf("b->content : %s\n", b->content);
	printf("b->next->content : %s\n", b->next->content);
	printf("b->next->next->content : %s\n", b->next->next->content);

	t_list*		new_name = ft_lstmap(b, Mylower, freeWord);
	// b로 시작하는 연결 리스트에 Mylower 함수를 적용시킨 새로운 연결 리스트 new_name을 할당한 후 반환

	printf("new_name->content : %s\n", new_name->content);
	printf("new_name->next->content : %s\n", new_name->next->content);
	printf("new_name->next->next->content : %s\n", new_name->next->next->content);
	
	ft_lstclear(&b, freeWord);
	ft_lstclear(&new_name, freeWord);
	return 0;
}
~~~
~~~plain
output :
	b->content : KIM
	b->next->content : TOM
	b->next->next->content : JAY
	new_name->content : kim
	new_name->next->content : tom
	new_name->next->next->content : jay
	...
	0 leaks for 0 total leaked bytes.
~~~

- `ft_lstiter(t_list *lst, void (*f)(void *))`는 연결 리스트 시작 노드의 포인터(head)와 적용할 함수의 포인터를 매개 변수로 받아서, 연결 리스트의 모든 content에 함수를 적용시킨다. 위 예시 코드에서는 연결 리스트 b의 content인 이름들에 upper case를 적용시켜서 이름 전부를 대문자로 바꿔놓았다. **매개 변수로 받는 함수 포인터 f의 반환형은 void이고, 매개 변수로 void 포인터를 받는다. `ft_lstmap()`이랑 다르기 때문에 헷갈리면 안된다!**

- `ft_lstmap(t_list *lst, void *(*f)(void *), void (*del)(void *))`는 마찬가지로 연결 리스트 시작 노드의 포인터(head)와 적용할 함수의 포인터를 매개 변수로 받아서, 연결 리스트의 모든 content에 함수를 적용시켜서 만든 **새로운 연결 리스트**를 할당해서 반환한다. 위 예시 코드에서는 원래 존재하던 대문자 이름들로 구성된 연결 리스트 b에 함수를 적용하여 소문자 이름들로 구성된 새로운 연결 리스트 new_name을 반환받았다.  **매개 변수로 받는 함수 포인터 f의 반환형은 void 포인터고, 매개 변수로는 마찬가지로 void 포인터를 받는다. `ft_lstiter()`랑 다르다!**

- `ft_lstmap()`에서는 새로운 연결 리스트를 만들어가는 도중, 메모리 할당에 실패하면 여태까지 만들었던 새로운 연결 리스트들을 전부 해제해줘야 하는데, 이때 **새로운 연결 리스트의 content에 넣기 위해 새로 만든 new_content도 해제해줘야 한다**. 이를 생략하면 메모리 누수가 발생한다. 이를 통해 보았을 때, 함수 포인터로 받아야하는 함수에도 동적 할당이 포함되어 있음을 알 수 있다. 아래는 예시 코드에서 사용한 함수 포인터 f가 가리킨 myLower, myUpper 함수이다. **lstmap과 lstiter에서 요구하는 함수 포인터들의 반환형이 다른 만큼, 두 함수들의 반환형도 다르다(void, void *)**.

~~~c
void	*Mylower(void	*content)
{
	int	idx = 0;
	int	len = strlen((char*)content);
	char	*lower = (char*) malloc(len + 1);
	while (idx < len)
	{
		lower[idx] = tolower(((char *)content)[idx]);
		idx++;
	}
	lower[idx] = '\0';
	return lower; 
}

void	MyUpper(void	*content)
{
	int	idx = 0;
	int	len = strlen((char*)content);
	char	*upper = (char*) malloc(len + 1);
	while (idx < len)
	{
		upper[idx] = toupper(((char *)content)[idx]);
		idx++;
	}
	idx = 0;
	while (idx < len)
	{
		((char *)content)[idx] = upper[idx];
		idx++;
	}
	upper[idx] = '\0';
}
~~~
