class MyPillModel {
  final String itemName, img;
  final int itemSeq, dday;
  final List<dynamic> tagList;

  MyPillModel.fromJson(Map<String, dynamic> json)
      : itemName = json['itemName'],
        img = json['img'],
        tagList = json['tagList'],
        dday = json['dday'],
        itemSeq = json['itemSeq'];
}
