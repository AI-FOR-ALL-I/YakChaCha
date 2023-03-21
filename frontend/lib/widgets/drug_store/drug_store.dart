import 'package:flutter/material.dart';
import 'package:frontend/screens/drug_store_detail/drug_store_detail.dart';

class DrugStore extends StatelessWidget {
  const DrugStore({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (context) => DrugStoreDetail(
              
            ),
          )
        );
      },
      child: AspectRatio(
        aspectRatio: 3 / 1,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(1, 1), blurRadius: 2, color: Colors.black12)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Flexible(
                        flex: 5,
                        child: Text("라온 약국", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                      ),
                      Flexible(
                        flex: 5,
                        child: Text("서울특별시 강남구 역삼동"),
                      ),
                    ],
                  ),
                ),
              ),
              Icon(Icons.search_rounded)
            ],
          ),
        ),
      ),
    );
  }
}