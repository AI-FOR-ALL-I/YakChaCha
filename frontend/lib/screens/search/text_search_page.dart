import 'package:flutter/material.dart';
import 'package:frontend/widgets/text_search/text_search_pill.dart';
import 'package:frontend/widgets/text_search/text_search_bar.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/screens/pill_details/pill_details_for_api.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontend/services/api_search.dart';
import 'package:frontend/controller/pill_register_controller.dart';
import 'package:get/get.dart' as getX;

class TextSearchPage extends StatefulWidget {
  const TextSearchPage({super.key});

  @override
  State<TextSearchPage> createState() => _TextSearchPageState();
}

class _TextSearchPageState extends State<TextSearchPage> {
  // 검색 결과

  var searchResult = [];
  var aiResultList = [];

  // 이미지 전송 dio
  Future imgSearch(formData) async {
    try {
      var response = await ApiSearch.imgSearch(formData);

      var controller = PillRegisterController();
      getX.Get.put(controller);
      var response2 =
          await controller.imgSearchFinal(response.data["item_seq"]);

      await toggleIsCameraClicked();
      setState(() {
        aiResultList = response2;
      });
    } catch (e) {
      print(e);
    }
  }

  // 검색 결과 저장하는 셋 함수
  getResultList(result) {
    setState(() {
      aiResultList = [];
    });
    setState(() {
      searchResult = result;
    });
  }

  // 카메라 / 앨범 오버레이 띄우기 용 변수
  bool isCameraClicked = false;

  // isCamerClicked 변경 용 셋 함수
  toggleIsCameraClicked() {
    showDialog(
        context: context,
        builder: (BuildContext constext) {
          return Dialog(
            child: SizedBox(
                height: 200.0,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          getCameraImage(true);
                        },
                        child: Text('사진 촬영')),
                    GestureDetector(
                        onTap: () {
                          getCameraImage(false);
                        },
                        child: Text('앨범에서 선택'))
                  ],
                )),
          );
        });
  }

  // 이미지 가져오기 카메라 / 갤러리
  // XFile? _image; // 얘가 이미지 담는 State
  //TODO: 이미지 형식 제한은, 직접 이미지 파일 형식을 확인해서 분기처리 해야함

  // true면 카메라, false면 앨범
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
      imgSearch(formData);
      setState(() {
        searchResult = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: '검색 - 텍스트'),
      body: Column(
        children: [
          TextSearchBar(
              getResultList: getResultList,
              toggleIsCameraClicked: toggleIsCameraClicked),
          // 여기는 Text 검색 결과
          searchResult.length > 0
              ? Expanded(
                  child: Column(
                    children: [
                      Container(
                        child: Text('${searchResult.length} 건의 검색결과'),
                        alignment: Alignment.bottomLeft,
                        margin: EdgeInsets.only(left: 20),
                      ),
                      Flexible(
                        child: GridView.builder(
                          // 여기가 Text로 검색
                          itemCount: searchResult.length,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () {
                                  // Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PillDetailsForApi(
                                              turnOnPlus: true,
                                              num: searchResult[index]
                                                      ['itemSeq']
                                                  .toString()))); //TODO:  상세페이지에서  pop 2번으로 나가게 하기 가능, 대신 데이터를 가지고 나올 수 있도록 하기
                                },
                                child: TextSearchPillComponent(
                                    data: searchResult[index]));
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          // 여기부터는 사진 검색
          aiResultList.length > 0
              ? Expanded(
                  child: Column(
                    children: [
                      Text("알약 사진 분석 결과"),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextSearchPillComponent(data: aiResultList[0]),
                          ],
                        ),
                      ),
                      Text("혹시 이 약들 중에 있나요?"),
                      Flexible(
                        child: GridView.builder(
                          // 여기가 Text로 검색
                          itemCount: 4,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () {
                                  // Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PillDetailsForApi(
                                              turnOnPlus: true,
                                              num: aiResultList[index + 1]
                                                      ['itemSeq']
                                                  .toString()))); //TODO:  상세페이지에서  pop 2번으로 나가게 하기 가능, 대신 데이터를 가지고 나올 수 있도록 하기
                                },
                                child: TextSearchPillComponent(
                                    data: aiResultList[index + 1]));
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
