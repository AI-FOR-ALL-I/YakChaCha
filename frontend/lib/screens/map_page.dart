import 'package:flutter/material.dart';
import 'package:frontend/screens/drug_store_detail/drug_store_search.dart';
import 'package:frontend/widgets/common/search_input.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';

const String kakaoMapKey = '7456c753f359ee3f7137fc8dd3adfaf8'; // 자바스크립트 키

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Center(
          child: SearchInput(
            hintText: "힌트",
            onChanged: (p1) {},
          ),
        ),
        KakaoMapView(
            width: size.width,
            height: 400,
            kakaoMapKey: kakaoMapKey,
            lat: 33.450701,
            lng: 126.570667,
            showMapTypeControl: true,
            showZoomControl: true,
            markerImageURL:
                'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
            onTapMarker: (message) async {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Marker is clicked')));

              //await _openKakaoMapScreen(context);
            }),
        ElevatedButton(
            child: Text('Kakao map screen'),
            onPressed: () async {
              // await _openKakaoMapScreen(context);
            }),
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DrugStoreSearch(),
                  ));
            },
            icon: Icon(Icons.ac_unit)),
      ],
    );
  }

  // // kakao map 지도 검색으로 이동
  // Future<void> _openKakaoMapScreen(BuildContext context) async {
  //   KakaoMapUtil util = KakaoMapUtil();

  //   String url =
  //       await util.getMapScreenURL(33.450701, 126.570667, name: 'Kakao 본사');

  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (_) => KakaoMapScreen(url: url)));
  // }
}
