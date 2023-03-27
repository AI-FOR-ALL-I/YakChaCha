import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class CustomTimePicker extends StatefulWidget {
  const CustomTimePicker({Key? key, required this.setTime, required this.time})
      : super(key: key);
  final Function(DateTime) setTime;
  final DateTime time;
  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  DateTime _dateTime = DateTime.now();
  @override
  void initState() {
    super.initState();
    _dateTime = widget.time;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        elevation: 5.0,
        child: TimePickerSpinner(
          time: _dateTime,
          minutesInterval: 10,
          is24HourMode: false,
          onTimeChange: (time) {
            widget.setTime(time);
          },
          normalTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
          highlightedTextStyle: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
          spacing: 50,
          itemHeight: 80,
          isForce2Digits: true,
        ),
      ),
    );
  }
}
