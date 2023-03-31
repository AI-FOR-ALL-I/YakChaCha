// // import 'dart:html';

// import 'package:flutter/material.dart';
// import 'package:frontend/widgets/common/search_input.dart';
// import 'package:frontend/widgets/drug_store/drug_store.dart';
// import 'package:xml/xml.dart';

// class DrugStoreSearch extends StatelessWidget {
//   const DrugStoreSearch({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("약국 찾기"), centerTitle: true),
//       body: ListView(
//         children: [
//           SearchInput(hintText: "hintText", onChanged: (p1) {}),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [Icon(Icons.my_location_rounded), Text("내 위치 중심")],
//               ),
//               Icon(Icons.arrow_right)
//             ],
//           ),
//           DrugStore(),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

class DrugStoreSearch extends StatelessWidget {
  // final String xmlData = '''<DOC title="용법용량" type="UD">
  //     <SECTION title="">
  //       <ARTICLE title="">
  //         <PARAGRAPH tagName="p" textIndent="" marginLeft="">
  //           <![CDATA[(주사제)]]>
  //         </PARAGRAPH>
  //         <PARAGRAPH tagName="p" textIndent="" marginLeft="">
  //           <![CDATA[(5%)]]>
  //         </PARAGRAPH>
  //         <PARAGRAPH tagName="p" textIndent="0" marginLeft="2">
  //           <![CDATA[○ 성인 : 1회 500∼1000 mL 정맥주사한다.]]>
  //         </PARAGRAPH>
  //         <PARAGRAPH tagName="p" textIndent="0" marginLeft="2">
  //           <![CDATA[○ 점적정맥주사 속도는 포도당으로서 시간당 0.5 g/kg 이하로 한다.]]>
  //         </PARAGRAPH>
  //         <PARAGRAPH tagName="p" textIndent="0" marginLeft="2">
  //           <![CDATA[○ 주사제의 용해 희석에는 적당량을 사용한다.]]>
  //         </PARAGRAPH>
  //         <PARAGRAPH tagName="p" textIndent="0" marginLeft="2">
  //           <![CDATA[연령, 증상에 따라 적절히 증감한다.]]>
  //         </PARAGRAPH>
  //       </ARTICLE>
  //     </SECTION>
  //   </DOC>''';
  final String xmlData = '''
    <DOC title="용법용량" type="UD">
<SECTION title="">
<ARTICLE title="1. 성인 및 12세 이상의 소아">
<PARAGRAPH tagName="p" textIndent="" marginLeft="">
<![CDATA[ 1회 2정을 1일 2회 12시간마다 식후 경구투여한다. 14일 이상 장기투여 시 유지량으로 1회 1정을 1일 2회 투여하고 심한 감염증에는 최대용량으로 1회 3정을 투여한다. ]]>
</PARAGRAPH>
</ARTICLE>
<ARTICLE title="2. 12세 미만의 소아">
<PARAGRAPH tagName="p" textIndent="" marginLeft="">
<![CDATA[ 다음 용량을 참고하여 체중 kg당 트리메토프림 6 mg과 설파메톡사졸 30 mg을 1일 2회 분할 투여한다. ]]>
</PARAGRAPH>
<PARAGRAPH tagName="p" textIndent="" marginLeft="">
<![CDATA[ 6～11세 : 1회 1정, 1일 2회 ]]>
</PARAGRAPH>
<PARAGRAPH tagName="p" textIndent="" marginLeft="">
<![CDATA[ 3～5세 : 1회 1/2정, 1일 2회 ]]>
</PARAGRAPH>
</ARTICLE>
<ARTICLE title="3. 신장애 환자">
<PARAGRAPH tagName="table" textIndent="" marginLeft="">
<![CDATA[ <tbody> <tr> <td> <p>크레아티닌 청소율(mL/분)</p> </td> <td> <p>용량</p> </td> </tr> <tr> <td> <p>30 이상</p> <p>15～30</p> <p>15 이하</p> </td> <td> <p>정상용량</p> <p>정상용량의 1/2</p> <p>투여가 권장되지 않는다</p> </td> </tr> </tbody> ]]>
</PARAGRAPH>
</ARTICLE>
<ARTICLE title="4. 뉴우모시스티스 카리니 폐렴">
<PARAGRAPH tagName="p" textIndent="" marginLeft="">
<![CDATA[ 체중 kg당 트리메토프림 20 mg과 설파메톡사졸 100 mg을 14일간 1일 4회 분할 투여한다. 급성감염증에는 최소한 5일간 또는 증상이 소실된 후에도 2일간 더 투여한다. ]]>
</PARAGRAPH>
<PARAGRAPH tagName="p" textIndent="0" marginLeft="1">
<![CDATA[ * 위장장애를 최소화 할 수 있도록 음식이나 음료와 함께 투여하는 것이 바람직하다. ]]>
</PARAGRAPH>
<PARAGRAPH tagName="p" textIndent="0" marginLeft="1">
<![CDATA[ * 2개월 미만의 영아에는 투여하지 않는다. ]]>
</PARAGRAPH>
<PARAGRAPH tagName="p" textIndent="0" marginLeft="1">
<![CDATA[ * 연령, 증상에 따라 적절히 증감한다. ]]>
</PARAGRAPH>
</ARTICLE>
</SECTION>
</DOC>
    ''';

