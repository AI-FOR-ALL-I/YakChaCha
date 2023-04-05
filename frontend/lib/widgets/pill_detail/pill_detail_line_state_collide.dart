// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class PillDetailLineCollide extends StatefulWidget {
  final String lineTitle;
  final List content;
  const PillDetailLineCollide({
    super.key,
    required this.lineTitle,
    required this.content,
  });

  @override
  State<PillDetailLineCollide> createState() => PillDetailLineCollideState();
}

class PillDetailLineCollideState extends State<PillDetailLineCollide> {
  bool triClicked = false;

  void onClickTri() {
    setState(() {
      triClicked = !triClicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
          border: BorderDirectional(
              bottom: BorderSide(
        color: Colors.black,
      ))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                textAlign: TextAlign.left,
                widget.lineTitle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              IconButton(
                  onPressed: onClickTri,
                  icon: !triClicked
                      ? Icon(Icons.arrow_drop_down)
                      : Icon(Icons.arrow_drop_up)),
            ],
          ),
          triClicked
              ? Container(
                  margin: EdgeInsets.only(bottom: 5),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: List.generate(widget.content.length, (index) {
                      return Text(widget.content[index]);
                    }),
                  ))
              : SizedBox()
        ],
      ),
    );
  }
}
