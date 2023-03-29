class MyPillModel {
  final String itemName, img;
  final int itemSeq;
  final List<dynamic> tagList;

  MyPillModel.fromJson(Map<String, dynamic> json)
      : itemName = json['itemName'],
        img = json['img'],
        tagList = json['tagList'],
        itemSeq = json['itemSeq'];
}
