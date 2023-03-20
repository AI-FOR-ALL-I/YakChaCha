import 'package:flutter/material.dart';

class MyPill extends StatelessWidget {
  const MyPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: double.infinity,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.amber),
        child: Text("테스트"),
      ),
    );
  }
}