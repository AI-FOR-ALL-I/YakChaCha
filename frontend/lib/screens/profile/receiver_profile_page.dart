import 'package:flutter/material.dart';
import 'package:frontend/screens/profile/receiver_number_page.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';

class ReceiverProfilePage extends StatefulWidget {
  const ReceiverProfilePage({super.key});

  @override
  State<ReceiverProfilePage> createState() => _ReceiverProfilePageState();
}

class _ReceiverProfilePageState extends State<ReceiverProfilePage> {
  List<Map<String, dynamic>> data = [
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
      ]
    }
  ];
  //final dio = Dio();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {}
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
                      child: Column(
                          children: List.generate(data.length, (index) {
                final profiles = data[index]['profiles'];
                return Column(
                  children: List.generate(profiles.length, (index) {
                    final profile = profiles[index];
                    return ListTile(
                      leading: Text(profile['imgCode'].toString()), // 프로필 이미지
                      title: Text(profile['nickname']), // 닉네임
                      subtitle: Text(profile['name']), // 이름
                      trailing: Text(profile['status'].toString()), // 상태 메시지
                      onTap: () {
                        // 프로필 선택 이벤트 처리하기
                      },
                    );
                  }),
                );
              })))),
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
