# Markus의 플러터 세상

## 1. 

- 기본 위젯 넣는법

  - main.dart 가 렌더링 되는 페이지

  ```dart
  import 'package:flutter/material.dart';
  
  void main() {
    runApp(const MyApp());
  }
  ```

  - main() 함수 안에서 실행
  - void 는 이 함수는 아무것도 return 하지 말아달라는 뜻
  - runApp() 는 앱을 시작해달라는 기본 함수 → 그 안에 앱 레이아웃을 넣으면 진짜로 앱으로 보여줌
  - main() {} 함수 안에 MyApp 클래스 작성

  ```dart
  class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);
    @override
    Widget build(BuildContext context) {
  
      return MaterialApp(
        home: Text('안녕'),
      );
  
    }
  }
  ```

  - (stless 치고 탭키로 자동완성 가능)

  - 위 4줄은 앱의 메인페이지 세팅용 코드

  - home: 옆에 위젯을 넣어 개발

  - 위젯

    - HTML의 태그의 역할과 유사

      - Text()
      - Image()
      - Container()
      - Icon() 4가지로 거의 모든 레이아웃 가능

    - Text()

      ```dart
      MaterialApp(
        home: Text('안녕')
      )
      ```

      - Text 위젯 안에 넣고 싶은 글씨를 넣으면 보여짐
      - 두번째 파라미터부터 색, 크기, 폰트 등의 스타일 가능

    - Icon()

      ```dart
      MaterialApp(
        home: Icon(Icons.star)
      )
      ```

      - Icon 위젯 안에 Icons.아이콘 이름으로 아이콘 넣기 가능
      - https://api.flutter.dev/flutter/material/Icons-class.html 에서 아이콘 이름 검색해서

    - 이미지

      - 프로젝트 내에 assets 폴더 만들고 이미지 파일을 거기에 보관

      - pubspec.yaml

        ```yaml
        flutter:
          assets:
            - assets/
        ```

        - flutter: 에 하위항목에 assets안에 폴더 등록 → 이제 그 폴더에 있는 이미지들 전부 사용가능

      ```dart
      MaterialApp(
        home: Image.asset('assets/dog.png')
      )
      ```

      - Image.asset(’이미지경로’) 위젯으로 이미지 띄우기
      - 브라우저로 미리 볼땐 dog.png 만으로 가능

    - Container

      ```dart
      MaterialApp(
        home: Container()
      )
      ```

      - Container() 아니면 SizedBox() 둘 중 하나 쓰면 네모 박스 생성
      - 색상 같은 스타일 넣기 가능

- 폭 높이 조절하는 법

  ```dart
  MaterialApp(
    home: Container(width : 50, height : 50, color: Colors.blue)
  )
  ```

  - width, height, color 주기 가능

  - LP는 Logical Pixel의 약자, 1cm는 38LP

  - Container를 쓰면 자리를 최대한 차지하려고 → 꽉 차게 됨

  - **width, height 를 주고 싶으면 어디서 채울지 좌표를 줘야함**

    - X, Y position 필요
    - 보통은 직접 주지 않고 Center() 또는 Align()등의 위젯 이용
    - 이런 위젯에 담으면 자동으로 X, Y position을 잡아줌 → height, width 가능

    ```dart
    MaterialApp(
      home: Center( 
        child: Container(width : 50, height : 50, color: Colors.blue) 
      )
    )
    ```

- 위젯 안에 위젯넣기

  - Child라는 파라미터로 위젯안에 위젯넣기 가능

    ```dart
    MaterialApp(
      home: Container( 
        child: Text('박스안 글자임ㅅㄱ')
      )
    )
    ```