- 프로젝트 생성
    - terminal
        - flutter create 프로젝트명
- CupertinoApp()
    - Apple Style
- MaterialApp()
    - Google Style
- 반드시  콤마 , 를 넣어서 저장하라 (vscdode 확장으로 예뻐짐)
- Widget Inspector로 디버깅을 하라
    - 콘솔창같은거임
    - 콘솔창 처럼 바로 바꿔볼 수 있다
    - 실수로 껐다면 디버그 위젯에 맨오른쪽 플러터돋보기를 클릭
- 텍스트안에서 $는 변수를 나타내는 기호라서, 문자로 쓰고 싶으면 \를 앞에 붙여야함
- settings.json

```json
"[dart]": {
        "editor.codeActionsOnSave": {
            "source.fixAll": false
        },
        "editor.formatOnSave": true,
        "editor.formatOnType": true,
        "editor.rulers": [
            80
        ],
        "editor.selectionHighlight": false,
        "editor.suggest.snippetsPreventQuickSuggestions": false,
        "editor.suggestSelection": "first",
        "editor.tabCompletion": "onlySnippets",
        "editor.wordBasedSuggestions": false
    },
    "dart.previewFlutterUiGuides": true,
    "dart.openDevTools": "flutter",
    "git.openRepositoryInParentFolders": "always"
```

- 전구 ctrl+”.”  의 코드액션을 통해 리팩토링을 즐겨보자
    - 감싸기
    - 위 아래로 보내기
    - export
        - 등등 가능
- 파일명은 snake_case 로 해야 화를 안낸다.
