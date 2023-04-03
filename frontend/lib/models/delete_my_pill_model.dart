class DeleteMyPillModel {
  final String itemName, img;
  final int itemSeq, dday, myMedicineSeq;
  final List<dynamic> tagList;

  DeleteMyPillModel.fromJson(Map<String, dynamic> json)
      : itemName = json['itemName'],
        img = json['img'],
        tagList = json['tagList'],
        myMedicineSeq = json['myMedicineSeq'],
        dday = json['dday'],
        itemSeq = json['itemSeq'];
}
