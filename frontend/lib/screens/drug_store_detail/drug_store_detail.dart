// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';

const String kakaoMapKey = '7456c753f359ee3f7137fc8dd3adfaf8';

class DrugStoreDetail extends StatelessWidget {
  final double latSmall, lngBig;
  final String here, addr, telno;
  const DrugStoreDetail({
    super.key,
    required this.latSmall,
    required this.lngBig,
    required this.here,
    required this.addr,
    required this.telno,
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
              customOverlayStyle:
                  '''
                  <style>
                    .customoverlay {position:relative;bottom:85px;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd;float:left;}
                    .customoverlay:nth-of-type(n) {border:0; box-shadow:0px 1px 2px #888;}
                    .customoverlay a {display:block;text-decoration:none;color:#000;text-align:center;border-radius:6px;font-size:14px;font-weight:bold;overflow:hidden;background: #d95050;background: #d95050 url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/arrow_white.png) no-repeat right 14px center;}
                    .customoverlay .title {display:block;text-align:center;background:#fff;margin-right:35px;padding:10px 15px;font-size:14px;font-weight:bold;}
                    .customoverlay:after {content:'';position:absolute;margin-left:-12px;left:50%;bottom:-12px;width:22px;height:12px;background:url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png')}
                  </style>
                  ''',
              customOverlay: '''
                  var content =
                      '<div class="customoverlay">' +
                      '  <a href="https://www.google.com/maps/search/?api=1&query=$latSmall, $lngBig" target="_blank">' +
                      '    <span class="title">$here</span>' +
                      '  </a>' +
                      '</div>';

                  var position = new kakao.maps.LatLng($latSmall, $lngBig);

                  var customOverlay = new kakao.maps.CustomOverlay({
                      map: map,
                      position: position,
                      content: content,
                      yAnchor: 1
                  });
                  ''',
              markerImageURL:
                  'https://cdn-icons-png.flaticon.com/512/8059/8059164.png',
          ),
          Row(
            children: [
              const Icon(Icons.title_rounded),
              Text(here)
            ],
          ),
          Row(
            children: [
              const Icon(Icons.map_rounded),
              Text(addr)
            ],
          ),
          Row(
            children: [
              const Icon(Icons.phone),
              Text(telno)
            ],
          ),
        ],
      ),
    );
  }

}
