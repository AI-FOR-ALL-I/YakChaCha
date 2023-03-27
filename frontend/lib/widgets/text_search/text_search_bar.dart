import 'package:flutter/material.dart';
import 'package:frontend/services/api_client.dart';
import 'package:dio/dio.dart';

class TextSearchBar extends StatelessWidget {
  TextSearchBar({Key? key, this.searchResult, this.toggleIsCameraClicked})
      : super(key: key);
  final searchResult;
  final inputData = TextEditingController();
  final Function()? toggleIsCameraClicked;

  Future<void> searchText(word) async {
    try {
      Response response = await ApiClient.textSearch(word);
      print(response);
      print('1 try');
    } catch (e) {
      print('여기가 에러메세지!');
      print(e);
      print('2 catch');
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
          onChanged: (string) {
            print(inputData.text);
            searchText(inputData.text);
          },
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
                      if (toggleIsCameraClicked != null) {
                        toggleIsCameraClicked!();
                      }
                      ;
                    },
                    icon: Icon(Icons.photo_camera_outlined)),
                IconButton(onPressed: () {}, icon: Icon(Icons.search_outlined)),
              ])),
        ),
      ),
    );
  }
}
