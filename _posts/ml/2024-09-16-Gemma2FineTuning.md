---
layout: post
title: '[구글 머신러닝 부트캠프 2024] Gemma Sprint, Gemma2를 파인튜닝 해보자'
category: ml
tags: [ml]
date: 2024-09-16
image: "/assets/img/ml/gemmasprint/huggingface.webp"
message: ".."
excerpt: ".."
---

- table of contents
{:toc}
 

## Gemma 스프린트 프로그램 (Gemma Sprint Program)

<center><img src="/assets/img/ml/gemmasprint/Gemma.webp" width="60%" height="60%"></center>

<br>

- **Gemma Sprint**는 구글 머신러닝 부트캠프 2024를 수료하기 위한 새로운 조건이다. 작년에는 TensorFlow 자격증을 취득하는 코스가 있었던 것 같은데, 이번에는 Gemma2를 이용하여 프로젝트 결과물을 만드는 Gemma Sprint가 새로운 수료 조건이 된 것으로 보인다.

- Sprint를 진행할 수 있는 방법은 **첫 번째**로 Kaggle Models 혹은 Hugging Face Models에 파인튜닝한 Gemma 모델을 배포하고 Kaggle Code (Notebook) / Hugging Face Model Card에 모델 설명, 모델 학습 과정, 코드, 성능/결과 등을 함께 작성하는 것이고, **두 번째**로 GitHub, Google Colab, Jupyter Notebook 등에 코드를 기록하고, 블로그 또는 YouTube로 튜토리얼을 제작하는 것이다. **2개를 전부 하는 것도 권장 사항으로, 본인의 경우 Kaggle에 모델을 배포하였고, 그 과정을 블로그에 튜토리얼로 남기려 한다.**

## Reference

[Gemma 한국어 요약 모델 파인튜닝 빠르게 해보기](https://devocean.sk.com/blog/techBoardDetail.do?ID=165703&boardType=techBlog#none)

- Gemma2 모델을 Fine Tuning 하는 과정은 위 사이트를 정말 많이 참고했다. 애초에 LLM/FineTuning에 대한 정보가 전무한 상태로 들어왔기 때문에, 위 글이 없었다면 이번 Gemma Sprint를 진행하기가 쉽지 않았을 것으로 생각한다. ~~압도적감사~~

## 개발 환경

- 아직 머신러닝용 데스크탑을 마련하지 못해서 **Google Colab**을 사용하고 있었기 때문에 Gemma Sprint도 주로 **Colab**을 이용하는 것으로 진행하였다. 같은 회사의 서비스여서 그런지, Colab에서는 **HuggingFace**를 써서 아주 빠르고 간편하게 Gemma2 모델을 호출하고 튜닝할 수 있다.

<center><img src="/assets/img/ml/gemmasprint/kaggleCard.webp.png" width="60%" height="60%"></center><br>

- 마찬가지로 **Kaggle**을 이용해서도 Gemma2 모델을 로드하여 튜닝할 수가 있다. [Gemma2](https://www.kaggle.com/models/google/gemma-2)는 Kaggle에서 제공하는 Gemma2의 Model Card로, 여기서 새로운 Notebook을 만들어 모델을 input으로 받아올 수가 있다. Kaggle의 경우 일주일에 **GPU를 30시간, TPU를 20시간 제공**하는데 Colab에 컴퓨팅 단위를 다 쓰고 새로운 컴퓨팅 단위를 구매하기까지 부족한 시간에 캐글에서 코딩을 했으나 **메모리 부족 이슈**를 해결하지를 못해 결국 Colab으로 프로젝트를 마무리할 수 밖에 없었다.

## 주제

- 우리 팀의 Projects Description은 아래와 같다.

```md
The project develops a system that automatically generates the full content of academic abstracts 
based on their summaries. The tool aims to enhance research efficiency by providing a complete 
version of the abstract from concise summaries.
```

- 즉, **논문 abstract의 Summary와 그 원본 글(Original)을 학습시켜서, 특정 주제에 대한 Summary를 제공했을 때 새로운 초록을 생성하는 모델을 파인 튜닝하는 것이 우리 Project의 목표**이다.

- **Write My Paper!**, ~~챗지피티나 Gemma같은 LLM이 내가 대학생일 때 있었다면 기술복제시대의 예술작품에 관한 리포트를 쓸 때 그런 고생은 하지 않았을텐데...~~

## (1) 환경 설정

### [1 - 1] 구글 드라이브 임포트

```python
from google.colab import drive

drive.mount('/content/drive')
```

- 부트캠프를 진행하면서 15Gb던 구글 드라이브 용량을 졸지에 100Gb까지 늘렸다. 데이터셋 용량을 생각하면 더 늘려야할 수도 있겠다고 생각한다. 이 라인을 실행해서 드라이브에 있는 데이터셋을 Colab Notebook에 로드할 수 있다. 

### [1 - 2] 라이브러리 설치 및 모듈 임포트

```python
!pip3 install -q -U transformers # 트랜스포머로 Train 실행
!pip3 install -q -U datasets     # 데이터셋
!pip3 install -q -U peft         # 파인튜닝(parameter efficient fine-tuning)
!pip3 install -q -U trl          # 모델 학습
!pip3 install -q -U accelerate
!pip3 install -q -U bitsandbytes # 양자화를 위한 bitsandbytes
```

```python
import torch
from datasets import Dataset, load_dataset
from transformers import AutoTokenizer, AutoModelForCausalLM, \\
BitsAndBytesConfig, pipeline, TrainingArguments
from peft import LoraConfig, PeftModel, get_peft_model
from trl import SFTTrainer
```

### [1 - 3] HuggingFace 로그인

```python
from huggingface_hub import notebook_login

notebook_login()
```

- Gemma 모델을 HuggingFace를 통해 사용하기 위해서는 HuggingFace에 계정을 만들고, Model에 접근 가능한 token을 발행해야 한다. **token을 발행한 후 Model에 접근 가능하도록 설정**을 해줘야 하는데, HuggingFace를 써보는 것도 처음이어서 많이 헷갈렸던 기억이 있다. 설정을 하지 않으면 모델을 호출했을 때 Permission Error가 발생하게 된다.


### [1 - 4] 데이터셋 로드

- 논문 abstract의 Summary - Original 쌍 Dataset은 aihub의 데이터셋을 사용했다.