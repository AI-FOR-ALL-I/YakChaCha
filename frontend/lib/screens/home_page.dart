import 'package:flutter/material.dart';
import 'package:frontend/widgets/main/eat_check_button.dart';
import 'package:frontend/widgets/main/time_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: const [TimeHeader(timeline: 0), EatCheckButton()],
        ),
      ),
    );
  }
}
