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
              child: const Text('현 위치로'),
              onPressed: () {
                determinePosition();
              }),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      // builder: (context) => MapTestAPP(),
                      builder: (context) => DrugStoreSearch(),
                    ));
              },
              icon: const Icon(Icons.ac_unit)),
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
