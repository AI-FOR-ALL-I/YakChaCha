[https://www.youtube.com/watch?v=U6rLIFn59Kw](https://www.youtube.com/watch?v=U6rLIFn59Kw)

- MaterialApp() 위젯
    - 구글이 제공하는 Material theme이나 위젯들 사용가능
    - 아이폰은 Cupertino
    - 그냥 내 맛대로 하고싶다 → MaterialApp() 그대로 → 기본 세팅이 편함
        - 구글물을 나중에 빼는 식으로
- Scaffold()
    - 앱을 상중하로 나눠준다.
    - 기본적인 앱 디자인
        
        ```dart
        home : Scaffold(
                appBar: AppBar(),
                body: Container(),
                bottomNavigationBar: BottomAppBar(),
              )
        ```
        
    - 여러 위젯 가로로 배치하는 법
        
        ```dart
        body: Row(
                  children: [
                    Icon(Icons.star),
                    Icon(Icons.star),
                    Icon(Icons.star),
                  ],
                ),
        ```
        
    - 여러 위젯 세로로 배치하는 법
        
        ```dart
        body: Column(
                  children: [
                    Icon(Icons.star),
                    Icon(Icons.star),
                    Icon(Icons.star),
                  ],
                ),
        ```
        
    - 여러 위젯 정렬하기
        - mainAxisAlignment: MainAxisAlignment. &  이용
            
            ```dart
            body: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 가로 축 (Row에서)
            					crossAxisAlignment: CrossAxisAlignment.center, // 세로 축
                      children: [
                        Icon(Icons.star),
                        Icon(Icons.star),
                        Icon(Icons.star),
                      ],
                    ),
            ```
            
    
    ### 실습
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/e845bd7d-e11d-4f79-ada7-23ef792c7b79/Untitled.png)
    
    ```dart
    @override
      Widget build(BuildContext context) {
        return MaterialApp(
            // 여기다 코드짜기
            // home: Image.asset('dotori.jpg')
            // home: Center(
            //   child: Container(width: 50, height: 50, color: Colors.blue,)
            // )
            home: Scaffold(
                appBar: AppBar(
                  title: Text("앱바"),
                  backgroundColor: Color.fromARGB(255, 79, 202, 255),
                ),
                body: Text("바디"),
                bottomNavigationBar: BottomAppBar(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.phone),
                        Icon(Icons.message),
                        Icon(Icons.contact_page),
                      ]
                    ),
                
                )));
      }
    }
    ```
