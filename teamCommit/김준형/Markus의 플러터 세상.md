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

- MaterialApp()

  - 기본 플러터 테마는 2가지

    - Material Design : 구글 스타일
    - Cupertino : 아이폰 스타일

  - MaterialApp() 의 경우 디자인 뿐 아니라 앱의 구조와 기본 설정도 제공하는 위젯

    - 이 위젯을 사용하되 커스텀 스타일을 입히는 방식으로 개발

  - Material Design을 쓰기 위해서는 일단 pubspec.yaml파일에 다음 항목이 true일 것

    ```yaml
    flutter:
      uses-material-design: true
    ```

- Scaffold()

  - Scaffold() 위젯은 appBar, body, bottomNavigationBar 이렇게 3개의 파라미터로 상중하로 나뉨
  - body는 필수

  ```dart
  MaterialApp(
    home: Scaffold(
      appBar: AppBar( title: Text('앱제목') ), 
      body: Text('안녕'), 
      bottomNavigationBar: BottomAppBar( child: Text('하단바임 ㅅㄱ') ),
    )
  );
  ```

  - AppBar()는 상단 바 간단히 넣고 싶을 때 쓰는 기본 위젯, title파라미터 가능
  - BottomAppBar()는 하단바 넣고 싶을 때 쓰는 기본 위젯, child 파라미터를 가능
  - 어떤 파라미터가 가능할지 여부는 소괄호 안에서 ctrl + space로 확인가능

- Row()/Column()

  - 가로 정렬, 세로 정렬을 하고 싶다면 Row/Column위젯을 쓰고 그 안에 배치하고 싶은 위젯을 child 파라미터에 리스트 형태로 넣기

    ```dart
    MaterialApp(
      home: Scaffold(
        body: Row( 
          children: [ Icon(Icons.star), Icon(Icons.star), Icon(Icons.star) ] 
        ), 
      )
    );
    ```

  - 파라미터로 mainAxisAlignement: 파라미터를 이용하면 위젯들이 배치되는 간격 조정 가능

    - mainAxis는 주 축, crossAxis는 반대 축
    - .spaceEvenly는 모든 여백 동일
    - .spaceBetween은 좌우 끝에 우선 배치
    - .spaceAround는 모든 여백 동일인데 좌우 마지막 여백은 절반만큼
    - .start는 시작 부분에 다 모여
    - .end는 끝 부분에 다 모여
    - .center는 중간에 다 모여

- SizedBox()

  - Container() 대신 SizedBox 쓰기 가능 → SizedBox()는 width와 height 파라미터만 가능, 훨씬 가벼움

- Container()

  - margin:, padding: 파라미터로 여백 지정 가능
  - 다만 EdgeInsets.all(30)의 형태로 안에 수치를 입력해야 함
  - EdgeInsets.fromLTRB(10, 20, 30, 40) 처럼 좌사우하의 여백 각기 주기 가능
  - Row(), Column() 여백 불가능 필요시 그 안에 있는 Container() 위젯 안쪽이나 바깥쪽 아무데나 추가
  - (참고) Padding()위젯은 그냥 padding을 위한 위젯
  - 기타 박스 스타일은 decoration: BoxDecoration() 안에 넣음

  ```dart
  Container(
    decoration : BoxDecoration(
      border : Border.all(color : Colors.black)
    )
  )
  ```

  - 안에 color, shape, boxShadow, gradient, image, borderRadius 등 가능
  - Align()

  ```dart
  Align(
    alignment : Alignment.bottomLeft,
    child : Container( width : 50, height : 50, color : Colors.blue )
  )
  ```

  - 이러면 하단 왼쪽 정렬 가능, Alignment.bottomLeft 자리를 바꿔서 상하좌우정렬 가능
  - 박스의 너비를 꽉차게 만드는 코드(부모 박스의 폭을 넘지는 않음)

  ```dart
  Container( width : double.infinity, height : 50, color : Colors.blue )
  ```

- Typography

  ```dart
  Text( '글자임', 
    style : TextStyle( color : Colors.red ) 
  )
  ```

  - TextStyle()안에서 텍스트 타이포그래피 설정 가능

    - backgroundColor: 색상
    - fontSize: 30
    - fontWeight: FontWeight.w700
    - fontFamily: ‘폰트종류’
    - letterSpacing: 3 등등…

  - color

    ```dart
    color : Colors.red, 
    color : Color.fromRGBO(20,130,50,0.8), 
    color : Color(0xffffffff)
    ```

