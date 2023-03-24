import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class CustomTimePicker extends StatefulWidget {
  const CustomTimePicker({Key? key}) : super(key: key);

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  DateTime _dateTime = DateTime.now(); // TODO: 이거 나중에 하나 위로 올려서 Props 받기

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        elevation: 5.0,
        child: TimePickerSpinner(
          minutesInterval: 10,
          is24HourMode: false,
          onTimeChange: (time) {
            setState(() {
              _dateTime = time;
              // TODO: 바꾸는 함수도 하나 올려서 Props 받기
            });
            print('${_dateTime.hour}:${_dateTime.minute}'); // 이 형식으로 보내세요!!
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
