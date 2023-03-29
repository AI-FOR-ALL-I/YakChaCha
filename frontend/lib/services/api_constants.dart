class ApiConstants {
  // Bearer Token (마스터 계정)
  static const String TOKEN =
      "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0NTYiLCJpYXQiOjE2Nzk5MDE3NzEsImV4cCI6MTY4MDUwNjU3MX0.pFQweBt8T4Oi0vdKfoHPZM3BEPfvYZqvWml4IvtOqdI";
  static const int profileLinkSeq = 1;

  // base url
  static const String baseurl = 'https://j8a803.p.ssafy.io/api';
  // 계정
  static const String login = '$baseurl/accounts/sign-in';
  static const String logout = '$baseurl/accounts/sign-out';

  // 프로필
  static const String profiles = 'profiles';
  static const String createProfile = '$baseurl/$profiles'; // 생성 POST
  static const String getProfiles = '$baseurl/$profiles'; // 프로필 전체 리스트 조회 GET
  static const String getProfileInfo =
      '$baseurl/$profiles/{profileLinkSeq}'; // 특정 프로필 조회 GET
  static const String modifyProfile =
      '$baseurl/$profiles/{profileLinkSeq}'; // 프로필 수정 PUT
  static const String deleteProfile =
      '$baseurl/$profiles/{profileLinkSeq}/delete'; // 프로필 삭제 PUT

  // 검색
  static const String search = '$baseurl/medicine/search';
}
