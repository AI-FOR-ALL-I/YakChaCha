import 'package:flutter/material.dart';
import 'package:frontend/widgets/text_search/text_search_pill_to_register.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/screens/search/text_search_page.dart';
import 'package:frontend/screens/drug_history_page.dart';
import 'package:frontend/widgets/common/bottom_confirm_widget.dart';
import 'package:frontend/services/api_search.dart';
import 'package:dio/dio.dart';
import 'package:frontend/controller/pill_register_controller.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void dispose() {
    super.dispose();
    final pillRegisterController = Get.find<PillRegisterController>();
    pillRegisterController.clear();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PillRegisterController());

    return Scaffold(
      appBar: SimpleAppBar(title: '텍스트로 등록'),
      body: GetBuilder<PillRegisterController>(builder: (controller) {
        return Stack(children: [
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TextSearchPage()));
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
              if (controller.displayList.isNotEmpty)
                Expanded(
                    child: ListView(children: [
                  ...controller.displayList
                      .map((pill) => TextSearchPillToRgister(data: pill))
                      .toList(),
                  SizedBox(height: 100)
                ]))
            ],
          ),
          if (controller.displayList.isNotEmpty)
            Positioned(
                child: BottomConfirmWidget(
                    isAlarm: false, confirm: controller.dioRequest),
                bottom: 0)
        ]);
      }),
    );
  }
}
