---
layout: post
title: "Object Prototypes"
description: >
    "객체 프로토타입 공부"
category: javascript
image: "/assets/img/javascript/javascript.webp"
---

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

<center><img src="/assets/img/javascript/js-person-bio.png" width="80%" height="80%"></center><br>

- 이번엔 `person1.valueOf()`을 호출해보자. 함수가 실행되고 해당 값이 console에 표시된다. Person의 생성자에는 `valueOf()` 함수에 대한 내용이 없는데, 어떻게 이 함수가 실행되는걸까? 이는 Javascript의 프로토타입 상속의 특징이다.

<center><img src="/assets/img/javascript/js-prototype.png" width="80%" height="80%"></center><br>

- `person1.valueOf()`가 호출될 수 있는 이유는, **Object의 prototype에 .valueOf() 함수가 정의되어 있고, Person 객체는 Object.prototype의 매서드들을 가지고 상속되었으며, person1은 그 Person의 prototype을 가지고 만들어진 객체이기 때문에 프로토타입 체인을 거슬러 올라가면 결국 .valueOf() 매서드를 찾아낼 수 있기 때문이다.** 아래와 같은 절차를 밟는다.

  (1) 브라우저는 우선 person1 객체가 valueOf() 메소드를 가지고 있는지 체크한다.
  
  (2) 없으므로 person1의 프로토타입 객체(Person() 생성자의 프로토타입)에 valueOf() 메소드가 있는지 체크한다.
  
  (3) 여전히 없으므로 Person() 생성자의 프로토타입 객체의 프로토타입 객체(Object() 생성자의 프로토타입)가 valueOf() 메소드를 가지고 있는지 체크합니다. 여기에 있으니 호출하며 끝난다.

### Object.create() 써보기

- 아래를 console에 실행해보자.

~~~js
let person2 = Object.create(person1);
~~~

- create() 메소드가 실제로 하는 일은 주어진 객체를 프로토타입 객체로 삼아 새로운 객체를 생성하는 것이다. 여기서 person2는 person1을 프로토타입 객체로 삼는다. 아래를 실행하여 그것을 확인할 수 있다.

~~~js
person2.__proto__;
~~~

- person1이 출력된다.

### 생성자 속성

- 모든 생성자 함수는 constructor 속성을 지닌 객체를 프로토타입 객체로 가지고 있다.

~~~js
Person.prototype.constructor;
~~~

<center><img src="/assets/img/javascript/js-prototype-constructor.png" width="80%" height="80%"></center><br>

- 이 constructor 속성은 원본 생성자 함수 자신을 가리킨다. 배운 바에 의하면 Person의 prototype들로 생성된 모든 객체들이 Person의 prototype에 접근할 수 있는데, 마찬가지로 person1과 person2에서도 constructor에 접근할 수 있다.

~~~js
person1.constructor
person2.constructor
~~~

- 아래를 실행해보면

~~~js
let person3 = new person1.constructor("Karen", "Stephenson", 26, "female", [
  "playing drums",
  "mountain climbing",
]);

person3.name.first;
person3.age;
person3.bio();
~~~

- 잘 되는 것을 확인할 수 있다.

### 프로토타입 수정하기

- prototype에 새로운 속성을 추가할 수도 있다. 변동 사항은 즉시 적용된다.

~~~js
Person.prototype.farewell = function () {
  alert(this.name.first + " has left the building. Bye for now!");
};
~~~

- 이후 `person1.farewell()`을 콘솔에서 실행하면, 잘 실행되는 것을 확인할 수 있다. 이렇게 속성이나 매서드를 프로토타입에 추가하면, 그 프로토타입으로 만들어진 객체에 대해 새로운 속성과 매서드를 추가할 수 있다.

- 일반적인 방식으로는 속성은 생성자에서, 메소드는 프로토타입에서 정의하게 된다. 속성을 프로토타입에 정의하는 것은 별로 좋은 방식이 아니다.

### C++ 클래스 상속과 Javascipt 프로토타입 상속

- 객체 지향 프로그래밍이라는 큰 틀에서 봤을 때 유사한 점이 많지만(클래스, 상속, 캡슐화), javascript에서는 클래스와 더불어 **prototype**이라는 다른 기능을 제공한다. 아직 prototype에 대한 이해도가 떨어져 그런걸까. 하위 객체의 상위 객체에 대한 참조가 좀 더 내부적으로 일어나는 것 외에 무슨 차이점이 있는 것인지 잘 와닿지가 않는다. 더 공부해 봐야겠다.