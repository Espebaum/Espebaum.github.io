---
layout: post
title: "async, defer"
description: >
    "이 코드 왜 안됨"
category: javascript
---

## 스크립트 로딩 전략

~~~js
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <script src="script.js"></script>
    </head>
    <body>
        <button>Press me</button>
    </body>
</html>
~~~

- press me 버튼 연타해도 아무런 일도 안일어난다. 왜지?

=> async, defer, 스크립트 로딩 전략 글쓰기

### script 태그 위치

~~~html
<label for="sides">Enter number: </label>
<input type="number" />
<button>Generate integar squares</button>
<p>Output: </p>
<script src="script.js"></script>
~~~

- 이게 html, 숫자를 입력하면 숫자보다 작은 제곱수를 보여줌, 그리고 아래 js코드는 script.js의 전문

~~~js
const num = document.querySelector("input");
const btn = document.querySelector("button");
const param = document.querySelector("p");

btn.addEventListener("click", showOutput)

function showOutput() {
    let input = num.value;
    num.value = "";
    num.focus();
    for (let i = 1; i <= input; i++) {
        let sqRoot = Math.sqrt(i);
        if (Math.floor(sqRoot) !== sqRoot) {
            continue
        }
        param.textContent += i + " ";
    }
}
~~~

- `<script src="script.js"></script>` 이게 맨 밑에 있는게 아니면 html 코드가 작동하지 않음, 스크립트 로딩 전략

- 그런데 아래처럼

~~~html
<script src="script.js" defer></script>
<label for="sides">Enter number: </label>
<input type="number" />
<button>Generate integar squares</button>
<p>Output: </p>
~~~

- 이렇게 하면 됨, defer