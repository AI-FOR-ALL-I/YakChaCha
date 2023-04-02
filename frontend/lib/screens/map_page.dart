// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:frontend/screens/drug_store_detail/drug_store_detail.dart';
import 'package:frontend/screens/drug_store_detail/drug_store_search.dart';
import 'package:frontend/screens/drug_store_detail/kakaomap_screen.dart';
import 'package:frontend/services/api_drug_store_pos.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';

const String kakaoMapKey = '7456c753f359ee3f7137fc8dd3adfaf8';

class MapPage extends StatefulWidget {
  final double latSmall, lngBig;
  const MapPage({super.key, required this.latSmall, required this.lngBig});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String _inputText = '';
  final _focusNode = FocusNode();
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final nowAround = ApiDrugStorePos.getDrugStorePos(
        {"xBig": widget.lngBig, "ySmall": widget.latSmall});
    Size size = MediaQuery.of(context).size;
    print("!@#!@#!@#!@#!@#");
    print(widget.latSmall);
    print(widget.lngBig);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            width: size.width - 15,
            child: TextField(
              cursorWidth: 3.0,
              cursorHeight: 10,
              focusNode: _focusNode,
              controller: _textController,
              maxLength: 10,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintStyle: const TextStyle(color: Colors.grey),
                hintText: "ex) 역삼, 역삼역",
                counterText: '',
                suffixIcon: IconButton(
                    onPressed: () {
                      if (_inputText != "") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DrugStoreSearch(keyword: _inputText),
                            ));
                      } else {
                        _focusNode.requestFocus();
                      }
                    },
                    icon: const Icon(Icons.search)),
              ),
              onChanged: (text) {
                _inputText = text;
              },
            ),
          ),
          FutureBuilder(
              future: nowAround,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return drugStoreList(snapshot, context);
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }

  SizedBox drugStoreList(AsyncSnapshot snapshot, context) {
    Size size = MediaQuery.of(context).size;
    var positionX = {};
    var positionY = {};
    for (var i = 0; i < snapshot.data!.length; i++) {
      var listData = snapshot.data![i];
      positionX[i.toString()] = listData["XPos"]["\$t"];
      positionY[i.toString()] = listData["YPos"]["\$t"];
    }
    return SizedBox(
      height: size.height - 200,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 7),
            child: KakaoMapView(
                customScript: '''
                var markers = [];
                
                function addMarker(position) {
                
                  var marker = new kakao.maps.Marker({position: position});
                
                  marker.setMap(map);
                
                  markers.push(marker);
                }
                
                for(var i = 0 ; i < ${positionX.length} ; i++){
                  addMarker(new kakao.maps.LatLng($positionY[i], $positionX[i]));
                }
                ''',
                width: size.width,
                height: size.width,
                kakaoMapKey: kakaoMapKey,
                lat: widget.latSmall,
                lng: widget.lngBig,
                showMapTypeControl: true,
                showZoomControl: true,
                zoomLevel: 6,
                markerImageURL:
                    'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
                onTapMarker: (message) async {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message.message)));
                  await _openKakaoMapScreen(context);
                }),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
              itemBuilder: (context, index) {
                var drugstores = snapshot.data![index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.black12)
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            drugstores["yadmNm"]["\$t"],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(
                            width: size.width - 150,
                            child: Text(
                              drugstores["addr"]["\$t"],
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DrugStoreDetail(
                                    addr: drugstores["addr"]["\$t"],
                                    telno: drugstores["telno"]["\$t"],
                                    here: drugstores["yadmNm"]["\$t"],
                                    lngBig:
                                        double.parse(drugstores["XPos"]["\$t"]),
                                    latSmall:
                                        double.parse(drugstores["YPos"]["\$t"]),
                                  ),
                                ));
                          },
                          icon: const Icon(Icons.search_rounded)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openKakaoMapScreen(BuildContext context) async {
    KakaoMapUtil util = KakaoMapUtil();
    String url = await util.getMapScreenURL(widget.latSmall, widget.lngBig,
        name: '현 위치');
    print('urlurlurlurlurlurlurlurlurlurlurlurlurlurlurl: $url');
    print("@@@@@");
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => KakaoMapScreen(url: url)));
  }
}
