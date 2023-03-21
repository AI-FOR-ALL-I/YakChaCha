import 'dart:html';

import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/search_input.dart';
import 'package:frontend/widgets/drug_store/drug_store.dart';

class DrugStoreSearch extends StatelessWidget {
  const DrugStoreSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("약국 찾기"), centerTitle: true),
      body: ListView(
        children: [SearchInput(hintText: "hintText", onChanged: (p1) {}),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.my_location_rounded),
                Text("내 위치 중심")
              ],
            ),
            Icon(Icons.arrow_right)
          ],
        ),
        DrugStore(),
        ],
      ),
    );
  }
}
