import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

class PillDetailLineMethod extends StatefulWidget {
  final String lineTitle, content;

  const PillDetailLineMethod({
    Key? key,
    required this.lineTitle,
    required this.content,
  }) : super(key: key);

  @override
  State<PillDetailLineMethod> createState() => PillDetailLineMethodState();
}

class PillDetailLineMethodState extends State<PillDetailLineMethod> {
  late bool triClicked;
  late List<String> dataList;

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
          dataList.add(ele);
        }
      }
    }
    if (dataList.isEmpty) {
      var elements = document.findAllElements('ARTICLE');
      for (var element in elements) {
        final document = XmlDocument.parse(element.toString());
        final titleAttribute = document.rootElement.getAttribute('title');
        dataList.add(titleAttribute.toString());
      }
    }
    return dataList;
  }

  void onClickTri() {
    setState(() {
      triClicked = !triClicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: const BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.lineTitle,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              IconButton(
                onPressed: onClickTri,
                icon: Icon(
                    triClicked ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              ),
            ],
          ),
          triClicked
              ? Container(
                  width: size.width - 50,
                  margin: const EdgeInsets.only(bottom: 5),
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return Text(dataList[index].trim());
                    },
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
