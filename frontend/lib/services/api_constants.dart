class ApiConstants {
  // Bearer Token (마스터 계정)
  static const String TOKEN =
      "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0NTYiLCJpYXQiOjE2ODAwNzQ4MjAsImV4cCI6MTY4MDA3ODQyMH0.TqcDe4uR1CfI5iCFKXgOjh3tAjFPIXId_QW36PXjWfI";
  static const int profileLinkSeq = 1;

  // base url
  static const String baseurl = 'https://j8a803.p.ssafy.io/api';
  // 계정
  static const String login = '$baseurl/accounts/sign-in';
  static const String logout = '$baseurl/accounts/sign-out';

  // 프로필
  static const String createProfile = '$baseurl/profiles'; // 생성
  static const String getProfiles = '$baseurl/profiles'; // 조회

  // 검색
  static const String search =
      '$baseurl/profiles/${profileLinkSeq}/medicine/search';

  // 등록
  static const String pillRegister = '$baseurl/medicine/taking';
}
