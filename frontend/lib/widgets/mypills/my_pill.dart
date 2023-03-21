import 'package:flutter/material.dart';
import 'package:frontend/screens/pill_details/pill_details.dart';

class MyPill extends StatelessWidget {
  const MyPill({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (context) => PillDetails(
              
            ),
          )
        );
      },
      child: AspectRatio(
        aspectRatio: 3 / 1,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          padding: const EdgeInsets.all(15),
          // height: 100,
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
              Container(
                  clipBehavior: Clip.hardEdge,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Image.asset(
                    'assets/images/pills.png',
                  )),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        flex: 5,
                        child: Text("넬슨이부프로펜정"),
                      ),
                      Flexible(
                        flex: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
                                "태그명",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11),
                              ),
                            ),
                            const Text("D-3"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
