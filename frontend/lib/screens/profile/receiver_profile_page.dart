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
                              padding: const EdgeInsets.all(16.0),
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        profile['nickname'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Text(
                                        profile['status'].toString(),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    profile['name'],
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    profile['gender'] +
                                        ' ' +
                                        profile['birthDate'],
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ReceiverNumberPage()));
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
