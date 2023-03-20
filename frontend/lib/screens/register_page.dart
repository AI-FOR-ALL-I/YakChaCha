import 'package:flutter/material.dart';
import 'package:frontend/widgets/text_search/text_search_pill_to_register.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, i) {
        return TextSearchPillToRgister();
      },
    );
  }
}
