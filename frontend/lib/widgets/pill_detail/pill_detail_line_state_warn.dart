// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:xml/xml.dart';

class PillDetailLineWarn extends StatefulWidget {
  final String lineTitle, content;
  const PillDetailLineWarn({
    super.key,
    required this.lineTitle,
    required this.content,
  });

  @override
  State<PillDetailLineWarn> createState() => PillDetailLineWarnState();
}

class PillDetailLineWarnState extends State<PillDetailLineWarn> {
  late bool triClicked;
  late List<String> dataList;

  void onClickTri() {
    setState(() {
      triClicked = !triClicked;
    });
  }

  @override
  void initState() {
    super.initState();
    triClicked = false;
    dataList = _parseXmlData(widget.content);
  }

  List<String> _parseXmlData(String xmlString) {
    var document = XmlDocument.parse(xmlString);
    var elements = document.findAllElements('SECTION');
    List<String> dataList = [];
    for (var element in elements) {
      for (var ele in element.text.split("\n")) {
        if (ele.trim() != "" && ele.trim() != "&nbsp;") {
          dataList.add(ele.trim().replaceAll(RegExp(r'^&nbsp;|&nbsp;$'), ''));
        }
      }
    }
    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                  margin: const EdgeInsets.only(bottom: 5),
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: size.width - 50,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        return Text(dataList[index].trim());
                      },
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
