---
layout: post
title: "Object Prototypes"
description: >
    "객체 프로토타입 공부"
category: javascript
---

- 써야함

* table of contents
{:toc}

[출처, Mdn web docs, Object Prototype/프로토타입 기반 언어](https://developer.mozilla.org/ko/docs/Learn/JavaScript/Objects/Object_prototypes)

## Object Prototypes in Javascript

- 자바스크립트의 프로토타입 상속에 대해 공부하면서, c++ 클래스 상속과의 차이점에 대해서도 생각해보자.

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

<center><img src="/assets/img/javascript/person-bio.png" width="100%" height="100%"></center><br>

- 이번엔 `person1.valueOf()`을 호출해보자. 함수가 실행되고 해당 값이 console에 표시된다. Person의 생성자에는 `valueOf()` 함수에 대한 내용이 없는데, 어떻게 이 함수가 실행되는걸까? 이는 Javascript의 프로토타입 상속의 특징이다.

