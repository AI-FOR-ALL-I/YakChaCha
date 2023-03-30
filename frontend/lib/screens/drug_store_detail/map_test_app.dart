// import 'package:flutter/material.dart';
// import 'package:frontend/screens/drug_store_detail/drug_store_search.dart';
// import 'package:frontend/widgets/common/search_input.dart';
// import 'package:kakaomap_webview/kakaomap_webview.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// String jscode = '''function createCurrentMarker(lat,lng) {
//     if(currentMarker){
//         currentMarker.setPosition(new kakao.maps.LatLng(lat, lng));
//     }else{
//         currentMarker = new kakao.maps.Marker({
//             map: map,
//             position: new kakao.maps.LatLng(lat, lng),
//             image: new kakao.maps.MarkerImage(imageUrl, new kakao.maps.Size(45, 41)),
//         });
//     }
//     kakao.maps.event.addListener(currentMarker, 'click', function(){
//             onClickMarker.postMessage('marker is clicked');
//       });
//     map.panTo(new kakao.maps.LatLng(lat, lng));
// }''';

// class MapTestAPP extends StatelessWidget {
//   WebViewController? controller;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(children: [
//       Container(height: 400, child: MapTest(controller)),
//       ElevatedButton(
//           onPressed: () {
//             createCurrentMarker();
//           },
//           child: const Text('현재위치 표시'))
//     ]));
//   }

//   void createCurrentMarker() {
//     StaticFunctions.getCurrentLocation().then((value) => {
//           if (value != null)
//             {
//               controller!
//                   .runJavascript('createCurrentMarker(${value[0]},${value[1]})')
//             }
//         });
//   }
// }

// class MapTest extends StatelessWidget {
//   String url = "";
//   Set<JavascriptChannel>? channel;
//   WebViewController? controller;

//   MapTest(this.controller) {
//     channel = {
//       JavascriptChannel(
//           name: 'onClickMarker',
//           onMessageReceived: (message) {
//             Fluttertoast.showToast(msg: message.message);
//           })
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     double ratio = MediaQuery.of(context).devicePixelRatio;
//     return ClipRect(
//         child: Transform.scale(
//             scale: ratio,
//             child: WebView(
//               initialUrl: url,
//               onWebViewCreated: (controller) {
//                 this.controller = controller;
//               },
//               javascriptChannels: channel,
//               javascriptMode: JavascriptMode.unrestricted,
//             )));
//   }
// }
