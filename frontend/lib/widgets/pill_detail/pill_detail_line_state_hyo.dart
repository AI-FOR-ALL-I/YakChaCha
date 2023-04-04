// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:xml2json/xml2json.dart';

class PillDetailLineHyo extends StatefulWidget {
  final String lineTitle, content;
  const PillDetailLineHyo({
    super.key,
    required this.lineTitle,
    required this.content,
  });

  @override
  State<PillDetailLineHyo> createState() => PillDetailLineHyoState();
}

class PillDetailLineHyoState extends State<PillDetailLineHyo> {
  bool triClicked = false;
  List<Map<String, dynamic>>? _parsedContent;

  void onClickTri() {
    setState(() {
      triClicked = !triClicked;
    });
  }

  Future<void> _parseContent() async {
    final xml2json = Xml2Json();
    xml2json.parse(widget.content);
    final jsonString = xml2json.toGData();
    final jsonData = jsonDecode(jsonString);
    setState(() {
      if (jsonData['DOC']['SECTION'] is List) {
        if (jsonData['DOC']['SECTION'][0]['ARTICLE'] is List) {
          _parsedContent = List<Map<String, dynamic>>.from(
              jsonData['DOC']['SECTION'][0]['ARTICLE']
                  .map((item) => {
                        'title': item['title'],
                        'PARAGRAPH': item['PARAGRAPH'],
                      })
                  .toList());
        } else {
          if (jsonData['DOC']['SECTION'][0]['ARTICLE']["PARAGRAPH"] is List) {
            _parsedContent = List<Map<String, dynamic>>.from(
                jsonData['DOC']['SECTION'][0]['ARTICLE']["PARAGRAPH"]
                    .map((item) => {
                          'title': item['title'],
                          'PARAGRAPH': {"__cdata": item["__cdata"]},
                        })
                    .toList());
          } else {
            _parsedContent = [
              {
                "title": jsonData['DOC']['SECTION'][0]['ARTICLE']["title"],
                "PARAGRAPH": {
                  "__cdata": jsonData['DOC']['SECTION'][0]['ARTICLE']
                      ["PARAGRAPH"]["__cdata"]
                }
              }
            ];
          }
        }
      } else {
        if (jsonData['DOC']['SECTION']['ARTICLE'] is List) {
          _parsedContent = List<Map<String, dynamic>>.from(
              jsonData['DOC']['SECTION']['ARTICLE']
                  .map((item) => {
                        'title': item['title'],
                        'PARAGRAPH': item['PARAGRAPH'],
                      })
                  .toList());
        } else {
          if (jsonData['DOC']['SECTION']['ARTICLE']["PARAGRAPH"] is List) {
            _parsedContent = List<Map<String, dynamic>>.from(
                jsonData['DOC']['SECTION']['ARTICLE']["PARAGRAPH"]
                    .map((item) => {
                          'title': item['title'],
                          'PARAGRAPH': {"__cdata": item["__cdata"]},
                        })
                    .toList());
          } else {
            _parsedContent = [
              {
                "title": jsonData['DOC']['SECTION']['ARTICLE']["title"],
                "PARAGRAPH": {
                  "__cdata": jsonData['DOC']['SECTION']['ARTICLE']["PARAGRAPH"]
                      ["__cdata"]
                }
              }
            ];
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _parseContent();
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
                
                  margin: EdgeInsets.only(bottom: 5),
                  alignment: Alignment.centerLeft,
                  child: _parsedContent != null
                      ? SizedBox(
                          width: size.width - 50,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _parsedContent?.length,
                            itemBuilder: (context, index) {
                              final item = _parsedContent![index];
                              var para = item['PARAGRAPH'];
                              var cData = '';
                              if (para is List) {
                                cData = para[0]?['__cdata'] ?? '';
                              } else {
                                cData = para?['__cdata'] ?? '';
                              }
                              if (cData == '&nbsp;') {
                                cData = '';
                              }

                              var title = item['title'] ?? "";
                              if (cData != '' && title != "") {
                                title += ':';
                              }
                              return Text("$title $cData");
                            },
                          ),
                        )
                      : FutureBuilder(
                          future: _parseContent(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            } else {
                              return SizedBox(
                                width: size.width - 50,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _parsedContent!.length,
                                  itemBuilder: (context, index) {
                                    final item = _parsedContent![index];
                                    return Text(
                                        "${item['title']}: ${item['PARAGRAPH']['__cdata']}");
                                  },
                                ),
                              );
                            }
                          },
                        ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
