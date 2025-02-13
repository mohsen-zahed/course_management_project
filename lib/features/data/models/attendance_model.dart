class AttendanceModel {
  final int id;
  final String bookName;
  final String studentName;
  final String lastName;
  final int userId;
  final String status;
  final String date;
  final String startDate;
  final String endDate;

  const AttendanceModel({
    required this.id,
    required this.bookName,
    required this.studentName,
    required this.lastName,
    required this.userId,
    required this.status,
    required this.date,
    required this.startDate,
    required this.endDate,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] ?? -1,
      bookName: json['name'] ?? '',
      studentName: json['st_name'] ?? '',
      lastName: json['st_lastname'] ?? '',
      userId: json['user_id'] ?? -1,
      status: json['status'] ?? '',
      date: json['date'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
    );
  }
}
