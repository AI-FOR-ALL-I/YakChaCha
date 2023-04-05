import 'package:flutter/material.dart';

class IsEmptyPills extends StatelessWidget {
  final String what;
  const IsEmptyPills({super.key, required this.what});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var content = "복용한 내역";

    if (what == "알람") {
      content = "등록한 알람";
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(
              //   Icons.medication,
              //   size: 58,
              // ),
              ClipOval(
                child: Image.asset(
                  "assets/images/profile4.png",
                  height: size.width / 3.5,
                  width: size.width / 3.5,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "$content이 없습니다.",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "아래 ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF848293),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  what == "알람"
                      ? const Icon(
                          Icons.add_circle,
                          color: Color(0xFFBBE4CB),
                        )
                      : const Icon(Icons.add_box_outlined),
                  const Text(
                    "를 눌러 약을 등록해주세요",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF848293),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
