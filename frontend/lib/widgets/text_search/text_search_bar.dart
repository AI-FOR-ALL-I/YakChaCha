import 'package:flutter/material.dart';

class TextSearchBar extends StatelessWidget {
  TextSearchBar({Key? key}) : super(key: key);
  final inputData = TextEditingController();

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
                    onPressed: () {}, icon: Icon(Icons.photo_camera_outlined)),
                IconButton(onPressed: () {}, icon: Icon(Icons.search_outlined)),
              ])),
        ),
      ),
    );
  }
}
