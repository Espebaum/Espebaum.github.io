---
layout: post
title: '단일 샘플에 대한 로지스틱 회귀의 경사하강법 구현'
category: ml
tags: [ml]
date: 2024-06-26
image: "/assets/img/ml/NNDL.webp"
message: "도함수를 계산하여 단일 샘플에 대한 로지스틱 회귀의 경사하강법을 구현해보자"
excerpt: "도함수를 계산하여 단일 샘플에 대한 로지스틱 회귀의 경사하강법을 구현해보자"
---

- table of contents
{:toc}

- 아래 강의와 ChatGpt를 통해 정리했습니다.

<center><img src="/assets/img/ml/NNDL.webp" width="60%" height="60%"></center><br>

- Neural Networks and Deep Learning, 
[Logistic Regression Gradient Descent (C1W2L09)](https://www.youtube.com/watch?v=z_xiwjEdAC4&list=PLpFsSf5Dm-pd5d3rjNtIXUHT-v7bdaEIe&index=15)

- 수식이 이상하게 보인다면 새로고침을 해보면 된다.

~~유튜브에디션~~

### 1단계: 파라미터 초기화

- 강의에서는 가중치 벡터 $[w_1, w_2]$와 독립 변수 벡터 $[x_1, x_2]$, 그리고 편항 $b$로 진행하였다.

### 2단계: 모델 예측

- 이후 **로짓(logit) $z$**를 계산해주었다. $z$의 값은 아래와 같다.

$$z = w_1x_1 + w_2x_2 + b$$

- **로지스틱 회귀에서 독립변수들의 가중합을 통해 계산된 $z$를 로짓이라고 한다**. 이는 선형 회귀 모델의 예측값과 같은 역할을 한다. 이 값은 시그모이드 함수의 입력으로 사용되어 [0, 1] 범위의 확률로 변환된다. 

- 시그모이드 함수 $\sigma(z) = \frac {1} {1 + e^{-z}}$를 사용하여 $z$를 매핑한 값은, 독립 변수 $x_1, x_2$에 대한 조건부 확률 $P(y=1 \| x)$로 해석된다(어떠한 사건에 대한 확률 $p$).

### 3단계: 손실 함수와 그 도함수 계산

- 강의에서와 같이 **로짓 $z$에 대한 시그모이드 매핑값 $\hat y$($\frac {1} {1 + e^{-z}}$)을 $a$로 두고**, 실제 레이블 $y$가 주어졌을 때 손실 함수 $L$을 계산하고 파라미터에 대한 손실 함수 $L$의 도함수를 계산한다. 최종적으로 손실 함수를 $z$에 대해 미분한 $dz$를 계산해야 한다.

- 우선 $(a, y)$에 대한 손실 함수 $L$은 아래와 같다.

$$L(a, y) = -(y \cdot loga + (1-y) \cdot log(1-a))$$

- 위 손실 함수에 대해 $dz$를 구하기 위해서, 미분의 연쇄 법칙을 이용해야 한다.

$$dz = \frac {\sigma L(a, y)} {\sigma z} = \frac {\sigma L(a, y)} {\sigma a} \cdot \frac {\sigma a} {\sigma z}$$

- 손실 함수 $L$을 $a$에 대해 미분한 $\frac {\sigma L(a, y)} {\sigma a}$는 아래와 같다.

$$\frac {\sigma L(a,y)} {\sigma a} = -(\frac {y} {a} - \frac {1-y} {1-a})$$

- 시그모이드 함수의 도함수 $\frac {\sigma a} {\sigma z}$는 다음과 같다.

$$\frac {\sigma a} {\sigma z} = a(1-a)$$

- 따라서 최종적인 $dz$의 값은 둘을 곱한 $a - y$가 된다. 이것은 예측값 $a$($\hat y$)와 실제 값 $y$의 차이를 나타내며 이 값을 이용하여 가중치를 갱신한다.

### 4단계: 경사하강법을 이용한 파라미터 갱신

- $dz = a - y$를 사용해 가중치 $w_1, w_2$와 편향 $b$를 업데이트할 수 있다.

- 가중치 $w_n$을 갱신하는 공식은 아래와 같다. 학습률 $\alpha$에 대해

$$
w_n : = w_n - \alpha \cdot dz \cdot x_n = w_n - \alpha \cdot dw_n
$$

- 이 공식은 **경사 하강법(Gradient Descent)**의 원리에 기반한다. 이는 손실 함수를 최소화하기 위해 가중치를 반복 조정하는 최적화 알고리즘이다.

- 손실 함수를 가중치 $w_n$에 대해 미분하는 것으로($dw_n$), 손실을 줄이기 위해 가중치를 어떻게 변경해야 하는지 알 수 있다. 손실 함수 $L$의 도함수는 다음과 같이 계산한다.

$$\frac {\sigma L} {\sigma w_n} = \frac {\sigma L} {\sigma z} \cdot \frac {\sigma z} {\sigma w_n}$$

- $\frac {\sigma L} {\sigma z}$은 아까 계산한 바와 같이 $a-y$이고 $\frac {\sigma z} {\sigma w_n}$는 $z$를 $w_n$에 대해 미분해보면 알 수 있듯이 $x_n$이다. 즉

$$\frac {\sigma L} {\sigma w_n} = (a-y) \cdot x_n = dw_n$$

- 이 $dw_n$값을 기존의 가중치 $w_n$에 빼서 가중치를 업데이트한다($w_n - \alpha \cdot dw_n$). 마찬가지로 편향 $b$를 업데이트하는 방식은 아래와 같다.

$$b := b - \alpha \cdot dz$$

### 학습률 $\alpha$

- 여기서 학습률 $\alpha$는 한 번의 업데이트에서 가중치를 얼마나 변경할지를 결정하는 하이퍼파라미터이다. 너무 크면 최소값을 지나칠 수 있고, 너무 작으면 학습 속도가 매우 느려질 수 있다.

- 각 에포크마다 예측값 $a$를 계산하고, 손실 함수의 도함수 $dz$를 사용하여 가중치와 편향을 업데이트한다.