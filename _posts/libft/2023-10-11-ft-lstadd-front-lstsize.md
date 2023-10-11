---
layout: post
title: "ft_lstadd_front, ft_lstsize"
description: >
    "ft_lstadd_front, ft_lstsize에 대하여"
category: libft
---
## [bouns] ft_lstadd_front & ft_lstsize

### <목차>
{:.lead}
[1. MY CODES](#1-my-codes)

[2. ft_lstadd_front 사용법](#2-ft_lstadd_front-사용법)

[3. ft_lstadd_front 상세한 설명](#3-ft_lstadd_front-상세한-설명)

[4. ft_lstsize 사용](#4-ft_lstsize-사용)

> ft_lstadd_front -- Adds the node ’new’ at the beginning of the list.

> ft_lstsize -- Counts the number of nodes in a list.

## (1) MY CODES
~~~c
#include "libft.h"

typedef struct	s_list
{
	void			*content;
	struct s_list	*next;
}				t_list;

void	ft_lstadd_front(t_list **lst, t_list *new)
{
	new->next = *lst;
	*lst = new;
}

int	ft_lstsize(t_list *lst)
{
	int	size;

	size = 0;
	while (lst)
	{
		lst = lst->next;
		size++;
	}
	return (size);
}
~~~

- `ft_lstadd_front(t_list **lst, t_list *new)` 함수는 새로운 노드 new를 기존에 존재했던 연결 리스트의 시작점에 위치시키고, head를 new의 포인터로 바꿔놓는다.

## (2) ft_lstadd_front 사용법
~~~c
#include "libft.h"

void	ft_lstadd_front(t_list **lst, t_list *new)
{
	new->next = *lst;
	*lst = new;
}

int	ft_lstsize(t_list *lst)
{
	int	size;

	size = 0;
	while (lst)
	{
		lst = lst->next;
		size++;
	}
	return (size);
}

int main()
{
	t_list*		a;

	a = ft_lstnew("gyopark");
	printf("a->content : %s\n", a->content);
	printf("--------------------\n");

	t_list*		b;
	b = ft_lstnew("eunrlee");
	ft_lstadd_front(&a, b);
	printf("b->content : %s\n", b->content);
	printf("a->content : %s\n", b->next->content);
	printf("size of linked list : %d\n", ft_lstsize(b));
	free(b->next);
	free(b);
	return 0;
}
~~~
~~~plain
output :
	a->content : gyopark
	---------------------
	b->content : eunrlee
	a->content : gyopark
	size of linked list : 2
~~~
- 지난 `ft_lstnew()`에서 새로운 노드를 만들었었다. 위 코드는 그 노드 앞에 또다른 새로운 노드를 위치시키고 head를 새로운 노드의 포인터로 바꾸어놓는다. 즉...

 ![ex1-list](/assets/img/libft/ex1-linked-list.png){:.lead width="600" height="150"}

- 원래는 다음과 같았던 노드 하나짜리 연결 리스트 앞에

 ![ex2-list](/assets/img/libft/ex2-linked-list.png){:.lead width="800" height="150"}

- 새로운 노드 하나가 추가되었다고 보면 된다. lst 포인터는 항상 맨 앞의 노드를 가리키는 포인터이기 때문에 맨 앞의 노드가 바뀌면 항상 그 노드를 가리키도록 바꿔야 한다.

## (3) ft_lstadd_front 상세한 설명
~~~c
void	ft_lstadd_front(t_list **lst, t_list *new)
{
	// p lst, (t_list **) $1 = 0x00007ffeefbff500
	new->next = *lst; 
	*lst = new;
	// p new->next (s_list *) $2 = 0x0000000100604080
	// p new, (t_list *) $3 = 0x0000000100604090
	// p *lst (t_list *) $4 = 0x0000000100604090
}

int main()
{
	t_list*		a = ft_lstnew("gyopark"); // (t_list *) a = 0x0000000100604080
	t_list*		b = ft_lstnew("eunrlee"); // (t_list *) b = 0x0000000100604090 
	ft_lstadd_front(&a, b); // (t_list *) a, b = 0x0000000100604090 
	printf("size of linked list : %d\n", ft_lstsize(b));
	free(b->next);
	free(b);
	return 0;
}
~~~

- 이 ft_lstadd_front를 통해 헤드 포인터가 바뀌는 과정을 상세히 보여주자면 위 코드와 같다. 

### 1. 맨 처음 (t_list*) a의 메모리 주소가 `0x0000000100604080`로 할당된다. 이후 (t_list*) b의 메모리 주소가 `0x0000000100604090`로 할당된다.
  -> `sizeof(t_list*)`는 8 바이트인데, t_list 구조체 자체는 void 포인터와 t_list 포인터를 하나씩 갖고 있기 때문에, **구조체의 바이트 패딩**으로 인해 구조체 b는 구조체 a의 16바이트 뒤에 할당된다. 즉, `sizeof(t_list) = 16`이다. 차이가 느껴지는가?

### 2. ft_lstadd_front(&a, b)를 지나면서 a와 b가 동일한 주소를 가리키게 된다. 어떻게 된걸까?
~~~c
void	ft_lstadd_front(t_list **lst, t_list *new)
~~~
  -> ft_lstadd_front의 매개변수로 전해진 (t_list** ) lst는 (t_list*) a의 포인터이고(&a), new는 (t_list*) b 자신이다. 

~~~c
void	ft_lstadd_front(t_list **lst, t_list *new)
{
	new->next = *lst; 
	*lst = new;
}
~~~
~~~plain
p lst, (t_list **) $1 = 0x00007ffeefbff500
p new->next (s_list *) $2 = 0x0000000100604080
p new, (t_list *) $3 = 0x0000000100604090
p *lst (t_list *) $4 = 0x0000000100604090
(t_list *) a, b = 0x0000000100604090 
~~~
  -> 원래라면 NULL을 가리키고 있었을 new->next를 *lst를 가리키도록 한다. *lst는 a이므로, new->next는 a를 가리키게 된다(0x0000000100604080). 이제 b(new)의 next는 a를 가리키게 된다. 이후 *lst를 new로 변경한다. 이제 *lst는 a가 아니라 b(0x0000000100604090)를 가리키게 된다. a의 경우, a의 포인터값(이중 포인터 &a)가 매개변수로 전달되었으므로 일련의 변화가 스코프 바깥으로 벗어나도 적용된다. 결과적으로 a와 b가 둘다 메모리 주소 0x0000000100604090(b의 주소)를 가리키게 되는 것이다. 이 부분과 관련해서 실수하기 쉬운 부분이 있다. 

~~~c
int main()
{
	t_list*		a = ft_lstnew("gyopark"); // (t_list *) a = 0x0000000100604080
	t_list*		b = ft_lstnew("eunrlee"); // (t_list *) b = 0x0000000100604090 
	ft_lstadd_front(&a, b); // (t_list *) a, b = 0x0000000100604090 
	printf("size of linked list : %d\n", ft_lstsize(b));
	free(a);
	free(b); // a와 b가 동일한 곳을 가리키는데, 이미 a가 해제되었기 때문에 더블 free 오류 발생
	return 0;
}
~~~
~~~plain
a.out(43073,0x110304dc0) malloc: *** error for object 0x7fdc80c05950: pointer being freed was not allocated
a.out(43073,0x110304dc0) malloc: *** set a breakpoint in malloc_error_break to debug
~~~

- ft_lstadd_front 함수를 통해 a와 b가 같은 곳을 가리키게 되는 과정을 보여주었다. 당연히 a를 free하고 b를 free하려고 하면 double free 오류가 발생할 것이다. **a에 접근하기 위해서는 b->next를 통해 접근해야 한다**.

## (4) ft_lstsize 사용

~~~c
int	ft_lstsize(t_list *lst)
{
	int	size;

	size = 0;
	while (lst)
	{
		lst = lst->next;
		size++;
	}
	return (size);
}
...
	printf("size of linked list : %d\n", ft_lstsize(b));
...
~~~
~~~plain
output: 
	sizeof linked list : 2
~~~
- 매개변수로 연결 리스트의 head를 받는다. head는 연결 리스트의 시작 노드의 주소이다. while 문을 순회하면서 노드의 개수를 세는데 i++하면서 숫자를 올리듯이 `lst = lst->next;`라는 라인을 통해 연결 리스트를 순회한다. 알다시피 연결 리스트의 마지막 노드의 next는 NULL을 가리키면서 연결 리스트의 종료를 알리는데, 그 점을 이용하여 연결 리스트를 순회한다. 한번 순회할 때마다 size를 올려서 연결 리스트의 총 노드의 개수를 알 수 있다.