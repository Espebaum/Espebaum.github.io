---
layout: post
title: "c++ Sort, Priority_queue 사용자 정의 비교 함수 사용법"
category: posts
tag: another
message: "알고리즘 문제를 풀때 자주 사용하는 std::sort, std::priority_queue의 사용자 정의 비교 함수의 사용법을 공부해보자."
---

* table of contents
{:toc}

## C++ Sort, Priority_queue 사용자 정의 비교 함수 사용법

### (1) 함수 포인터를 활용한 std::sort 사용자 정의 비교 함수 사용

- 알고리즘 문제들을 풀면서 std::sort를 사용해보지 않은 사람은 없을 것이다. std::sort의 명세는 아래와 같다.

~~~c++
template< class RandomIt >
void sort( RandomIt first, RandomIt last );

template< class RandomIt, class Compare >
void sort( RandomIt first, RandomIt last, Compare comp );
~~~

- 두 번째 사용법에서 'Compare'는 비교 함수 혹은 함수 객체가 될 수 있다. 함수 포인터는 함수의 주소를 저장하는 포인터이며, 함수처럼 호출될 수 있다. 함수 객체는 함수 호출 연산자(`operator()`)를 오버로딩한 객체이다. **Compare는 함수 객체와 함수 포인터 모두를 받아들일 수 있는 매개변수이다.**

- 즉, std::sort는 템플릿 매개변수로 정렬하고자 하는 컨테이너 반복자의 시작 부분, 끝 부분과 더불어 **함수 호출 연산자**를 받아들이는데, 이것이 sort가 함수 포인터, 함수 객체, 람다 표현식과 같이 `operator()`를 사용하는 어떠한 인자라도 받아들일 수 있다는 것을 의미한다.

- 함수 포인터는 함수 객체, 람다 표현식과 마찬가지로 그 자체로 함수 호출 연산자 ()를 통해 호출할 수 있도록 설계된 타입이다. Compare가 함수 포인터로 사용된 경우, sort 내부적으로 () 연산자를 사용하여 함수 포인터를 함수처럼 호출하여 요소들을 비교하고 정렬한다.

#### 예제: 함수 포인터를 사용하는 'std::sort'
~~~c++
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;
// 비교 함수
bool compare(int a, int b) {
    return a > b;
}

int main() {
    vector<int> v = {5, -3, 2, 1, 3, 4, 7, -5, -2, 1, 9, 6, -7, -4};

    // 함수 포인터를 사용하여 내림차순으로 정렬
    sort(v.begin(), v.end(), compare);

    for (int i : v)
        cout << i << " ";

    cout << endl;

    return 0;
}
~~~
~~~
❯ ./a.out
9 7 6 5 4 3 2 1 1 -2 -3 -4 -5 -7
~~~

- compare 함수를 작성하고 그 compare 함수를 가리키는 포인터를 매개변수로 sort 함수를 사용했다. compare 함수의 내용에 따라 벡터가 내림차순으로 정렬되었다(`return a > b;`).

### (2) 함수 객체를 활용한 std::sort, std::priority_queue 사용자 정의 비교 함수 사용

- **함수 객체(Function Object)는 함자(Functor)라는 이름으로도 사용한다.** 함수 객체는 함수처럼 작동할 수 있는 c++ 객체를 의미한다. 함수 객체는 함수 포인터보다 유연하며 상태를 저장하거나 추가 데이터를 포함할 수 있다는 장점이 있다.

#### 예제 1: 기본적인 함수 객체의 정의와 사용
~~~c++
#include <iostream>
using namespace std;

struct sayhi
{
    public:
        void operator()() const {
            cout << "Hi!!!" << '\n';
        }
};

int main()
{
    sayhi   hi;
    hi();
    return 0;
}
~~~
~~~
❯ ./a.out
Hi!!!
~~~

- 이것은 간단한 형태의 함수 객체로, `operator()`를 오버로딩하여 객체 자체가 함수처럼 호출될 수가 있다.

#### 예제 2: 상태를 가지는 함수 객체
~~~c++
#include <iostream>
using namespace std;

struct Adder {
    int increment;
    Adder(int inc) : increment(inc) {}

    int operator()(int value) const {
        return value + increment;
    }
};

int main() {
    int x = 10;
    Adder addFive(5);
    Adder addHundred(100);
    cout << addFive(x) << ' ' << addHundred(x) << endl;

    return 0;
}
~~~
~~~
❯ ./a.out
15 25
~~~

