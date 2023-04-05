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
import 'dart:io';
import 'package:image/image.dart' as img;

class RegisterPage extends StatefulWidget {
  final bool isCameraOCR;
  final bool isAlbumOCR;
  // 수정
  const RegisterPage(
      {Key? key, required this.isCameraOCR, required this.isAlbumOCR})
      : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late PillRegisterController controller;
  Future ocrSearch(formData) async {
    try {
      var response = await ApiSearch.ocrSearch(formData);
      print(response);
      var response2 =
          await controller.ocrSearchFinal(response.data["edi_code"]);

      return response2;
    } catch (e) {
      print(e);
    }
  }

  // Future<File> compressImage(XFile file) async {
  //   final bytes = await file.readAsBytes();
  //   final image = img.decodeImage(bytes)!;
  //   final compressedImage = img.encodeJpg(image,
  //       quality: 70); // quality 값은 0 ~ 100 사이의 값으로 설정 가능합니다.
  //   if (compressedImage.length > 1000000) {
  //     // 1MB
  //     return compressImage(XFile.fromData(compressedImage));
  //   } else {
  //     print(compressedImage.length);
  //     return File(file.path).writeAsBytes(compressedImage);
  //   }
  // }

  Future<void> getCameraImage(camera) async {
    var image;
    if (camera) {
      // var temp =
      image =
          await ImagePicker().pickImage(source: ImageSource.camera); // XFile 타입
      // image = await compressImage(temp!);
    } else {
      // var temp =
      image = await ImagePicker()
          .pickImage(source: ImageSource.gallery); // XFile 타입
      // image = await compressImage(temp!);
    }

    if (image == null) {
      return;
    }
    // 여기서 로딩 시작?

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: Dialog(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Loading..."),
                      Image.asset("assets/images/walking.gif"),
                    ],
                  ),
                ),
              ));
        });
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        image.path,
        //  filename: 'image.jpg'
      ),
    });
    if (formData != null) {}

    var ocrResultList = await ocrSearch(formData);
    if (ocrResultList != null) {
      await controller.ocrToList(ocrResultList);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext constext) {
            return Dialog(
              child: SizedBox(
                  height: 200.0,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('처방전 인식에 실패했습니다.', style: TextStyle(fontSize: 20)),
                      Text('검색으로 등록해주세요', style: TextStyle(fontSize: 15))
                    ],
                  )),
            );
          });
    }
  }

  @override
  void initState() {
    super.initState();
    controller =
        getX.Get.put(PillRegisterController(), tag: "registerController");
    getX.Get.put(controller); // 수정
    if (widget.isCameraOCR) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => LoadingPage()),
        // ).then((value) {});
      });
      getCameraImage(true);
    } else if (widget.isAlbumOCR) {
      getCameraImage(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    print('!!!!!!!!!!!!!!!!!!${controller.displayList}');

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    // getX.Get.put(PillRegisterController());

    return Scaffold(
      appBar: SimpleAppBar(title: '약 등록'),
      body: getX.GetBuilder<PillRegisterController>(
          tag: "registerController",
          builder: (controller) {
            return Stack(children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
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
                                builder: (context) =>
                                    TextSearchPage(isRegister: true)));
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
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // if (controller.displayList.isNotEmpty)
                  Expanded(
                      child: getX.Obx(() => ListView(children: [
                            ...controller.displayList
                                .map((pill) =>
                                    TextSearchPillToRgister(data: pill))
                                .toList(),
                            SizedBox(height: 100)
                          ])))
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
