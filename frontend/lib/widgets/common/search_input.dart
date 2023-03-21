import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final String hintText;
  final Function(String?) onChanged;

  const SearchInput(
      {
        super.key,
        required this.hintText,
        required this.onChanged,
      }
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}
