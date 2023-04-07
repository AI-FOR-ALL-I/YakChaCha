class MyPillModel {
  final String itemName, img;
  final int itemSeq, dday;
  final List tagList, period;

  MyPillModel.fromJson(Map<String, dynamic> json)
      : itemName = json['itemName'],
        img = json['img'],
        tagList = json['tagList'],
        dday = json['dday'],
        period = json['period'],
        itemSeq = json['itemSeq'];
}
