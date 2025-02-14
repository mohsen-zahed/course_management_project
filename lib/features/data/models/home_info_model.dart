class HomeInfoModel {
  final String image;
  final String title;
  final String value;

  const HomeInfoModel({required this.image, required this.title, required this.value});

  factory HomeInfoModel.fromJson(Map<String, dynamic> json) {
    return HomeInfoModel(image: '', title: json['title'], value: json['value']);
  }
}