- Button()

  ```dart
  TextButton( child: Text('버튼임'), onPressed: (){} )
  ElevatedButton( child: Text('버튼임'), onPressed: (){} )
  IconButton( icon: Icon(), onPressed: (){} )
  ```

  - 모양만 다르고 기능은 같음
  - onPressed: 파라미터에 함수로 기능 넣기 가능, 빈거라ㅗ 안넣으면 에러

- AppBar()

  - 자주쓰는 AppBar() 방식

  ```dart
  AppBar(
    title : Text('앱제목'),
    leading : Icon(Icons.star),
    actions : [ Icon(Icons.star), Icon(Icons.star) ]
  )
  ```

- Flexible()

  - Row() 등 안에 박스를 배치할 때, 박스의 폭을 고정된 숫자가 아니라 50%등으로 보여주고 싶을 때 사용 → Flexible()안에 박스들을 담으면 됨

    ```dart
    Row(
      children : [
        Flexible( child: Container(color : Colors.blue), flex : 1 ),
        Flexible( child: Container(Color : Colors.green), flex : 1 )
      ]
    )
    ```

    - Row 안에 있는 것들을 Flexible()로 각각 감싼 뒤, flex파라미터를 주면 됨
    - flex 파라미터는 각 박스가 얼마나 가로폭을 차지할지 결정하는 배수
    - 해당 예시는 1:1로 배치될 것

- Expanded()

  - 하나의 박스만으로 가로폭을 꽉 채우고 싶다면 Expanded() 사용
  - 그거로 감싼 박스는 남는 폭을 꽉 채우고 싶어함

  ```dart
  Row(
    children : [
      Expanded( child: Container(color : Colors.blue), flex : 1 ),
      Container(Color : Colors.green, width : 100),
    ]
  )
  ```

- 커스텀 위젯

  - 코드가 길어지면 커스텀 위젯으로 따로 빼서 변수처럼 사용하는 것 추천

  ```dart
  class 작명하셈 extends StatelessWidget {
    const 작명하셈({Key? key}) : super(key: key);
    @override
    Widget build(BuildContext context) {
  
      return 짧은단어로축약할위젯()
  
    }
  }
  ```

  - return 오른쪽 위젯 부분에 내가 만들고 싶은 위젯의 내용을 넣고
  - 이후 작명하셈() 이라고 쓰면 그 자리에 내가 만들고 싶은 위젯의 내용이 들어감
  - 커스텀 위젯은 만들어 놓으면 아무데나 사용가능
  - 커스텀 위젯 안에서 커스텀 위젯 사용도 가능
  - 아무거나 다 커스텀 위젯화 하기 보다는 재사용이 잦은 UI, 큰 페이지 들을 커스텀 위젯화
  - (참고) 문법 설명
    - class 쓰는 이유 : 모든 Flutter의 위젯은 class
      - class 위젯명 {위젯정보~~}의 형태
      - 다만 위젯에 필요한 수많은 변수와 함수가 들어 있어야 위젯용 class로 인정 → 따라서 완성되어 있는 class 복붙
    - class를 복붙해서 새로운 class로 만들고 싶다면 extends키워드 사용
      - 위젯 class의 프로토타입은 StatelessWidget
      - class 위젯명 extends StatelessWidget{} 이런 식으로 새 커스텀 위젯 준비 끝
    - @overide
      - 커스텀 위젯 class 안에는 build(){} 라는 함수를 선언하고 그 안에 위젯을 넣게 되어있음
      - 그런데 extends로 불러온 StatelessWidget에도 build는 존재할 것
      - 따라서 그 중복을 덮어쓰기 위해 override 사용

- ListView()

  - ListView()의 장점
    - 무한 스크롤
    - 데이터만 있으면 자동 반복
    - 지나간 목록은 메모리에서 삭제 → 메모리 절약

  ```dart
  ListView(
    children: [
      Text('안녕'),
      Text('안녕'),
      Text('안녕'),
    ],
  )
  ```

  - ListView()는 Column()과 유사하게 사용
  - children : [] 안에 목록으로 만들 위젯 넣기
  - 데이터 많으면 알아서 스크롤 생김

