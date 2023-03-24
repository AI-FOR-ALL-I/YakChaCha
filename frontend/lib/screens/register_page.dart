import 'package:flutter/material.dart';
import 'package:frontend/widgets/text_search/text_search_pill_to_register.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          // 여기가 회색박스
          aspectRatio: 323 / 47,
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFE1E1E1)),
            child: Row(children: [
              Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Icon(
                    Icons.error_outline_outlined,
                    color: Color(0xFF848293),
                  )),
              Text('복용기간과 태그를 설정해주세요',
                  style: TextStyle(color: Color(0xFF848293)))
            ]),
          ),
        ),
        AspectRatio(
            aspectRatio: 296 / 101,
            child: Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFBBE4CB)),
                child: Icon(Icons.add, color: Colors.white))),
        Expanded(
          child: ListView.builder(
            itemCount: 15,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return TextSearchPillToRgister();
            },
          ),
        )
      ],
    );
  }
}
