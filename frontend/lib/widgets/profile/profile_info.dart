import 'package:flutter/material.dart';
import 'package:frontend/bottom_navigation.dart';
import 'package:frontend/controller/profile_controller.dart';
import 'package:get/get.dart';

class ProfileInfo extends StatelessWidget {
  final bool owner;

  final String nickname;
  final String name;
  final String birthDate;
  final String gender;

  final int imageCode;
  final int profileLinkSeq;
  // final String imagePath;
  // final String title;
  // final String description;

  const ProfileInfo({
    super.key,
    required this.owner,
    required this.nickname,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.imageCode,
    required this.profileLinkSeq,
  });

  updateProfile(int id) {
    //Get.put(ProfileController());
    final profileController = Get.find<ProfileController>();
    profileController.saveProfile(id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // profileLinkSeq 연결하긔
        print('업데이트된프로필정보$profileLinkSeq');
        await updateProfile(profileLinkSeq);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const BottomNavigation(
                      where: 0,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    'assets/images/profile$imageCode.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (owner)
                            const Icon(
                              Icons.auto_awesome,
                              color: Color(0xFFBBE4CB),
                            ),
                          Text(
                            nickname,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_rounded,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            birthDate,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (gender == 'M')
                            const Icon(
                              Icons.male_rounded,
                            ),
                          if (gender == 'M')
                            const Text(
                              '남성',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          if (gender == 'F') const Icon(Icons.female_rounded),
                          if (gender == 'F')
                            const Text(
                              '여성',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
