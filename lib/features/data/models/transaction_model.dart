class TransactionModel {
  final int id;
  final int studentId;
  final String studentName;
  final String lastName;
  final int amount;
  final String name;
  final String date;
  final String startDate;
  final String endDate;
  final String tranType;
  final int userId;

  const TransactionModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.lastName,
    required this.amount,
    required this.name,
    required this.date,
    required this.startDate,
    required this.endDate,
    required this.tranType,
    required this.userId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? -1,
      studentId: json['student_id'] ?? -1,
      studentName: json['st_name'] ?? '',
      lastName: json['st_lastname'] ?? '',
      amount: json['amount'] ?? 0,
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      tranType: json['tran_type'] ?? '',
      userId: json['user_id'] ?? -1,
    );
  }
}
