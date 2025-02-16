import 'package:course_management_project/packages/dio_package/dio_package.dart';

class AdBannerModel {
  final int id;
  final String title;
  final String image;
  final String createdAt;
  final String udpatedAt;

  const AdBannerModel(
      {required this.id, required this.title, required this.image, required this.createdAt, required this.udpatedAt});

  factory AdBannerModel.fromJson(Map<String, dynamic> json) {
    return AdBannerModel(
      id: json['advertisement_id'],
      title: json['title'] ?? '',
      image: json['Image'] != null ? '$updoadsUrl/images/${json['Image']}' : '',
      createdAt: json['created_at'],
      udpatedAt: json['updated_at'],
    );
  }
}
