import 'package:flutter/material.dart';
import 'package:frontend/widgets/text_search/text_search_pill_to_register.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/screens/search/text_search_page.dart';
import 'package:frontend/screens/drug_history_page.dart';
import 'package:frontend/widgets/common/bottom_confirm_widget.dart';
import 'package:frontend/services/api_search.dart';
import 'package:dio/dio.dart';
import 'package:frontend/controller/pill_register_controller.dart';
import 'package:get/get.dart' as getX;
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  final bool isCameraOCR;
  final bool isAlbumOCR;
  const RegisterPage(
      {Key? key, required this.isCameraOCR, required this.isAlbumOCR})
      : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Future ocrSearch(formData) async {
    try {
      var response = await ApiSearch.ocrSearch(formData);
      var controller = PillRegisterController();
      getX.Get.put(controller);
      var response2 =
          await controller.ocrSearchFinal(response.data["edi_code"]);

      return response2;
    } catch (e) {
      print(e);
    }
  }

  getCameraImage(camera) async {
    var image;
    if (camera) {
      image =
          await ImagePicker().pickImage(source: ImageSource.camera); // XFile 타입
    } else {
      image = await ImagePicker()
          .pickImage(source: ImageSource.gallery); // XFile 타입
    }
    if (image != null) {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          //  filename: 'image.jpg'
        ),
      });
      var controller = PillRegisterController();
      getX.Get.put(controller);
      var ocrResultList = await ocrSearch(formData);
      if (ocrResultList != null) {
        controller.ocrToList(ocrResultList);
      } else {
        showDialog(
            context: context,
            builder: (BuildContext constext) {
              return Dialog(
                child: SizedBox(
                    height: 200.0,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [Text('처방전 인식에 실패했습니다.'), Text('검색으로 등록해주세요')],
                    )),
              );
            });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isCameraOCR) {
      getCameraImage(true);
    } else if (widget.isAlbumOCR) {
      getCameraImage(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    final pillRegisterController = getX.Get.find<PillRegisterController>();
    pillRegisterController.clear();
  }

  @override
  Widget build(BuildContext context) {
    getX.Get.put(PillRegisterController());

    return Scaffold(
      appBar: SimpleAppBar(title: '텍스트로 등록'),
      body: getX.GetBuilder<PillRegisterController>(builder: (controller) {
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
                  isAlarm: false,
                  confirm: controller.dioRequest,
                  isAlarmMyPill: false,
                ),
                bottom: 0)
        ]);
      }),
    );
  }
}
