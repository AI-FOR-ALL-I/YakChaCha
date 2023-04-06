import 'package:flutter/material.dart';

class IsEmptyData extends StatelessWidget {
  final String what;
  const IsEmptyData({super.key, required this.what});

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
                height: 20,
              ),
              Text(
                "$what이 없습니다.",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
