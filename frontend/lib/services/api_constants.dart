class ApiConstants {
  // Bearer Token (마스터 계정)
  static const String TOKEN =
      "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0NTYiLCJpYXQiOjE2Nzk5MDMyODgsImV4cCI6MTY4MDUwODA4OH0.jsJ033L71MEdsfDgRT5t3F61qrFu94yGFdfwO1jS00s";
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
  static const String search =
      '$baseurl/profiles/$profileLinkSeq/medicine/search';

  // 약 등록
  static const String pillRegister =
      '$baseurl/profiles/${profileLinkSeq}/medicine/my';
      
  // 알람 등록
  static const String alarmRegister =
      '$baseurl/profiles/${profileLinkSeq}/reminders';


}
