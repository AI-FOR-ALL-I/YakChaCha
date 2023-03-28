import 'package:flutter/material.dart';
import 'package:frontend/widgets/text_search/text_search_pill_to_register.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/screens/search/text_search_page.dart';
import 'package:frontend/widgets/common/bottom_confirm_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  List pillsToRegister = [];

  // TODO: 리스트를 만들고, 각 위젯에 내려줄 set 함수 만들기 + itemSeq를 기준으로 추가하고 수정하기

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
      print(pillsToRegister);
    }

    return Scaffold(
      appBar: SimpleAppBar(title: '텍스트로 등록'),
      body: Stack(children: [
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
            Expanded(
              child: pillsToRegister.length > 0
                  ? ListView.builder(
                      itemCount: pillsToRegister.length,
                      itemBuilder: (context, index) {
                        return TextSearchPillToRgister(
                            data: pillsToRegister[index]);
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
