# day1 실습

## 1. 텐서의 차원과 형태
- tensor
  - n*m행렬을 k개 모아놓은 형태?? 다차원도 가능한지?

```python
import torch
X = torch.rand(3, 4, 5)
# 4 * 5 행렬이 3개
X.dim() # X의 차원은 3
X.shape # torch.Size([3, 4, 5])로 출력
X.size() # torch.Size([3, 4, 5])로 출력... 차이가 뭐지?
'''
질문 torch는 3차원까지인지 더 가능한지?
일단 torch에서는 n차원이 가능한듯함
torch.rand(6,5,4,3,2)를 하면
[[[[[rand_num for x1 in range(2)] for x2 in range(3)] for x3 in range(4)] for x4 in range(5)] for x5 in range(6)]
이 생성되는듯 하다.
'''
```
## 2. Mul 과 Matmul 의 차이
- mul 각 원소별로 곱함.
  - mul은 말그대로 같은 인덱스 끼리 곱해주는 것

- matmul 내적
  - matmul의 텐서 내적은 어떤 방식인지?
    - 간단하게 계산해봄.
    - [3, 2, 5] 텐서와 [3, 5, 3] 텐서를 matmul 하면
    - 3은 그대로 유지한채로 2 * 5 와 5 * 3 행렬의 내적을 통해 2 * 3짜리 행렬을 구함
    - 따라서 [3, 2, 3] 텐서가 나옴.

## 3. Broadcasting
- X : [100, 1, 20], Y : [100, 40, 20]
- 크기가달라 연산 적용이 불가능해야 하지만
- numpy와 pytorch는 broadcasting(?)을 지원하여 X의 모자란 두번째 차원 1을 Y의 40에 맞춰 반복 복제하여 크기를 맞춤.
  - Y에 모자란 부분이 있으면 Y도 늘려줌

## 4. view()
- 텐서의 shape를 바꿀때 사용한다고 함..
  - 예시는 이해 불가.
  - X : [3, 2, 5]
  - X.view(3, 10) 은 X를 [3, 10] 형태로 바꾸어줌
  - X 자체는 변하지 않음.
  - view 안의 값의 곱이 X 전체 size의 곱과 같아야 한다.
    - 위 예시에서는 모두 곱하면 30 이므로 X.view(5, 6) 사용 가능
    - 단 변환 방식은 전체를 한개의 리스트로 이었을때 5 * 6짜리 텐서를 앞에서 부터 채우는 방식으로 보임.

## 5. axis개념
- 많은 함수에서 매개변수로 요구되는 개념이라고 함.
- 다차원 텐서에 해당 함수 연산을 어떤 축으로 적용 할지를 결정하는데 사용..
- 예) np.concaternate((A1, B1), axis = 0) 이런식으로 함수의 매개변수 중 하나로 자주 등장.
  - np.sum으로 자세히 확인 가능할듯.

## 6. squeeze & unsqueeze
- 특정 차원이 1인 경우 축소시키거나 차원을 확장시킬 때 사용.
- torch.squeeze(X)
  - X : [100, 1, 20] -> [100, 20]
  - 1이 한개씩 없어지는지 여러개가 다 없어지는지..
    - (인덱스 없으면) 모두 없어지는걸로 확인
  - 인덱스 지정하면 해당 차원만 축소되는듯
- torch.unsqueeze(Y, k = 0)
  - Y : [3, 5] -> [1, 3, 5]
  - k 차원 위치에 1짜리 차원이 생기는듯함.
- X.squeeze 와 X.unsqueeze 방식도 있는듯.. 단 인덱스가 필요한것 같기도??

## 7. type casting
- 자료형을 바꿔줄 줄 알아야함..
  - torch.LongTensor : long 형태
  - X.float() : float 형태로 변환

## 8. concatenate
- 두 개 이상의 텐서들을 지정된 축으로 쌓아서 더 큰 텐서를 만드는 함수.
- 하나의 텐서로 합치기 위한 입력 텐서들은 concatenate하는 축을 제외하고는 모두 같은 크기를 가져야 함.
- torch.cat([x, y], dim = 0)

## 실습
### 그래프
- %matplotlib inline
  - 이건 뭔지 모르겠음
- import matplotlib.pyplot as plt
- plt.scatter
  - 그래프에 점 찍기
- plt.xlabel('x축 이름')
  - 축에 이름 붙이기
- plt.ylabel('y축 이름')
  - 축에 이름 붙이기
- plt.show()
  - 그래프 출력

### colab에서 gdrive 파일 불러오기
- 구글 드라이브 연동
  - from google.colab import drive
  - drive.mount('/content/gdrive')
- 파일 불러오기
  - import pathlib
  - path = pathlib.Path('/content/gdrive/My Drive/bootcamp2/health_data.csv')
- CSV 데이터를 다루기 위해서는 pandas 라이브러리 지식 필요