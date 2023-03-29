import 'package:flutter/material.dart';
import 'package:frontend/services/api_search.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class TextSearchBar extends StatefulWidget {
  TextSearchBar({Key? key, this.getResultList, this.toggleIsCameraClicked})
      : super(key: key);
  final Function(List<dynamic>)? getResultList;
  final Function()? toggleIsCameraClicked;

  @override
  State<TextSearchBar> createState() => _TextSearchBarState();
}

class _TextSearchBarState extends State<TextSearchBar> {
  final inputData = TextEditingController();

  Future<void> searchText(word) async {
    try {
      Response response = await ApiSearch.textSearch(word);
      // print(response.data);
      var result = jsonDecode(response.toString());
      var dataList = result['data'];
      setState(() {
        widget.getResultList?.call(dataList); // 이렇게 호출하기!!!
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(iconTheme: IconThemeData(color: Colors.grey)),
      child: Container(
        margin: EdgeInsets.all(20),
        child: TextField(
          controller: inputData,
          onChanged: (string) {},
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.background),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.background),
              ),
              suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                    onPressed: () {
                      if (widget.toggleIsCameraClicked != null) {
                        widget.toggleIsCameraClicked!();
                      }
                      ;
                    },
                    icon: Icon(Icons.photo_camera_outlined)),
                IconButton(
                    onPressed: () {
                      searchText(inputData.text);
                    },
                    icon: Icon(Icons.search_outlined)),
              ])),
        ),
      ),
    );
  }
}
