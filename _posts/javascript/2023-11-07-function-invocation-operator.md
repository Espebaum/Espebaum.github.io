---
layout: post
title: "함수 호출 연산자"
description: >
    "함수 호출 연산자"
category: javascript
image: "/assets/img/javascript/javascript.webp"
---

## 함수 호출 연산자(function invocation operator)

~~~js
function DisplayMessage() {
    // ... implementation
}

const btn = document.querySelector("button")
btn.onclick = DisplayMessage;
~~~

- 이 경우, html에서 함수가 바로 실행되지 않는다. 그러나...

~~~js
btn.onclick = DisplayMessage();
~~~

- 와 같이 함수 뒤에 () 괄호를 붙이면 바로 실행된다. DOCS에 따르면 ...

> **... 이 맥락에서의 괄호는 때때로 "함수 호출 연산자(function invocation operator)"라고 불립니다. 이것은 함수를 현재 스코프에서 즉시 실행하고 싶을 때만 사용됩니다. 같은 측면에서, 익명 함수 내부의 코드는 즉시 실행되지 않는데, 이는 그것이 함수 스코프 내에 있기 때문입니다.**

- 함수 호출 연산자를 사용하면 함수가 스코프 내에서 즉시 실행된다. 저 경우, 전역 스코프에서 함수가 곧바로 실행된다. 

- 익명 함수 내부의 코드는 즉시 실행되지 않는데, 이는 그것이 함수 스코프 내에 있기 때문이다 => 

~~~js
btn.onclick = function () {
    DisplayMessage();
}
~~~

- 이 코드도 페이지를 로드하자마자 실행되지 않는다는 뜻이다. 