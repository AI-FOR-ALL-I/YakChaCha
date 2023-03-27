class MyPillModel {
  final String name, picture, id;
  final List title;

  MyPillModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        picture = json['picture'],
        title = json['title'],
        id = json['id'];
}
