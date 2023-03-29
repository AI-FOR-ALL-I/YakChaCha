class MyPillModel {
  final String itemName, img;
  final int itemSeq;
  final List tag_list;

  MyPillModel.fromJson(Map<String, dynamic> json)
      : itemName = json['itemName'],
        img = json['img'],
        tag_list = json['tag_list'],
        itemSeq = json['itemSeq'];
}
