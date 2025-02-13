class GradeModel {
  final int studentId;
  final String name;
  final String lastName;
  final String bookName;
  final int userId;
  final String time;
  final String date;
  final int grade;
  final String startDate;
  final String endDate;

  GradeModel({
    required this.studentId,
    required this.name,
    required this.lastName,
    required this.bookName,
    required this.userId,
    required this.time,
    required this.date,
    required this.grade,
    required this.startDate,
    required this.endDate,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      studentId: json['student_id'] ?? -1,
      name: json['st_name'] ?? '',
      lastName: json['st_lastname'],
      bookName: json['name'] ?? '',
      userId: json['user_id'] ?? -1,
      time: json['time'] ?? '',
      date: json['grades_date'] ?? '',
      grade: json['grades_point'] ?? -1,
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
    );
  }
}
