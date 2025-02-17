class HomeInfoModel {
  final String studentName;
  final int dailyGrade;
  final int remainMoney;
  final int countClasses;
  final int countComments;

  HomeInfoModel({
    required this.studentName,
    required this.dailyGrade,
    required this.remainMoney,
    required this.countClasses,
    required this.countComments,
  });

  factory HomeInfoModel.fromJson(Map<String, dynamic> json) {
    return HomeInfoModel(
      studentName: json['st_name'] ?? '',
      dailyGrade: json['countDailyGrade'] ?? 0,
      remainMoney: json['remainMoney'] ?? 0,
      countClasses: json['countClasses'] ?? 0,
      countComments: json['countComment'] ?? 0,
    );
  }
}
