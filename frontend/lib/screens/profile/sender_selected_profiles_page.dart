import 'package:flutter/material.dart';
import 'package:frontend/services/api_profiles.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:dio/dio.dart';
import 'package:frontend/bottom_navigation.dart';

class SenderSelectedProfilesPage extends StatefulWidget {
  const SenderSelectedProfilesPage({super.key});

  @override
  State<SenderSelectedProfilesPage> createState() =>
      _SenderSelectedProfilesPageState();
}

class _SenderSelectedProfilesPageState
    extends State<SenderSelectedProfilesPage> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> sendData = []; // post로 보낼 정보
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void sendToServer(context) async {
    try {
      Response response = await ApiProfiles.postInfos(sendData);
      if (response.statusCode == 200) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("제목"),
                content: const Text("내용"),
                actions: [
                  TextButton(
                    child: const Text("확인"),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BottomNavigation(
                                    where: 0,
                                  ))); // 다음 화면으로 이동
                    },
                  ),
                ],
              );
            });
      }
    } catch (e) {}
  }

  void getData() async {
    try {
      Response response = await ApiProfiles.getList();
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> newData =
            List<Map<String, dynamic>>.from(response.data['data']);
        setState(() {
          data = newData;
          print('data$data');
        });

        for (int i = 0; i < data.length; i++) {
          Map<String, dynamic> object = {
            "profileSeq": data[i]['profileSeq'],
            "imgCode": data[i]['imgCode'],
            "nickname": data[i]['nickname'],
          };
          sendData.add(object);
        }
      } else {
        // 오류처리
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(title: '프로필 연동 확인'),
      body: data.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = data[index];
                        return Container(
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
                                      'assets/images/profile${item['imgCode']}.png',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            item['nickname'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5.0,
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
                                            item['birthDate'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          if (item['gender'] == 'M')
                                            const Icon(
                                              Icons.male_rounded,
                                            ),
                                          if (item['gender'] == 'M')
                                            const Text(
                                              '남성',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          if (item['gender'] == 'F')
                                            const Icon(Icons.female_rounded),
                                          if (item['gender'] == 'F')
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
                              ],
                            ),
                          ),
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: InkWell(
                            onTap: () {
                              // 서버통신진행
                              //sendDataToServer(context);
                              // 번호 확인하는 페이지로 이동
                              sendToServer(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 32,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFBBe4CB),
                                  width: 2,
                                ),
                                color: const Color(0xFFBBe4CB),
                              ),
                              child: const Text(
                                '등록하기',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
