class PillDetailModel {
  final String img,
      entpName,
      mainItemIngr,
      eeDocData,
      udDocData,
      storageMethod,
      nbDocData,
      typeCode,
      itemName;
  final int itemSeq;
  // final bool isMine;

  PillDetailModel.fromJson(Map<String, dynamic> json)
      : img = json['img'],
        entpName = json['entpName'],
        mainItemIngr = json['mainItemIngr'],
        eeDocData = json['eeDocData'],
        udDocData = json['udDocData'],
        storageMethod = json['storageMethod'],
        nbDocData = json['nbDocData'],
        typeCode = json['typeCode'],
        itemName = json['itemName'],
        // isMine = json['isMine'],
        itemSeq = json['itemSeq'];
}
