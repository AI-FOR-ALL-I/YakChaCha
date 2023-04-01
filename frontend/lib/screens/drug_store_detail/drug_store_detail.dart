// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:frontend/screens/drug_store_detail/kakaomap_screen.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';

const String kakaoMapKey = '7456c753f359ee3f7137fc8dd3adfaf8';

class DrugStoreDetail extends StatelessWidget {
  final double latSmall, lngBig;
  const DrugStoreDetail({
    super.key,
    required this.latSmall,
    required this.lngBig,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const SimpleAppBar(title: "약국 상세"),
      body: Column(
        children: [
          KakaoMapView(
              width: size.width,
              height: 400,
              kakaoMapKey: kakaoMapKey,
              lat: latSmall,
              lng: lngBig,
              showMapTypeControl: true,
              showZoomControl: true,
              zoomLevel: 6,
              markerImageURL:
                  'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
              onTapMarker: (message) async {
                await _openKakaoMapScreen(context);
              }),
        ],
      ),
    );
  }

  Future<void> _openKakaoMapScreen(BuildContext context) async {
    KakaoMapUtil util = KakaoMapUtil();
    String url = await util.getMapScreenURL(latSmall, lngBig, name: '약국');
    print('urlurlurlurlurlurlurlurlurlurlurlurlurlurlurl: $url');
    print("@@@@@");
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => KakaoMapScreen(url: url)));
  }
}
