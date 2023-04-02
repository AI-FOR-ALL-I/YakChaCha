import 'package:flutter/material.dart';
import 'package:frontend/screens/drug_store_detail/drug_store_detail.dart';
import 'package:frontend/services/api_drug_store_keyword.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';

class DrugStoreSearch extends StatelessWidget {
  final String keyword;
  const DrugStoreSearch({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    final Future drugstores = ApiDrugStoreKeyword.getDrugStore(keyword);

    return Scaffold(
        appBar: SimpleAppBar(title: "약국 찾기: $keyword"),
        body: FutureBuilder(
            future: drugstores,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return drugStoreList(snapshot, context);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  Column drugStoreList(AsyncSnapshot snapshot, context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
            child: Text(
              "총 ${snapshot.data!.length} 건의 검색결과가 있습니다.",
              style: const TextStyle(fontSize: 20),
            )),
        Expanded(
          child: ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemBuilder: (context, index) {
              var drugstores = snapshot.data![index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black12)
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          drugstores["yadmNm"]["\$t"],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(
                          width: size.width - 150,
                          child: Text(
                            drugstores["addr"]["\$t"],
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DrugStoreDetail(
                                  addr: drugstores["addr"]["\$t"],
                                  telno: drugstores["telno"]["\$t"],
                                  here: drugstores["yadmNm"]["\$t"],
                                  lngBig:
                                      double.parse(drugstores["XPos"]["\$t"]),
                                  latSmall:
                                      double.parse(drugstores["YPos"]["\$t"]),
                                ),
                              ));
                        },
                        icon: const Icon(Icons.search_rounded)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
