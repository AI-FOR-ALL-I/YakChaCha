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
  final bool mine, warnPregnant, warnAge, warnOld, collide;
  final List tagList, collideList, startDate, endDate;

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
        mine = json['mine'],
        warnPregnant = json['warnPregnant'],
        warnAge = json['warnAge'],
        warnOld = json['warnOld'],
        collide = json['collide'],
        startDate = json['startDate'] ?? [],
        endDate = json['endDate'] ?? [],
        tagList = json['tagList'] ?? [],
        collideList = json['collideList'] ?? [],
        itemSeq = json['itemSeq'];
}
