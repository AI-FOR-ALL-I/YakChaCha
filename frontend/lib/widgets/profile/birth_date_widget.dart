import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BirthDateWidget extends StatefulWidget {
  final Function(String) onBirthDateSelected;
  const BirthDateWidget({super.key, required this.onBirthDateSelected});

  @override
  _BirthDateWidgetState createState() => _BirthDateWidgetState();
}

class _BirthDateWidgetState extends State<BirthDateWidget> {
  String? _birthDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        _birthDate = formattedDate;
      });
      widget.onBirthDateSelected(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: const Text('생년월일 선택'),
        ),
        if (_birthDate != null)
          Padding(
            padding: const EdgeInsets.only(
                top: 8.0, left: 10.0, right: 5.0, bottom: 8.0),
            child: Text(_birthDate!),
          ),
      ],
    );
  }
}
