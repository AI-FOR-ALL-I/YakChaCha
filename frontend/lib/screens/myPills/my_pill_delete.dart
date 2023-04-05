import 'package:flutter/material.dart';
import 'package:frontend/controller/my_pill_controller.dart';
import 'package:frontend/models/delete_my_pill_model.dart';
import 'package:frontend/services/api_all_my_pill.dart';
import 'package:frontend/widgets/common/is_empty_pills.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/widgets/mypills/delete_my_pill.dart';
import 'package:get/get.dart';

class MyPillDelete extends StatefulWidget {
  const MyPillDelete({super.key});
  @override
  State<MyPillDelete> createState() => _MyPillDeleteState();
}

class _MyPillDeleteState extends State<MyPillDelete> {
  final Future<List<DeleteMyPillModel>> myPills = ApiAllMyPill.getMyAllPill();
  var isFlag = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(title: "약 삭제하기"),
      body: FutureBuilder(
        future: myPills,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return myPillList(snapshot);
          } else {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget myPillList(AsyncSnapshot<List<DeleteMyPillModel>> snapshot) {
    var isZero = false;
    if (snapshot.data!.isEmpty) {
      isZero = true;
    }
    return isZero
        ? const IsEmptyPills(what: "알약",)
        : Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) => const SizedBox(),
                  itemBuilder: (context, index) {
                    var pill = snapshot.data![index];
                    return DeleteMyPill(
                      myMedicineSeq: pill.myMedicineSeq,
                      itemSeq: pill.itemSeq,
                      itemName: pill.itemName,
                      img: pill.img,
                      tag_list: pill.tagList,
                    );
                  },
                ),
              ),
            ],
          );
  }
}
