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

<center><img src="/assets/img/ml/gemmasprint/aihub_dataset.webp" width="60%" height="60%"></center><br>

[논문자료 요약](https://www.aihub.or.kr/aihubdata/data/view.do?currMenu=115&topMenu=100&dataSetSn=90)

- json 파일을 사용했기 때문에, python에서 json을 로드하여 pandas Dataframe으로 만들고, 본격적으로 파인 튜닝을 진행할 `SFTTrainer`(Supervised Fine-Tuning Trainer)에 매개 변수로 사용할 Dataset으로 만드는 과정을 거쳤다.

```python
import json
import pandas

# Json 데이터 로드
path = '/content/drive/train_paper.json'

with open(path, 'r', encoding='utf-8') as f:
    data = json.load(f)

# 데이터를 담을 리스트 초기화
documents = []

# 데이터 파싱
for item in data[0]['data']: # 리스트에 들어있는 객체 파싱
    doc = {
        'category': item.get('ipc', ''),
        'title': item.get('title', ''),
        'summary': ' '.join([summary['summary_text'] for summary in item.get('summary_entire', [])]),
        'original': ' '.join([summary['orginal_text'] for summary in item.get('summary_entire', [])])
    }
    documents.append(doc)
```

- documents는 doc 객체를 원소로 하는 Python 리스트이다. 이대로는 사용할 수가 없고, pandas dataframe으로 변환하는 과정을 거쳐야 한다.

```python
df = pd.DataFrame(documents)
print(df.shape) # (288174, 4)
df.head()
```

<center><img src="/assets/img/ml/gemmasprint/df_head.webp" width="100%" height="100%"></center><br>

```python
from sklearn.model_selection import train_test_split

train_df, val_df = train_test_split(df, test_size=0.1, random_state=42)
```

- `sklearn`의 `train_test_split`를 사용하면 dataset을 train set과 validation set으로 분할할 수 있다. 분리된 validation set의 경우, SFTTrainer에서 제공하는 early stopping 콜백 함수를 사용하기 위한 검증 세트로 사용하려고 했으나 Kaggle과 Colab 모두에서 **CUDA 메모리 초과 문제(CUDA OOM)**가 발생해서 실제로 validation set을 활용하지는 못했다. 이 부분 때문에 예상 외의 추가 지출이 발생해서 소극적으로 움직일 수 밖에 없었던 것이 아쉽다. 

- **Hugging Face**에서는 Pandas Dataframe을 SFTTrainer에서 사용할 수 있는 Dataset으로 변환할 수 있는 메서드를 제공한다. [From in-memory data](https://huggingface.co/docs/datasets/v1.2.0/loading_datasets.html#from-in-memory-data)를 참고할 것.

```python
from datasets import Dataset

# pandas 데이터프레임을 Trainer에서 사용하기 위한 dataset 모양으로 변경
dataset = Dataset.from_pandas(df)

print(dataset)
print(dataset[0])
```

- from_pandas를 통해 반환된 **dataset**은 'category', 'title', 'summary', 'original'의 피쳐를 가진 80000행의 자료구조이다.

- dataset의 원소가 가진 key들 중에서 실제 훈련에 사용된 것은 'summary'와 'original'이다. **summary-original 쌍을 훈련시킴으로써 새로운 summary가 주어졌을 때, original을 생성해내도록 하는 것이 궁극적인 목표이다.**

```md
# dataset
Dataset({
    features: ['category', 'title', 'summary', 'original'],
    num_rows: 80000
})

# dataset[0]
{
    'category': '인문학', 
    'title': '중세시대의 對句 학습과 문학 교육', 
    'summary': '對句의 영역은 다양하고, 그 원리는 짝짓기이다. 
    하나의 텍스트가 같은 분포도를 보이는 것은 자연스럽다.',
    'original': '짐작할 수 있는 것처럼, 對句의 영역은 음운, 단어, 어구, 시편의 차원에서 다양하게 이뤄지고 있으며, 그 원리는 짝짓기이다. 
    하나의 텍스트는 음운으로부터 텍스트 자체까지에 이르는 위계적 양상을 보이므로 對句의 영역 또한 같은 분포도를 보이는 것은 퍽 자연스럽다. 
    문제는 텍스트의 전 영역에 걸쳐 짝을 만들어야 한다는 강박증이다. 왜 한시학은 짝짓기에 집착하는가?'
}
```

### [1 - 5] Hugging Face Login 및 Model Load

```python
from huggingface_hub import notebook_login

notebook_login()
```

```python
BASE_MODEL = "google/gemma-2b-it" 
# huggingface로부터 gemma-2b-it 모델을 받아옴

model = AutoModelForCausalLM.from_pretrained(BASE_MODEL)
tokenizer = AutoTokenizer.from_pretrained(BASE_MODEL)
```

- Hugging Face에 계정에 모델에 접근할 수 있는 Access Token을 발행해두고, notebook_login을 통해 로그인에 성공했다면, 위 라인을 통해 편리하게 `gemma-2b-it` 모델을 빠르게 로드해올 수 있다. 

- `AutoModelForCausalLM`과 `AutoTokenizer`는 Hugging Face의 `transformers` 라이브러리에서 제공하는 모델 및 토크나이저 선택을 위한 클래스이다. 매개 변수로 지정한 모델과 해당하는 토크나이저를 자동으로 선택하게 된다.

## (2) 모델 사용해보기

- Hugging Face에서 제공하는 Gemma2의 Model Card에, prompt를 어떻게 작성해야 하는지에 대한 정보가 담겨 있다.

```python
from transformers import AutoTokenizer, AutoModelForCausalLM
import transformers
import torch

model_id = "google/gemma-2-2b-it"
dtype = torch.bfloat16

tokenizer = AutoTokenizer.from_pretrained(model_id)
model = AutoModelForCausalLM.from_pretrained(
    model_id,
    device_map="cuda",
    torch_dtype=dtype,)

# chat prompt

chat = [
    { 
        "role": "user", 
        "content": "Write a hello world program" 
    },
]

prompt = tokenizer.apply_chat_template(chat, tokenize=False, add_generation_prompt=True)
```
> At this point, the prompt contains the following text:

```md
<bos><start_of_turn>user
Write a hello world program<end_of_turn>
<start_of_turn>model
```

- model과 tokenizer를 받아오는 부분은 동일하고, 주목해야할 부분이 role, content를 키로 가지는 객체를 포함한 chat 리스트와 prompt이다.

- `apply_chat_template`는 huggingface에서 제공하는 메서드로, chat의 리스트를 tokenzier가 사용하는 형태로 바꿔준다. gemma2가 아니라 다른 모델을 사용한다면 다른 형태로 파싱이 된다. [How do I use chat templates?](https://huggingface.co/docs/transformers/main/en/chat_templating#how-do-i-use-chat-templates) 참고

- 예를 들어 내가 사용했던 데이터를 prompt로 만들면

```python
doc = dataset[2]['summary']
doc
```
```
'코스닥시장에서 가격제한폭 변화가 이루어진 1998. 5. 25의 경우를 대상으로 검증한 결과, 
관측변동성의 경우는 기간 B에서 변동성의 변화가 유의하지 않은 것으로 나타났고 기본적 변동성의 경우에는 
기간 B에서 유의하게 증가한 것으로 나타났으며 
일시적 변동성의 경우에는 변화가 유의하지 않은 것으로 나타났다.'
```



