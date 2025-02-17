import 'package:course_management_project/features/data/models/home_info_details_model.dart';
import 'package:course_management_project/packages/dio_package/dio_package.dart';

class HomeStudentModel {
  final String stName;
  final String profile;
  final String stId;
  final List<HomeInfoDetailsModel> details;

  HomeStudentModel({required this.stName, required this.profile, required this.stId, required this.details});

  // Convert JSON to StudentModel
  factory HomeStudentModel.fromJson(Map<String, dynamic> json) {
    var detailsFromJson = json['details'] as List;
    List<HomeInfoDetailsModel> detailsList = detailsFromJson.map((e) => HomeInfoDetailsModel.fromJson(e)).toList();
    return HomeStudentModel(
      stName: json['st_name'] ?? '',
      stId: json['st_ID'] ?? '',
      profile: json['st_profile'] != null ? '$profileUrl/${json['st_profile']}' : '',
      details: detailsList,
    );
  }

  // Convert StudentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'st_name': stName,
      'details': details.map((e) => e.toJson()).toList(),
    };
  }
}
