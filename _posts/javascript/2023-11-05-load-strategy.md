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