- 이런 식으로 함자를 사용하면, 기존의 함수라면 함수를 2개 만들어야 했을 상황해서 동일한 객체를 하나 더 생성하는 방식으로 풀어갈 수가 있다. 확실히 함수를 하나 더 작성하는 것보다 유연하다는 것이 느껴진다. 

- std::sort에서 함자를 사용하여 비교 함수를 전달하는 방식은 아래와 같다.

#### 예제 3: 함수 객체를 사용하는 'std::sort'

~~~c++
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

struct compare // class compare 로도 사용 가능
{
    public:
        bool    operator()(int a, int b) {
            return a > b;
        }
};

int main() {
    vector<int> v = {5, -3, 2, 1, 3, 4, 7, -5, -2, 1, 9, 6, -7, -4};

    // 함수 포인터를 사용하여 내림차순으로 정렬
    sort(v.begin(), v.end(), compare());

    for (int i : v)
        cout << i << " ";

    cout << endl;

    return 0;
}
~~~

- 마찬가지로 std::sort는 내부적으로 `operator()`를 호출하여 내부 연산을 실행한다. `operator()` 오버로딩 함수를 수정하여 다양한 기준으로 정렬을 실행할 수 있다. `bool operator()`의 내용이 반대로 `return a < b;` 였다면 반대로 오름차순으로 정렬되었을 것이다.

#### 예제 4: std::priority_queue의 타입 및 함수 객체 작성
~~~c++
template<
    class T,
    class Container = std::vector<T>,
    class Compare = std::less<typename Container::value_type>
> class priority_queue;

struct compare
{
    public:
        bool operator()(int a, int b) {
            // ... 로직을 구현한다.
            if (abs(a) != abs(b))
                return abs(a) > abs(b);
            return a > 0 && b < 0;
        }
}

// ... 일반적인 우선순위 큐의 선언
//std::priority_queue<int, vector<int>, less<int>> pq;
std::priority_queue<int, vector<int>, compare()> pq;
~~~

- **std::priority_queue의 경우 내부 비교 연산을 위해 함수 객체 혹은 람다 표현식을 사용해야 하며, 함수 포인터를 사용할 수 없다.** 그것은 priority_queue의 내부적인 구조와 관계가 있다. priority_queue의 템플릿 매개변수는 아래와 같다.

- T는 요소의 타입으로 보통 알고리즘을 풀때는 int로 사용한다. Container의 경우 요소를 저장할 컨테이너로 일반적으로 `vector<int>`를 사용한다. Compare는 요소를 비교할 함수 객체로, 기본적으로는 std::less를 사용하도록 되어있다(less<int>).

- 아까 std::sort의 경우 Compare 부분을 일반적인 타입으로 전달되었었다(`Compare comp`). 그러나 priority_queue는 비교자가 템플릿 매개변수로 전달되기 때문에 컴파일 타임에 비교자의 타입이 확정된다. 따라서 런타임에 확정되는 함수 포인터를 템플릿 인자로 받을 수가 없다.

- 구현 자체는 sort와 동일하다. 위 예제의 함자에서는 절댓값이 같다면 작은 쪽이 우선순위 큐의 top으로 오도록, 같다면 작은 값이 top으로 오도록 조정한다.

### (3) 람다 표현식을 활용한 std::sort, std::priority_queue 사용자 정의 비교 함수 사용

- 람다 표현식은 c++11부터 도입된 기능으로, **익명 함수**를 정의하는 간단한 방법을 제공한다. 람다 표현식을 사용하면 함수 포인터나 함수 객체로 사용할 수 있는 기능을 더 직관적으로 사용할 수 있다. 람다 표현식의 기본 문법은 아래와 같다.

~~~c++
[캡쳐](매개변수) -> 반환형 { 함수 본문 }
~~~
1. 캡처: 람다 표현식이 자신을 감싸고 있는 스코프에 있는 변수들을 어떻게 캡처할 것인지를 지정한다.

2. 매개변수: 함수와 마찬가지로 람다의 매개변수이다.

3. 반환형: 함수의 반환형을 지정한다. 자동 추론이 가능하면 생략할 수 있다.

4. 함수 본문: 람다 표현식이 실행할 코드 블록이다.

- **캡처 방식**은 아래와 같다.

1. `[&]` : 외부 스코프의 모든 변수를 참조로 캡처한다.

2. `[=]` : 외부 스코프의 모든 변수를 값으로 캡처한다.

3. `[this]` : 현재 객체의 포인터를 캡처한다.

