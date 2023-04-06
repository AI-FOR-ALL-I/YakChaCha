import 'package:flutter/material.dart';
import 'package:frontend/screens/profile/receiver_number_page.dart';
import 'package:frontend/services/api_profiles.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class ReceiverProfilePage extends StatefulWidget {
  final int? senderAccountSeq; // 푸시알림에서 온 내용
  const ReceiverProfilePage({Key? key, this.senderAccountSeq})
      : super(key: key);

  @override
  State<ReceiverProfilePage> createState() => _ReceiverProfilePageState();
}

class _ReceiverProfilePageState extends State<ReceiverProfilePage> {
  Map<String, dynamic>? data;
  List<int> selectedItems = [];
  // List<Map<String, dynamic>> profileInfo = [];
  //final dio = Dio();
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    // senderAccountSeq를 활용해서 통신
    // ApiProfiles.getReceiversInfo(${widget.senderAccountSeq});
    try {
      dio.Response response =
          await ApiProfiles.getReceiversInfo(widget.senderAccountSeq!);
      if (response.statusCode == 200) {
        final Map<String, dynamic> newData =
            Map<String, dynamic>.from(response.data);
        setState(() {
          data = newData;
          print('whyrano$data');
        });
      }
    } catch (e) {
      e.printError(info: 'errors');
    }
  }

  void sendToServer(List<int> profiles) async {
    try {
      dio.Response response = await ApiProfiles.selectProfileToConnect(
          widget.senderAccountSeq!, profiles);
      if (response.statusCode == 200) {
        // TODO: move to 번호조회 페이지
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReceiverNumberPage(
                      senderAccountSeq: widget.senderAccountSeq!,
                    )));
        // senderAccoutSeq 값 함께 넘겨주어야함!!!
        // {SERVER}/links/sender/{senderAccountSeq}/auth
      }
    } catch (e) {
      e.printError(info: 'errors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const SimpleAppBar(title: '프로필 선택'),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('user님에게 공유할\n프로필을 선택해주세요.',
                  style: TextStyle(fontSize: 20.0, color: Colors.black54)),
              const SizedBox(height: 16.0),
              Expanded(
                child: data == null
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: data!['data']['profiles'].length,
                        itemBuilder: (context, index) {
                          final profile = data!['data']['profiles'][index];
                          bool isSelected =
                              selectedItems.contains(profile['profileLinkSeq']);
                          bool isSelectable = profile['status'] == 1;
                          return InkWell(
                            onTap: isSelectable
                                ? () {
                                    // 프로필 선택 이벤트 처리하기
                                    setState(() {
                                      if (isSelected) {
                                        selectedItems.removeWhere((item) =>
                                            item == profile['profileLinkSeq']);
                                        print('selected$selectedItems');
                                      } else {
                                        selectedItems
                                            .add(profile['profileLinkSeq']);
                                        print('selected$selectedItems');
                                      }
                                    });
                                  }
                                : null,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: isSelected
                                    ? Colors.grey.shade300
                                    : Colors.white,
                                border: isSelected
                                    ? Border.all(color: Colors.green, width: 1)
                                    : null,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.asset(
                                          'assets/images/profile${profile['imgCode']}.png',
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                if (profile['status'] == 1)
                                                  const Icon(
                                                    Icons.auto_awesome,
                                                  ),
                                                Text(
                                                  profile['nickname'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(
                                                  profile['name'],
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
                                                  profile['birthDate'],
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                if (profile['gender'] == 'M')
                                                  const Icon(
                                                    Icons.male_rounded,
                                                  ),
                                                if (profile['gender'] == 'M')
                                                  const Text(
                                                    '남성',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                if (profile['gender'] == 'F')
                                                  const Icon(
                                                      Icons.female_rounded),
                                                if (profile['gender'] == 'F')
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
                        },
                      ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                      onTap: () {
                        // 서버통신진행
                        //sendDataToServer(context);
                        // 번호 확인하는 페이지로 이동
                        sendToServer(selectedItems);
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
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
