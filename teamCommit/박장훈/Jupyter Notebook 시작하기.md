# Jupyter Notebook 시작하기

- Jupyter = Ju(lia) + Pyt(hon) + R
- 웹 기반 + 통합 개발 환경 + 인터랙티브
- 노트북 = 문서(마크다운) + 코드 + 시각화 + 수식 표현
  - 실행되는 문서!
- IPython에서 시작(2014년)
- 데이터 과학 분야의 표준 도구(De Facto)
- 코드 작성과 실행, 출력 보기, 시각화 출력


## Jupyter Notebook에서 할 수 있는 것들
- 마크다운으로 문서화를 할 수 있다
- Python 등 코드를 실행하고 결과를 확인할 수 있다
  - REPL(Read Evaluate Print Loop), Interactive
- 노트북 도움말 : h
- API 도움 받기 : help(), ?, ??
- 자동완성 : TAB
- Tool Tip : Shift + tab
- Magic 명령어 : % 또는 %%, %magic, %load, %run, %history, %Ismagic ..
  - dd, b, m, y, shift+enter
  - ????

- 시각화 자료를 통합할 수 있다
- 수식 표현이 가능하다
  - $, $$ : LaTeX
  - \begin, \end
- 쉘을 실행할 수 있다
  - 셀에서!
  - 또는 터미널 실행창 열기(New -> Terminal)

- 만들어진 노트북으로 슬라이드쇼를 할 수 있다.
  - html로 저장 : jupyter nbconvert some-notebook.ipynb --to slides
  - 웹 서버로 실행 : jupyter nbconvert some-notebook.ipynb --to slides --post serve
  - RISE : rise.readthedocs.io


## Jupyter Notebook 기본
- 셀(cell) 단위로 작성하고 실행한다.
- 선언한 변수 등은 노트북 안에서 컨텍스트를 갖는다.
- 노트북의 내용(코드, 마크다운, 출력 등)은 checkpoint로 저장(캐싱) 된다.
- 노트북 파일(ipynb)은 JSON 파일


## 확장
- extension : jupyter_contrib_nbextensions
- widgets : jupyter widges
- theme : jupyter theme


## Jupyter Notebook
- 어디에 쓸까?
  - 데이터 분석과 개발 과정 전반에 사용
  - 개발 프로토타입을 만들 때
  - 그냥 개발용으로(지원 언어 40+)
- 누가 쓸까?
  - 데이터를 다루는 누구나!
  - 개발과 기록을 한번에, 내보내기와 공유
- 설치형
  - 그냥 설치(Python, pip)
  - anaconda(*) : 패키지 + 환경정리
  - docker
- 서비스형
  - Google Colab
  - Kaggle(*)
  - Cloud : AWS, GCP, Azure