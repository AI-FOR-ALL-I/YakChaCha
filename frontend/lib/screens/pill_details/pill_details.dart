import 'package:flutter/material.dart';

class PillDetails extends StatelessWidget {

  const PillDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("약 상세"),),
      body: ListView(
        children: [
          Image.asset('assets/images/pills.png',),
          Column(children: [Text("텍스트 큰거"), Text("텍스트 작은거")]),
          Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("텍스트"),
                Icon(Icons.arrow_drop_down_outlined),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("텍스트"),
                Icon(Icons.arrow_drop_down_outlined),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("텍스트"),
                Icon(Icons.arrow_drop_down_outlined),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("텍스트"),
                Icon(Icons.arrow_drop_down_outlined),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("텍스트"),
                Icon(Icons.arrow_drop_down_outlined),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("텍스트"),
                Icon(Icons.arrow_drop_down_outlined),
              ],
            ),
          ],)
        ],
      ),
    );
  }
}