- ListTitle()

  - 왼쪽에 그림이 있고, 오른쪽에 글이 있는 레이아웃 등을 위해 사용

  ```dart
  ListTile(
    leading : Image.asset('assets/profile.png'),
    title : Text('홍길동')
  )
  ```

- ListView.builder()

  - 서버에서 정보를 가져오는 등으로 인해 리스트 갯수를 아직 모르는 경우 리스트 갯수 동적 생성

  ```dart
  ListView.builder(
    itemCount: 20,
    itemBuilder: (context, i) {
      return Text('안녕');
    }
  );
  ```

  - itemCount: 리스트 갯수
  - itemBuilder: () {return 반복할 위젯}
  - i 변수는 0 부터 1씩 증가하는 변수
  - (참고) : print()를 함수안에서 쓰면 콘솔 출력 가능

  ```dart
  ListView.builder(
    itemCount: 3,
    itemBuilder: (context, i) {
      print(i);
      return ListTile(
        leading : Image.asset('profile.png'),
        title : Text('홍길동'),
      )
    }
  );
  ```

- FloatingActionButton

  ```dart
  MaterialApp(
    home: Scaffold(
      floatingActionButtion: FloatingActionButton(
        child : Text('버튼'),
        onPressed: (){}
      ),
      appBar: AppBar(),
      body: 생략
    ),
  )
  ```

  - 하단에 공중에 뜬 버튼 가능 (줄여서 FAB이라고 부름)
  - 버튼 안 onPressed() {실행할 코드}에 넣어서 버튼시 실행 가능

  ```dart
  class MyApp extends StatelessWidget {
    MyApp({Key? key}) : super(key: key);
    var a = 1;
  
    @override
    Widget build(BuildContext context) {
  
      return MaterialApp(
        home : Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Text('버튼'),
            onPressed: (){ a++; print(a); },
          ),
          body: ,
          appBar: AppBar(),
        )
      );
  
    }
  }
  ```

  - 해당코드로 버튼을 누르면 a라는 변수가 +1 되고 출력됨
  - 다만 Text(’버튼’) 대신 Text(a.toString())을 해도 버튼 숫자 안바뀜 → 재랜더링 필요

- StatefulWidget()

  - 위젯의 경우 변경사항이 생겼을 때 재 랜더링을 해줘야 보임

  - state를 이용하면 자동으로 재랜더링 가능

  - state를 쓰는 위젯은 StatefulWidget()

  - stful 자동완성으로 생성

    ```dart
    class 테스트 extends StatefulWidget {
      const 테스트({Key? key}) : super(key: key);
      @override
      _테스트State createState() => _테스트State();
    }
    
    class _테스트State extends State {
    
      var a = 1;  //여기 만드는 변수는 state가 됩니다 
      @override
      Widget build(BuildContext context) {
        return Container();
      }
    }
    ```

    - 자동완성시 클래스가 두개 생기는데, 그 중 아래 class에 변수를 만들면 자동으로 state가 됨
    - 해당 state가 변경 되면 자동으로 재렌더링되는 방식

  - 기존의 쓰던 StatelessWidget을 StatefulWidget으로 변경 가능(자동완성 전구)

    ```dart
    class MyApp extends StatefulWidget {
      const MyApp({Key? key}) : super(key: key);
      @override
      _MyAppState createState() => _MyAppState();
    }
    
    class _MyAppState extends State {
    
      var a = 1;  //여기 만드는 변수는 state가 됩니다 
      @override
      Widget build(BuildContext context) {
        return Scaffold(생략);
      }
    }
    ```

    - MyApp을 StatefulWidget으로 변경가능

- setState(() {변경할 내용})

  - state를 사용하는 경우, state의 변경은 무조건 setState를 통해서만 이뤄져야 한다.

    ```dart
    MaterialApp(
      home: Scaffold(
        floatingActionButtion: FloatingActionButton(
          child : Text(a.toString()),
          onPressed: (){ 
            setState((){
              a++
            });
          }
        ),
        appBar: AppBar(),
        body: 생략
      ),
    )
    ```

  - class 대신 변수 함수 써도 되지만, 재렌더링이 필요하면 widget으로 만들어서 쓰는게 성능에 이점

  ```dart
  class _MyAppState extends State {
    var a = 1;
    var name = ['김영숙', '홍길동', '피자집'];
    @override
    (생략)
  }
  ```

  ```dart
  ListView.builder(
    itemCount: 3,
    itemBuilder: (context, i) {
      return ListTile(
        leading : Image.asset('profile.png'),
        title : Text(name[i]),
      )
    }
  );
  ```

  - 이런 식으로 리스트에 저장하고 차례대로 출력가능

