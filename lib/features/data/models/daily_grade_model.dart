class DailyGradeModel {
  final int id;
  final String name;
  final int studentId;
  final String lastName;
  final int dailyPoint;
  final String dailyDate;
  final String bookName;
  final int userId;
  final String startDate;
  final String endDate;
  final String description;

  const DailyGradeModel({
    required this.id,
    required this.name,
    required this.studentId,
    required this.lastName,
    required this.dailyPoint,
    required this.dailyDate,
    required this.bookName,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  factory DailyGradeModel.fromJson(Map<String, dynamic> json) {
    return DailyGradeModel(
      id: json['id'] ?? -1,
      name: json['st_name'] ?? '',
      studentId: json['student_id'] ?? -1,
      lastName: json['st_lastname'] ?? '',
      dailyPoint: json['grade_dailies_point'] ?? 0,
      dailyDate: json['grade_dailies_date'] ?? '',
      bookName: json['name'] ?? '',
      userId: json['user_id'] ?? -1,
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
