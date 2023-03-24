# lr_scheduler

- torch.optim.lr_scheduler
- 내부에 여러가지 lr 조정하는 방법들이 class로 구현되어 있음
  - LambdaLR
  - MultiplicativeLR
  - StepLR
  - ConstantLR
  - ReduceLRonPlateau
  - 등등
- 여기서는 ReduceLRonPlateau를 사용
  - 작동원리
    - patience 수 에포크 동안 개선 없으면 lr을 줄임
    - lr이 줄어든 다음 cooldown 수 에포크 이후에 정상 오퍼레이션으로 돌아감???
    1. 현재랑 기존 best랑 비교
    더 좋으면 best = current로 업데이트, num bad ep = 0 초기화
    개선 안되었으면 num bad ep += 1

    2. cooldown인지 확인(cooldown cntr > 0 인지)
    cooldown이면 -= 1
    num bad ep = 0 (개선 안된걸로 세지 않음)

    3. num bad ep가 patience 보다 큰지 확인
    큰 경우 reduce lr 실행(epoch 입력)
    cooldown cntr 초기화(cooldown 값으로)
    num bad ep = 0

    4. last lr 에 러닝레이트 저장...

  - patience = 2 cooldown = 3
  - 왠진 몰라도 epoch에 38 저장되어 있었음
  - 일단 퍼포먼스가 좋아진 적 없다고 하면
  - 43??
    - num bad ep 0 -> 1
    - cooldown cntr 3 -> 2, num bad ep 1 -> 0
  - 44
    - num bad ep 0 -> 1
    - cooldown cntr 2 -> 1, num bad ep 1 -> 0
  - 45
    - num bad ep 0 -> 1
    - cooldown cntr 1 -> 0, num bad ep 1 -> 0
  - 46
    - num bad ep 0 -> 1
    - cooldown cntr 0 유지
  - 47
    - num bad ep 1 -> 2
    - cooldown cntr 0 유지
  - 48
    - num bad ep 2 -> 3
    - cooldown cntr 0 유지
    - num bad ep > patience 이므로
      - reduce lr 실행 -> lr값 변경
      - cooldown cntr 0 -> 3
      - num bad ep 3 -> 0
  
  - 39(33부터 다시 반복)
    - num bad ep 0 -> 1
    - cooldown cntr 3 -> 2, num bad ep 1 -> 0


- 현재 학습모델
  - 0번 에포크부터 시작한게 아니라 11번부터 시작.
  - self.last_epoch = 0에서 시작 epoch = 1
  - epoch += 10 하면 숫자가 맞음
  - 48 -> 49에서 reduce lr 실행, 54->55에서 reduce 될듯
  - 저장이 32? 33?번에서 된거 보면
  - 중간에 저장 될 때 num bad epoch는 0으로 초기화 되지만 cooldown cntr은 초기화 되지 않음
  - 36에서 reduce lr 되었을것. 


11  12  13  14  15  16  17  18          
1   2   3   4   5   6   7   8           


epoch       31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49
wepoch      21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39
reduce          save            lr                      lr                      lr
numbad      ?   0   1   2   3   0   0   0   1   2   3   0   0   0   1   2   3   0   0
coolcntr    0/1 0   0   0   0   3   2   1   0   0   0   3   2   1   0   0   0   3   2






lr :33에 마지막으로 저장, 38때 무슨일이 있었던거 같고, (46, 47, 48) 0.000328 -> (48 끝나고)0.000262로 조정