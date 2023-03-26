import 'package:flutter/material.dart';
import 'package:frontend/widgets/text_search/text_search_pill.dart';
import 'package:frontend/widgets/text_search/text_search_bar.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';

class TextSearchPage extends StatefulWidget {
  const TextSearchPage({super.key});

  @override
  State<TextSearchPage> createState() => _TextSearchPageState();
}

class _TextSearchPageState extends State<TextSearchPage> {
  var searchResult = [];
  getResultList(result) {
    setState() {
      searchResult = result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(title: '검색 - 텍스트'),
        body: Column(
          children: [
            TextSearchBar(searchResult: searchResult),
            Container(
              child: Text('${searchResult.length} 건의 검색결과'),
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
