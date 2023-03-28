import 'package:flutter/material.dart';
import 'package:frontend/widgets/text_search/text_search_pill_to_register.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/screens/search/text_search_page.dart';
import 'package:frontend/screens/drug_history_page.dart';
import 'package:frontend/widgets/common/bottom_confirm_widget.dart';
import 'package:frontend/services/api_client.dart';
import 'package:dio/dio.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  List pillsToRegister = [];

  List _registerList = [];
  setRegisterList(data, seq) {
    setState(() {
      _registerList.removeWhere((pill) => pill['item_seq'] == seq);
      _registerList.add(data);
    });
  }

  Future<void> pillRegister(data) async {
    try {
      Response response = await ApiClient.pillRegister(data);
      // handle response data
      showDialog(
        // 여기가 성공시 보여줄 다이얼로그
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('알약 등록 성공!'),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 이게 아마 다이얼로그를 끄는 거여야 할텐데...
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DrugHistoryPage()),
                  );
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // handle error
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 약 등록페이지 갔다 오는 navigator
    _navigateToMyPill(BuildContext context) async {
      final result = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => TextSearchPage()));
      pillsToRegister.add(result);
      // TODO: 어떻게 중복을 제거 할 수 있을까...
    }

    // 약 최종 등록 Dio 자리
    registerFinal() {
      pillRegister(_registerList);
    }

    return Scaffold(
      appBar: SimpleAppBar(title: '텍스트로 등록'),
      body: Stack(children: [
        Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.width * 0.1,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: Row(children: [
                          Icon(Icons.error_outline_outlined,
                              color: Theme.of(context).colorScheme.onSurface),
                          Text(
                            '+ 버튼을 눌러 약을 추가하세요',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          )
                        ]),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: () {
                      _navigateToMyPill(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * (0.8 / 3),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Icon(
                          Icons.add_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: pillsToRegister.length > 0
                  ? ListView.builder(
                      itemCount: pillsToRegister.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TextSearchPillToRgister(
                            data: pillsToRegister[index],
                            setRegisterList: setRegisterList);
                      })
                  : Container(
                      height: 0,
                      width: 0,
                    ),
            )
          ],
        ),
        pillsToRegister.length > 0
            ? Positioned(
                bottom: 0,
                child: BottomConfirmWidget(
                  isAlarm: false,
                  registerFinal: registerFinal,
                ),
              )
            : Container()
      ]),
    );
  }
}
