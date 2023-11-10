---
layout: post
title: "이벤트 버블링과 캡처"
description: >
    "버블링과 캡처링 설명"
category: javascript
---

* table of contents
{:toc}

[출처, Mdn web docs, 이벤트 입문/이벤트 버블링과 캡처](https://developer.mozilla.org/ko/docs/Learn/JavaScript/Building_blocks/Events)

## 이벤트 버블링과 캡처

~~~html
    // ... (중략)
    <style>
        div {
            position: absolute;
            top: 50%;
            transform: translate(-50%, -50%);
            width: 480px;
            height: 380px;
            border-radius: 10px;
            background-color: #;
            background-image: linear-gradient(to bottom, rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.1));
        }

        .hidden {
            left: -50%;
        }

        .showing {
            left: 50%;
        }

        div video {
            display: block;
            width: 400px;
            margin: 40px auto;
        }
    </style>

    <body>
        <button>Display video</button>

        <div class="hidden">
            <video>
                <source src="rabbit320.mp4" type="video/mp4" />
                <source src="rabbit320.webm" type="video/webm" />
            </video>
        </div>

        <script>
            function displayVideo() {
                if (videoBox.getAttribute('class') === 'hidden') {
                    videoBox.setAttribute('class', 'showing');
                }
            }
            const btn = document.querySelector('button');
            const videoBox = document.querySelector('div');

            btn.addEventListener('click', displayVideo);
            videoBox.addEventListener('click', () => 
                videoBox.setAttribute('class', 'hidden'));

            const video = document.querySelector('video');
            video.addEventListener('click', () => video.play());
        </script>
    </body>
    // ... (중략)
~~~

- 대략 아래와 같은 모양을 하고 있다.

<br><center><="/assets/img/javascript/js-bubbling.png" width="100%" height="100%"></center><br>

- 먼저 button이 있고 그 밑에 토끼 영상을 포함한 div 블록이 있다. 버튼(`const btn`)을 누르면 `displayVideo()` 함수가 호출되어 div 블록의 attribute가 hidden에서 showing으로 바뀌며 숨겨져 있던 영상 블록(<div>)이 드러나게 된다. 

- 그리고 비디오 썸네일을 클릭하면 영상이 시작되는데(`video.addEventListener('click', () => video.play());`), 그와 동시에 영상 블록이 사라져버린다.(`videoBox.addEventListener('click', () => videoBox.setAttribute('class', 'hidden'));`) **이 현상이 바로 이벤트 버블링 때문이다.**

### 버블링과 캡처링 설명

- 부모 요소를 가지고 있는 요소에서 이벤트가 발생되었을 때 (이 경우, `<video>`는 부모로서의 `<div>` (en-US)를 가지고 있다), 현대의 브라우저들은 두 가지 다른 단계(phase)를 실행한다 — 캡처링(capturing) 단계와 버블링(bubbling) 단계이다.

#### 캡처링 단계에서는:

(1) 브라우저는 요소의 가장 바깥쪽의 조상 (<html>)이 캡처링 단계에 대해 그것에 등록된 onclick 이벤트 핸들러가 있는지를 확인하기 위해 검사하고, 만약 그렇다면 실행한다. 

(2) 그리고서 <html> 내부에 있는 다음 요소로 이동하고 같은 것을 하고, 그리고서 그 다음 요소로 이동하고, 실제로 선택된 요소에 닿을 때까지 계속한다.

#### 버블링 단계에서는, 

정확히 반대의 일이 일어난다:

(1) 브라우저는 선택된 요소가 버블링 단계에 대해 그것에 등록된 onclick 이벤트 핸들러를 가지고 있는지 확인하기 위해 검사하고, 만약 그렇다면 실행한다. 

(2) 그리고서 그것은 바로 다음의 조상 요소로 이동하고 같은 일을 하고, 그리고서 그 다음 요소로 이동하고, <html> 요소에 닿을 때까지 계속한다.

### stopPropagation()으로 문제 고치기

- 현대의 브라우저들은, 기본으로, 모든 이벤트 핸들러들은 버블링 단계에 대해 등록되어 있다. 그래서 우리의 현재 예제에서는, 비디오를 선택했을 때, 이벤트는 `<video>` 요소로부터 밖으로 나가 `<html>` 요소까지 올라간다(bubble). 그 동안 다음이 일어난다:

(1) video.onclick... 핸들러를 발견하고 실행하므로, 비디오가 먼저 재생을 시작한다.

(2) 그리고서 videoBox.onclick... 핸들러를 발견하고 실행하므로, 비디오는 또한 숨겨진다.

- 표준 Event 객체는 stopPropagation()라 불리는 사용 가능한 함수를 가지고 있는데, 핸들러의 이벤트 객체가 호출되었을 때, 이는 첫번째 핸들러가 실행되지만 이벤트가 더 이상 위로 전파되지 않도록 만들어, 더 이상의 핸들러가 실행되지 않도록 한다

- 그러므로, 이전 코드 블럭에 있는 두 번째 핸들러 함수(`video.addEventListener('click', () => video.play());`)를 아래와 같이 변경함으로써 우리는 현재의 문제를 고칠 수 있다:

~~~js
video.onclick = function (e) {
  e.stopPropagation();
  video.play();
};
~~~

## 이벤트 위임

~~~js
const ul = document.querySelector('ul');

ul.addEventListener('click', (e) => {
                // 이벤트 위임
                console.log(e);
                alert(e.target.innerText);
                // e.target.innerText는 li 엘리먼트(타겟 엘리먼트)의 텍스트를 담고 있다
                // this(e.currentTarget, 현재 이벤트가 발생된 엘리먼트)는 ul이다.
            });
~~~

- `<ul>` 태그 안에 다수의 `<li>` 태그들이 작성되어있고, 그 `<li>`들을 하나하나 클릭할 때마다, 그 li의 텍스트를 alert 한다고 생각해보자. `<li>`에서 발생한 이벤트는 버블링되어 `<ul>` 까지 올라가게 되고, **`<ul>`은 e.target에 최초에 이벤트가 발생했던 `<li>`를 기억하게 된다. 따라서 `<ul>`의 EventListener에서 `<li>`의 내용(e.target.innerText)를 alert할 수 있다.**

- 각각의 li의 EventListener를 만들게 되면 코드가 길어지고, 만약 li가 동적으로 관리된다면 메모리 누수가 발생할 수 있다. 이때 이벤트 위임을 통해 부모 태그 ul에서 이벤트를 관리함으로써 코드를 간결히 하고, 잠재적인 문제를 방지할 수 있다.  