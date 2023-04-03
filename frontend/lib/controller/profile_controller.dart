import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final RxInt _profileLinkSeq = 0.obs;

  int get profileLinkSeq => _profileLinkSeq.value;

  @override
  void onInit() {
    super.onInit();
    // shared_preferences에서 토큰 값을로드합니다.
    _loadProfile();
  }

  void _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _profileLinkSeq.value = prefs.getInt('profileLinkSeq') ?? 0;
  }

  void saveProfile(int profileLinkSeq) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('profileLinkSeq', profileLinkSeq);
    _profileLinkSeq.value = profileLinkSeq;
  }

  void clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profileLinkSeq');
    _profileLinkSeq.value = 0;
  }
}