4. `[x, &y]` : x는 값으로, y는 참조로 캡처한다.

#### 예제1: 람다 표현식 사용법 몇 가지 예제

~~~c++
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    int x = 30; int y = 15;

    // 일반적인 람다 함수의 사용 (x, y가 안변함)
    auto change1 = [](int x, int y) -> int {
        int nx = x + y ;
        int ny = x - y; 
        x = nx; y = ny;
        return 0;
    };

    // 매개변수로 참조 (x, y가 변함)
    auto change2 = [](int &x, int& y) -> int {
        int nx = x + y ;
        int ny = x - y; 
        x = nx; y = ny;
        return 0;
    };

    // 참조로 캡처 (x, y가 변함)
    auto change3 = [&x, &y]() -> int {
        int nx = x + y ;
        int ny = x - y; 
        x = nx; y = ny;
        return 0;
    };

    change1(x, y);
    cout << "x1: " << x << " y1: " << y << '\n';
    change2(x, y);
    cout << "x2: " << x << " y2: " << y << '\n';
    change3();
    cout << "x3: " << x << " y3: " << y << '\n';

    return 0;
}
~~~
~~~
❯ ./a.out
x1: 30 y1: 15
x2: 45 y2: 15
x3: 60 y3: 30
~~~

- 약간 자바스크립트 느낌나는 사용법이 아닌가 싶었다. c++98만 사용하느라 람다 표현식에 익숙하지 않았는데, 캡처같은 문법에 익숙해지기만 하면 무척 편할 것 같다.

- sort나 priority_queue도 람다 표현식을 사용하여 간결하게 비교 함수를 정의할 수 있다.

#### 예제2: 람다 표현식을 사용한 sort와 비교 함수 작성

~~~c++
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    vector<int> v = {1,2,3,4,5,6,7,8,9};

    // 람다 표현식을 사용한 정렬
    sort(v.begin(), v.end(), [](int i, int j) { return i > j; });

    for (int i = 0 ; i < v.size(); i++) { cout << v[i] << ' '; }
    cout << endl;

    return 0;
}
~~~

- 아까처럼 `struct compare`를 작성할 필요가 없이 내림차순으로 정렬하는 익명함수를 매개변수로 보내어 동일한 작업을 수행했다. 코드의 간결성이 증가했다고 볼 수 있다. 

#### 예제3: 람다 표현식을 사용한 priority_queue 비교 함수 작성

~~~c++
#include <iostream>
#include <queue>
#include <vector>
using namespace std;

int main() {
    auto compare = [](int a, int b) {
        if (abs(a) != abs(b)) {
            return abs(a) > abs(b);
        }
        return a > 0 && b < 0;
    };

    priority_queue<int, vector<int>, function<bool(int, int)>> pq(compare); 
    // priority_queue<int, vector<int>, decltype(compare)> pq(compare); 
    // 혹은 decltype으로 타입 확정

    vector<int> values = {3, -7, 2, -5, 10, -1, 4};
    for (int value : values) {
        pq.push(value);
    }

    while (!pq.empty()) {
        cout << pq.top() << ' ';
        pq.pop();
    }
    cout << endl;

    return 0;
}
~~~
~~~
❯ ./a.out
-1 2 3 4 -5 -7 10 
~~~

- 위의 우선순위 큐 예제에서 작성했던 함수 객체 compare와 동일한 compare를 람다 표현식으로 다시 작성한 예제이다. 다만 주의해야 할 점은 아까 살펴보았듯이 priority_queue는 sort와 달리 비교자를 템플릿 매개변수로 받기 때문에, 람다 표현식의 타입을 `decltype`이나 `std::function`을 사용하여 컴파일 타임에 지정해주어야 한다는 점이다. 이는 priority_queue를 선언하는 동시에 매개 변수로 직접 람다 표현식을 써넣더라도 동일하다. 아래는 우선순위 큐 선언 시기에 람다 표현식에 직접 코드를 써넣는 경우이다.

~~~c++

int main()
{
    priority_queue<int, vector<int>, function<bool(int, int)>> pq(
        [](int a, int b) {
            if (std::abs(a) != std::abs(b)) {
                return std::abs(a) > std::abs(b);
            }
            return a > 0 && b < 0;
        }
    );

    // ... 그 밑의 동일 구현
}
~~~

- sort, priority_queue의 비교 함수 작성에 대해 알아보았다. 알고리즘 문제 풀때 가끔 써먹어야 할 때가 있어서 알아두면 좋을 것 같다.