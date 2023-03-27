import 'package:flutter/material.dart';
import 'package:frontend/widgets/text_search/text_search_pill.dart';
import 'package:frontend/widgets/text_search/text_search_bar.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TextSearchPage extends StatefulWidget {
  const TextSearchPage({super.key});

  @override
  State<TextSearchPage> createState() => _TextSearchPageState();
}

class _TextSearchPageState extends State<TextSearchPage> {
  // 검색 결과
  var searchResult = [];

  // 검색 결과 저장하는 셋 함수
  getResultList(result) {
    setState(() {
      searchResult = result;
    });
  }

  // 카메라 / 앨범 오버레이 띄우기 용 변수
  bool isCameraClicked = false;

  // isCamerClicked 변경 용 셋 함수
  toggleIsCameraClicked() {
    setState(() {
      isCameraClicked = !isCameraClicked;
    });

    print('${isCameraClicked}');
  }

  // 이미지 가져오기 카메라 / 갤러리
  XFile? _image; // 얘가 이미지 담는 State
  //TODO: 이미지 형식 제한은, 직접 이미지 파일 형식을 확인해서 분기처리 해야함
  getGalleryImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null)
      () {
        setState(() {
          _image = image;
        });
      };
  }

  getCameraImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null)
      () {
        setState(() {
          _image = image;
        });
      };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: SimpleAppBar(title: '검색 - 텍스트'),
          body: Column(
            children: [
              TextSearchBar(
                  getResultList: getResultList,
                  toggleIsCameraClicked: toggleIsCameraClicked),
              Container(
                child: Text('${searchResult.length} 건의 검색결과'),
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 20),
              ),
              Flexible(
                child: GridView.builder(
                  itemCount: searchResult.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
                    return TextSearchPillComponent(data: searchResult[index]);
                  },
                ),
              ),
            ],
          ),
        ),
        isCameraClicked
            ? Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    toggleIsCameraClicked();
                  },
                  child: Stack(children: [
                    Container(color: Colors.black.withOpacity(0.5)),
                    Positioned(
                      bottom: 20,
                      child: Container(
                        color: Colors.grey,
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width,
                        child: Column(children: [
                          GestureDetector(
                            onTap: () {
                              getCameraImage();
                            },
                            child: Container(
                                child: Text('카메라',
                                    style: TextStyle(color: Colors.white))),
                          ),
                          GestureDetector(
                            onTap: () {
                              getGalleryImage();
                            },
                            child: Container(
                                child: Text('앨범',
                                    style: TextStyle(color: Colors.white))),
                          ),
                        ]),
                      ),
                    )
                  ]),
                ),
              )
            : Container()
      ],
    );
  }
}