- Dialog()

  - 모달창 가능
    - (참고) 소문자로 시작하면 함수, 대문자로 시작하면 위젯
  - showDialog()를 쓰면 Diaolg 위젯이 뿅 뜸
  - 따라서 버튼의 onPressed: 안에 넣는 식으로 모달 띄우기 가능

  ```dart
  FloatingActionButton(
    child: Text('버튼'),
    onPressed: () {
  
    showDialog(
      context: context, 
      builder: (context){
       return Dialog(
         child: Text('AlertDialog Title'),
       );
     },
    );
  
    },
  ),
  ```

  - showDialog()의 첫 파라미터는 context

  - 두번째 파라미터는 builder:, 여기에 위젯을 return으로 뱉는 함수를 넣기

  - Dialog()는 모달창 같이 배경 시커먼 하얀 박스 만들어주는 기본 위젯

  - 다만 이러면 context로 인해 에러가 뜰 가능성이 높음

  - 해결책

    ```dart
    void main() {
      runApp( 
        MaterialApp( 
          home : MyApp() 
        ) 
      );
    }
    
    class _MyAppState extends State<MyApp> {
    @override
    Widget build(BuildContext context) {
      return Scaffold( 안쪽 생략 );
    ```

    - MaterialApp() 부분을 밖으로 빼는 방식 가능

      - 이유 설명 : context는 상위 위젯들이 무엇이 있는지 정보를 담고 있는 일종의 족보
      - showDialog()
      - Navigator()
      - Theme.of()
      - Scaffold.of() 와 같은 함수들은 context를 소괄호 안에 집어넣어야 잘 작동하는 함수
      - 그중 showDialog()의 경우 context 안에 MaterialApp이 부모로 들어있어야 됨

      ```dart
      showDialog( context : MaterialApp이부모로들어있는족보 )
      ```

      - 따라서 MaterialApp()을 아예 부모로 빼는 것으로 해결 가능

    - 또는 Build() 위젯 사용

      ```dart
      build (context) {
          return MaterialApp(
            home: Scaffold(
              floatingActionButton: Builder(
                builder: (jokbo1) {
                  return FloatingActionButton(
                    onPressed: (){
                      showDialog( context: jokbo1,
                        builder: (context){ return Dialog( child: Text('AlertDialog Title'), ); },
                      );
                    },
                  );
                }
              ),
      ```

      이러면 중간에 jokbo1라는 이름의 context가 생성되고, 그 안에 MaterialApp()이 들어가기 때문에 해당 context를 사용하면 문제 해결, 그러나 해결책 1이 더 쉽기 때문에 그쪽 추천, 2는 응급상황에 사용

- props

  - 보내기 → 자식에서 state 이름 등록 → 자식에서 사용의 3단계

  1. 보내기

  ```dart
  DialogUI( state : a )
  ```

  - 자식 위젯에 파라미터로 넣으면 끝, `작명 : 변수명`

  1. 자식에서 state 등록

  ```dart
  class DialogUI extends StatelessWidget {
    DialogUI({Key? key, this.state }) : super(key: key);
    final state;
  ```

  - 자식 위젯의 정의부분(두 class중에서 위의 class)에서 어떤 파라미터가 들어올 수 있는지 등록
  - 중괄호 안에 this.작명이름, 끝에 final 작명이름 2개 작성
    - final은 var과 같은 변수 문법, final은 변경안되는 변수, 따라서 대신 var을 써도 됨

  1. 이제 state라는 이름으로 자식 위젯에서 변수 사용 가능

  - (참고)

    - DialogUI({Key? key, this.state })

      - 커스텀 위젯은 클래스로 작성, 근데 클래스를 사용할 떄 파라미터를 입력할 수 있도록 class 업그레이드 가능

      ```dart
      class DialogUI extends StatelessWidget {
        DialogUI(this.파라미터1, this.파라미터2);
        final 파라미터1;
        final 파라미터2;
      ```