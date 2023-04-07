class GetNewsModel {
  final String url, img, title, description;

  GetNewsModel.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        img = json['img'],
        title = json['title'],
        description = json['description'];
}
