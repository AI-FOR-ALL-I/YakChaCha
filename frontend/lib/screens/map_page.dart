import 'package:flutter/material.dart';
import 'package:frontend/screens/drug_store_detail/drug_store_search.dart';
import 'package:frontend/widgets/common/search_input.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SearchInput(
            hintText: "힌트",
            onChanged: (p1) {},
          ),
        ),
        Image.asset(
          'assets/images/mapdummy.png',
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DrugStoreSearch(),
                ));
          },
          icon: Icon(Icons.ac_unit)
        ),
      ],
    );
  }
}
