import 'package:flutter/material.dart';
import 'package:frontend/widgets/text_search/text_search_pill.dart';
import 'package:frontend/widgets/text_search/text_search_bar.dart';

class TextSearchPage extends StatelessWidget {
  const TextSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_outlined)),
          title: Center(child: Text('검색 - 텍스트')),
        ),
        body: Column(
          children: [
            TextSearchBar(),
            Container(
              child: Text('${0} 건의 검색결과'),
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(left: 20),
            ),
            Flexible(
              child: GridView.builder(
                itemCount: 10,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return TextSearchPillComponent();
                },
              ),
            ),
          ],
        ));
  }
}
