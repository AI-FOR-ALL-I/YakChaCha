```dart
String sayHello1(String name) {
  return "Hello ${name} nice to meet you.";
}

String sayHello2(String name) => "Hello ${name} nice to meet you.";

num plus(num a, num b) => a + b;

// named parameter
// {} 로 묶어 named params 로 만든다.
// String sayHello3({String name, int age, String country}) { 이면
//    null일 수 있는 문제상황이 발생한다. -> defalut value 설정 or required 이용
// String sayHello3({required String name,required int age, required String country}) {
String sayHello3({String name = '짱구', int age = 5, String country = 'japan'}) {
  return "name: ${name}, age:${age}, country:${country}";
}

// 함수 function
void main() {
  print(sayHello1("남기성"));
  print(sayHello2("송진주"));
  print(plus(1, 2));
  // named params
  print(sayHello3(name: "dj", age: 28, country: 'korea'));
  print(sayHello3(country: 'korea'));
}
```
