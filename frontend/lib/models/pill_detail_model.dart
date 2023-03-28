class PillDetailModel {
  final String itemSeq,
      img,
      entpName,
      mainItemIngr,
      eeDocData,
      udDocData,
      storageMethod,
      nbDocData,
      typeCode,
      itemName;
  final bool isMine;

  PillDetailModel.fromJson(Map<String, dynamic> json)
      : itemSeq = json['itemSeq'],
        img = json['img'],
        entpName = json['entpName'],
        mainItemIngr = json['mainItemIngr'],
        eeDocData = json['eeDocData'],
        udDocData = json['udDocData'],
        storageMethod = json['storageMethod'],
        nbDocData = json['nbDocData'],
        typeCode = json['typeCode'],
        itemName = json['itemName'],
        isMine = json['isMine'];
}
