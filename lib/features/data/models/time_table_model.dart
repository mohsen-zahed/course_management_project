class TimeTableModel {
  final String startTime;
  final String endTime;
  final int timeId;
  final String startDate;
  final String endDate;
  final int successPoint;
  final String statusFinish;
  final String subName;
  final String courseName;

  const TimeTableModel({
    required this.startTime,
    required this.endTime,
    required this.timeId,
    required this.startDate,
    required this.endDate,
    required this.successPoint,
    required this.statusFinish,
    required this.subName,
    required this.courseName,
  });

  factory TimeTableModel.fromJson(Map<String, dynamic> json) {
    return TimeTableModel(
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      timeId: json['time_id'] ?? -1,
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      successPoint: json['success_point'] ?? 0,
      statusFinish: json['status_finish'] ?? '',
      subName: json['sub_name'] ?? '',
      courseName: json['course_name'] ?? '',
    );
  }
}
