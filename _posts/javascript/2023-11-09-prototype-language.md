---
layout: post
title: "Object Prototypes"
description: >
    "객체 프로토타입 설명"
category: javascript
---

* table of contents
{:toc}

[출처, Mdn web docs, Object Prototype/프로토타입 기반 언어](https://developer.mozilla.org/ko/docs/Learn/JavaScript/Objects/Object_prototypes)

## Object Prototypes

### 프로토타입 객체 이해하기 

~~~js
function Person(first, last, age, gender, interests) {
    this.name = {
        first: first,
        last: last,
    };
    this.age = age;
    this.gender = gender;
    this.interests = interests;
    this.bio = function () {
        var string = this.name.first + ' ' + 
            this.name.last + ' is ' + this.age + ' years old. ';
        alert(string);
    };
    this.greeting = function () {
        alert("Hi! I'm " + this.name.first + '.');
    };
}

let person1 = new Person('Tammi', 'Smith', 32, 'neutral', 
                ['music', 'skiing', 'kickboxing']);
~~~

- Person 생성자와 인스턴스 하나를 만들었다고 치자. 그리고 console에서 `person1.bio()`를 호출하면, 함수가 잘 실행되고 해당 alert가 홈페이지 상단에 표시될 것이다.

- 