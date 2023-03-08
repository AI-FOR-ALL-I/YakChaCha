[https://www.youtube.com/watch?v=mLQ-ehf3d6Y&t=11s](https://www.youtube.com/watch?v=mLQ-ehf3d6Y&t=11s)

- lib - main.dart → 이게 메인페이지
    - *void* main() 밑에 다 지우기
        
        ```dart
        void main() {
          runApp(const MyApp()); // 앱 시작해주세요~ 라는 뜻
        }
        ```
        
    - stless 입력후 자동완성보기,
        
        ```dart
        class MyApp extends StatelessWidget {
          const MyApp({super.key});
        
          @override
          Widget build(BuildContext context) {
            return const Placeholder();
          }
        }
        ```
        
- 💥**설정**
    - analysis_options.yaml 에 적을게 있음
        - lint 끄기 → 초보라 끄고 씀
        
        ```yaml
        rules:
            # lint 끄기
            prefer_typing_uninitialized_variables : false
            prefer_const_constructors_in_immutables : false
            prefer_const_constructors : false
            avoid_print : false
        ```
        
- 플러터에서의 앱 디자인
    - 위젯 가지고 놀기
    - ex) 글자 넣기 → 글자 위젯, 박스 넣기 → 박스 위젯
    - 위젯는 보통 대문자로 시작하고 소괄호로 이루어짐

# 위젯

## 글자위젯

- Text()

## 이미지위젯

- Image.asset(’경로~~’)
    - 경로는 같은 루트안에 assets 폴더 생성
    - 이미지를 넣고, **이미지를 등록 해야함 → pubspec.yaml**
    - pubspec.yaml 에 등록하기
        - home: Image.asset('dotori.jpg')  or home: Image.asset('assets/dotori.jpg')
        
        ```dart
        # The following section is specific to Flutter packages.
        flutter:
          assets:
            - assets/
        -> assets 란 폴더 안에 있는걸 다 가져다 쓰겠다.
        
        ```
        

## 아이콘위젯

- Icon()
    - 플러터 홈페이지 참조

## 박스위젯

- Container()
    - 기본 투명한 박스
    - 스타일 줄 때 → 스타일명 : 값
        - `home: Container(width: 50, height: 50, color: Colors.blue,)`
        - 단위 : LP 단위 → 50LP == 1.2cm
- SizedBox()

## 센터위젯

- Center()
    - 내 자식 위젯의 기준점을 중앙으로 설정해준다.
    
    ```dart
    home: Center(
            child: Container(width: 50, height: 50, color: Colors.blue,)
          )
    ```
    

- 위젯안에 위젯 → child:
-