  @override
  Widget build(BuildContext context) {
    XmlDocument document = XmlDocument.parse(xmlData);
    XmlElement root = document.rootElement;

    // Get the text content from each PARAGRAPH tag
    List<String> paragraphs = root
        .findAllElements('PARAGRAPH')
        .map((element) => element.text)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Dosage'),
      ),
      body: ListView.builder(
        itemCount: paragraphs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              paragraphs[index],
              style: TextStyle(fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}






// // import 'dart:html';

// import 'package:flutter/material.dart';
// import 'package:frontend/widgets/common/search_input.dart';
// import 'package:frontend/widgets/drug_store/drug_store.dart';
// import 'package:xml/xml.dart';

// class DrugStoreSearch extends StatelessWidget {
//   const DrugStoreSearch({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("약국 찾기"), centerTitle: true),
//       body: ListView(
//         children: [
//           SearchInput(hintText: "hintText", onChanged: (p1) {}),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [Icon(Icons.my_location_rounded), Text("내 위치 중심")],
//               ),
//               Icon(Icons.arrow_right)
//             ],
//           ),
//           DrugStore(),
//         ],
//       ),
//     );
//   }
// }



// 하던거하던거하던거하던거하던거하던거하던거하던거하던거하던거하던거하던거하던거하던거하던거하던거하던거하던거하던거하던거하던거하던거하던거하던거
// import 'package:flutter/material.dart';
// import 'package:frontend/services/api_drug_store.dart';
// import 'package:xml/xml.dart';

// class DrugStoreSearch extends StatelessWidget {
//   // final String xmlData = '''<DOC title="용법용량" type="UD">
//   //     <SECTION title="">
//   //       <ARTICLE title="">
//   //         <PARAGRAPH tagName="p" textIndent="" marginLeft="">
//   //           <![CDATA[(주사제)]]>
//   //         </PARAGRAPH>
//   //         <PARAGRAPH tagName="p" textIndent="" marginLeft="">
//   //           <![CDATA[(5%)]]>
//   //         </PARAGRAPH>
//   //         <PARAGRAPH tagName="p" textIndent="0" marginLeft="2">
//   //           <![CDATA[○ 성인 : 1회 500∼1000 mL 정맥주사한다.]]>
//   //         </PARAGRAPH>
//   //         <PARAGRAPH tagName="p" textIndent="0" marginLeft="2">
//   //           <![CDATA[○ 점적정맥주사 속도는 포도당으로서 시간당 0.5 g/kg 이하로 한다.]]>
//   //         </PARAGRAPH>
//   //         <PARAGRAPH tagName="p" textIndent="0" marginLeft="2">
//   //           <![CDATA[○ 주사제의 용해 희석에는 적당량을 사용한다.]]>
//   //         </PARAGRAPH>
//   //         <PARAGRAPH tagName="p" textIndent="0" marginLeft="2">
//   //           <![CDATA[연령, 증상에 따라 적절히 증감한다.]]>
//   //         </PARAGRAPH>
//   //       </ARTICLE>
//   //     </SECTION>
//   //   </DOC>''';
//   final String xmlData = '''
//     <DOC title="용법용량" type="UD">
// <SECTION title="">
// <ARTICLE title="1. 성인 및 12세 이상의 소아">
// <PARAGRAPH tagName="p" textIndent="" marginLeft="">
// <![CDATA[ 1회 2정을 1일 2회 12시간마다 식후 경구투여한다. 14일 이상 장기투여 시 유지량으로 1회 1정을 1일 2회 투여하고 심한 감염증에는 최대용량으로 1회 3정을 투여한다. ]]>
// </PARAGRAPH>
// </ARTICLE>
// <ARTICLE title="2. 12세 미만의 소아">
// <PARAGRAPH tagName="p" textIndent="" marginLeft="">
// <![CDATA[ 다음 용량을 참고하여 체중 kg당 트리메토프림 6 mg과 설파메톡사졸 30 mg을 1일 2회 분할 투여한다. ]]>
// </PARAGRAPH>
// <PARAGRAPH tagName="p" textIndent="" marginLeft="">
// <![CDATA[ 6～11세 : 1회 1정, 1일 2회 ]]>
// </PARAGRAPH>
// <PARAGRAPH tagName="p" textIndent="" marginLeft="">
// <![CDATA[ 3～5세 : 1회 1/2정, 1일 2회 ]]>
// </PARAGRAPH>
// </ARTICLE>
// <ARTICLE title="3. 신장애 환자">
// <PARAGRAPH tagName="table" textIndent="" marginLeft="">
// <![CDATA[ <tbody> <tr> <td> <p>크레아티닌 청소율(mL/분)</p> </td> <td> <p>용량</p> </td> </tr> <tr> <td> <p>30 이상</p> <p>15～30</p> <p>15 이하</p> </td> <td> <p>정상용량</p> <p>정상용량의 1/2</p> <p>투여가 권장되지 않는다</p> </td> </tr> </tbody> ]]>
// </PARAGRAPH>
// </ARTICLE>
// <ARTICLE title="4. 뉴우모시스티스 카리니 폐렴">
// <PARAGRAPH tagName="p" textIndent="" marginLeft="">
// <![CDATA[ 체중 kg당 트리메토프림 20 mg과 설파메톡사졸 100 mg을 14일간 1일 4회 분할 투여한다. 급성감염증에는 최소한 5일간 또는 증상이 소실된 후에도 2일간 더 투여한다. ]]>
// </PARAGRAPH>
// <PARAGRAPH tagName="p" textIndent="0" marginLeft="1">
// <![CDATA[ * 위장장애를 최소화 할 수 있도록 음식이나 음료와 함께 투여하는 것이 바람직하다. ]]>
// </PARAGRAPH>
// <PARAGRAPH tagName="p" textIndent="0" marginLeft="1">
// <![CDATA[ * 2개월 미만의 영아에는 투여하지 않는다. ]]>
// </PARAGRAPH>
// <PARAGRAPH tagName="p" textIndent="0" marginLeft="1">
// <![CDATA[ * 연령, 증상에 따라 적절히 증감한다. ]]>
// </PARAGRAPH>
// </ARTICLE>
// </SECTION>
// </DOC>
//     ''';
//   final Future drugstores = ApiDrugStore.getDrugStore();
//   @override
//   Widget build(BuildContext context) {
//     // XmlDocument document = XmlDocument.parse(xmlData);
//     // XmlElement root = document.rootElement;

//     // // Get the text content from each PARAGRAPH tag
//     // List<String> paragraphs = root
//     //     .findAllElements('PARAGRAPH')
//     //     .map((element) => element.text)
//     //     .toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dosage'),
//       ),
//       body: FutureBuilder(
//         future: drugstores,
//         builder:(context, snapshot) => ,
//         child: ListView.builder(
//           itemCount: paragraphs.length,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//               child: Text(
//                 paragraphs[index],
//                 style: TextStyle(fontSize: 16),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
