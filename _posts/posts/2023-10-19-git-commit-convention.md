---
layout: post
title: "github 커밋 컨벤션 정리"
category: posts
---

예전부터 커밋 메세지를 개판으로 작성하는 일이 잦았다. 정리를 빡빡하게 하는 스타일은 아니지만 그래도 계속 글을 쌓아나갈텐데 컨벤션을 만들어두는 편이 좋을 것 같아서 생각난 김에 정리해둔다.

### (1) fixed
~~~md
git commit -m "fixed: _sass/_inline_/_sidebar.scss width: 20%"
~~~
- 파일 디렉토리를 저렇게 정성스럽게 길게 작성하진 않을 것 같다. 포스트를 fix할 때는 어떤 포스트를 수정했는지 알아볼 수만 있도록 할것 같다.

~~~md
git commit -m "fixed: push_swap_2"
~~~

### (2) done
~~~md
git commit -m "done: push_swap_2"
~~~
- 글 하나를 완성했을 때의 커밋 컨벤션, completed와 고민했는데 짧은 편이 좋은 것 같아서 done으로 쓰기로 했다.

### (3) ongoing
~~~md
git commit -m "ongoing: push_swap_3"
~~~
- 글 하나를 작성중일 때의 컨벤션, progress에 비해선 이게 좋아보이는데, 더 짧고 더 직관적인 좋은 문구가 없으려나?

생각날 때마다 더 적어보자