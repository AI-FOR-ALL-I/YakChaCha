[https://www.youtube.com/watch?v=H_zCqRqg1F0&list=PLfLgtT94nNq1izG4R2WDN517iPX4WXH3C&index=6&t=1s](https://www.youtube.com/watch?v=H_zCqRqg1F0&list=PLfLgtT94nNq1izG4R2WDN517iPX4WXH3C&index=6&t=1s)

## Flex

- 박스폭을 50%로 설정하려면
    - Flextible() 로 감싸고 child에 container 이용 (3:7 예시)
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/82bc9b8e-4509-4de4-983c-60133f2a4d40/Untitled.png)
    
    ```dart
    body: Row(
            children: [
              Flexible(
                  flex: 3,
                  child: Container(
                    color: Color.fromARGB(255, 255, 55, 37),
                  )),
              Flexible(
                  flex: 7,
                  child: Container(
                    color: Color.fromARGB(156, 71, 227, 255)),
                  ),
            ],
          ),
    ```
    
- Row() 안에서 박스 하나만 꽉 채우고 싶으면 Expanded()
    - flex를 1가진 Flexible 박스랑 똑같음
    - 본인만 flex를 가지면 본인만 커짐
    
    ```dart
    body: Row(
            children: [
              Expanded(
                  
                  child: Container(
                    color: Color.fromARGB(255, 255, 55, 37),
                  )),
              Container(
                width: 100,
                    color: Color.fromARGB(156, 71, 227, 255)),
    
            ],
          ),
    ```
    

## 박스 디자인시 의도와 다르다면

1. 사이즈가 이상해서
2. 박스 위치가 이상해서
    
    → DevTools 켜보기 → 콘솔창
    
3. 박스의 크기를 의심
    - 폭을 퍼센트로 주면 호환성 증가

---

숙제 대충 따라한 코드

```dart
body: Container(
        height: 150,
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Image.asset("dotori.jpg", width: 130, height: 130,),
            SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("도토리팝니다"),
                  Text("수원어딘가"),
                  Text("10억원"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.favorite),
                      Text("4")
                    ],)
                ],
              ),
            )
          ],
        ),

      )
    ));
```

[https://www.youtube.com/watch?v=Y1Q4-GxIUHc&list=PLfLgtT94nNq1izG4R2WDN517iPX4WXH3C&index=7](https://www.youtube.com/watch?v=Y1Q4-GxIUHc&list=PLfLgtT94nNq1izG4R2WDN517iPX4WXH3C&index=7)

- 레이아웃용 위젤들이 너무 길다면
    - 커스텀 위젯으로 깔끔하게 축약가능
1. stless → Flutter Stateless Widget 클릭
2. class 작명 (대문자로 시작)
3. return 옆에 축약할 레이아웃 넣기
- 변수, 함수 문법으로도 축약 가능
    - 평생 안변하는 애들은 이걸로 가능
    - 그런데 모양이 변하는 애들은 성능이슈 발생 → stless 사용
- 아무거나 다 커스텀위젯화 하면 안됨!
    - state관리가 힘들어질 수 도
    - 재사용이 많은 UI들 or 큰 페이지들을 커스텀 위젯으로 사용!!

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(),
            body: Row(
              children: [CostumWidget(), a],
            )));
  }
}

// 커스텀 위젯
class CostumWidget extends StatelessWidget {
  const CostumWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('안녕1'),
    );
  }
}

// 또 다른 커스텀
var a = SizedBox(
  child: Text("안녕2"),
);
```

---

## ListView → 앱에 보여줄게 많을 때!

- 위젯이 많다고 해서 스크롤바가 자동으로 생기지 않는다.
    
    → ListView 사용!
    
    - 스크롤바도 생기고 스크롤 위치 감시도 가능함!
    - 메모리 절약
        - 유저가 보고있는 곳만 메모리에 이용하게끔 가능

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(),
            body: ListView(
              // controller: ScrollController(), // 스크롤 위치 감시
              children: [
                CostumWidget(),
                CostumWidget(),
                CostumWidget(),
                CostumWidget(),
                CostumWidget(),
                CostumWidget(),
                CostumWidget(),
              ],
            )));
  }
}

// 커스텀 위젯
class CostumWidget extends StatelessWidget {
  const CostumWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Text('안녕1'),
    );
  }
}
```

