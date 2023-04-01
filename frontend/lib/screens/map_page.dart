// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:frontend/screens/drug_store_detail/drug_store_search.dart';
import 'package:frontend/screens/drug_store_detail/kakaomap_screen.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:geolocator/geolocator.dart';

const String kakaoMapKey = '7456c753f359ee3f7137fc8dd3adfaf8';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late double _lat = 37.5586545;
  late double _lng = 126.7944739;

  @override
  void initState() {
    super.initState();
    determinePosition();
  }

  determinePosition() async {
    final info = await Geolocator.getCurrentPosition();
    print("!!!!!!!!!!!!!!!@@@@@@@@@@@@@@@@@@@@");
    print(info.latitude);
    print(info.longitude);
    print("===========================");
    setState(() {
      _lat = info.latitude;
      _lng = info.longitude;
    });
  }

  String _inputText = '';
  final _focusNode = FocusNode();
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print(_lng);
    print("!@#@!#@!#!#!@#!#");
    print(_lat);
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          KakaoMapView(
              width: size.width,
              height: 400,
              kakaoMapKey: kakaoMapKey,
              lat: _lat,
              lng: _lng,
              showMapTypeControl: true,
              showZoomControl: true,
              zoomLevel: 6,
              markerImageURL:
                  'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
              onTapMarker: (message) async {
                await _openKakaoMapScreen(context);
              }),
          ElevatedButton(
              child: const Text('현 위치로 검색'),
              onPressed: () {
                determinePosition();
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width - 100,
                child: TextField(
                  focusNode: _focusNode,
                  controller: _textController,
                  maxLength: 10,
                  decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "ex) 역삼, 역삼역"),
                  onChanged: (text) {
                    _inputText = text;
                  },
                ),
              ),
              IconButton(
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
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openKakaoMapScreen(BuildContext context) async {
    KakaoMapUtil util = KakaoMapUtil();
    // String url = await util.getMapScreenURL(_lat, _lng, name: '현 위치');
    String url = await util.getMapScreenURL(_lat, _lng, name: '현 위치');
    print('urlurlurlurlurlurlurlurlurlurlurlurlurlurlurl: $url');
    print("@@@@@");
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => KakaoMapScreen(url: url)));
  }
}
