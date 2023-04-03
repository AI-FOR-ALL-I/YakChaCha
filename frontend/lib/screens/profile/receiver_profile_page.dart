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
  /*
  {
      "senderAccountSeq": 1,
      "senderAccountName": "삼성맨",
      "profiles": [
        {
          "profileLinkSeq": 1,
          "imgCode": 1,
          "nickname": "닉네임2",
          "name": "사용자12",
          "gender": "M",
          "birthDate": "1999-01-01",
          "status": 2,
          "pregnancy": false
        },
        {
          "profileLinkSeq": 2,
          "imgCode": 1,
          "nickname": "닉네임1",
          "name": "사용자1",
          "gender": "M",
          "birthDate": "1999-01-01",
          "status": 1,
          "pregnancy": false
        },
        {
          "profileLinkSeq": 2,
          "imgCode": 1,
          "nickname": "닉네임1",
          "name": "사용자1",
          "gender": "M",
          "birthDate": "1999-01-01",
          "status": 1,
          "pregnancy": false
        },
        {
          "profileLinkSeq": 2,
          "imgCode": 1,
          "nickname": "닉네임1",
          "name": "사용자1",
          "gender": "M",
          "birthDate": "1999-01-01",
          "status": 1,
          "pregnancy": false
        },
        {
          "profileLinkSeq": 2,
          "imgCode": 1,
          "nickname": "닉네임1",
          "name": "사용자1",
          "gender": "M",
          "birthDate": "1999-01-01",
          "status": 1,
          "pregnancy": false
        },
        {
          "profileLinkSeq": 2,
          "imgCode": 1,
          "nickname": "닉네임1",
          "name": "사용자1",
          "gender": "M",
          "birthDate": "1999-01-01",
          "status": 1,
          "pregnancy": false
        },
        {
          "profileLinkSeq": 2,
          "imgCode": 1,
          "nickname": "닉네임1",
          "name": "사용자1",
          "gender": "M",
          "birthDate": "1999-01-01",
          "status": 1,
          "pregnancy": false
        },
        {
          "profileLinkSeq": 2,
          "imgCode": 1,
          "nickname": "닉네임1",
          "name": "사용자1",
          "gender": "M",
          "birthDate": "1999-01-01",
          "status": 1,
          "pregnancy": false
        }
  
   */
  Map<String, dynamic> data = {};

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
          print('에혀시발!!!!$data');
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
                child: SingleChildScrollView(
                  child: data['data']['profiles'] == null
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: List.generate(
                              data['data']['profiles'].length, (index) {
                            final profile = data['data']['profiles'][index];
                            return ListTile(
                              leading: Text(
                                  profile['imgCode'].toString()), // 프로필 이미지
                              title: Text(profile['nickname']), // 닉네임
                              subtitle: Text(profile['name']), // 이름
                              trailing:
                                  Text(profile['status'].toString()), // 상태 메시지
                              onTap: () {
                                // 프로필 선택 이벤트 처리하기
                              },
                            );
                          }),
                        ),
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
