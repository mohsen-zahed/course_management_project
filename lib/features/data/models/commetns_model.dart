class CommentModel {
  final String studentName;
  final int studentId;
  final String lastName;
  final String comment;
  final String date;

  const CommentModel({
    required this.studentName,
    required this.studentId,
    required this.lastName,
    required this.comment,
    required this.date,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      studentName: json['st_name'] ?? '',
      studentId: json['student_id'] ?? '',
      lastName: json['st_lastname'] ?? '',
      comment: json['comment'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
