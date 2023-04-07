import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';

class CustomTimePicker extends StatefulWidget {
  const CustomTimePicker(
      {Key? key,
      required this.setTime,
      required this.time,
      required this.isCreate,
      this.originalTime})
      : super(key: key);
  final Function(DateTime) setTime;
  final DateTime time;
  final bool isCreate;
  final String? originalTime;
  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  DateTime _dateTime = DateTime.now();
  @override
  void initState() {
    super.initState();
    if (widget.originalTime != null) {
      String timeString = widget.originalTime!;
      DateFormat format = DateFormat("hh:mm:a");
      DateTime parsedTime = format.parse(timeString);
      _dateTime = parsedTime;
      print(_dateTime);
    } else {
      _dateTime = widget.time;
      print(_dateTime); // null 일 경우에는 현재 시간 사용
    }
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
