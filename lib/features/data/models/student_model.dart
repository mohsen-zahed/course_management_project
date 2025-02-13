class StudentModel {
  final int studentId;
  final String name;
  final String fName;
  final String lastName;
  final String phoneNum;
  final String printCardStatus;
  final String dateOfBirth;
  final String registrationDate;
  final int userId;
  final String stId;
  final String profileImage;
  final String statusDelete;
  final String createdAt;
  final String updatedAt;
  final String status;
  final String description;

  const StudentModel({
    required this.studentId,
    required this.name,
    required this.fName,
    required this.lastName,
    required this.phoneNum,
    required this.printCardStatus,
    required this.dateOfBirth,
    required this.registrationDate,
    required this.userId,
    required this.stId,
    required this.profileImage,
    required this.statusDelete,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.description,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      studentId: json['student_id'] ?? -1,
      name: json['st_name'] ?? '',
      fName: json['st_fathername'] ?? '',
      lastName: json['st_lastname'] ?? '',
      phoneNum: json['stphonenumber'] ?? '',
      printCardStatus: json['PrintcardStatus'] ?? '',
      dateOfBirth: json['dateofbirth'] ?? '',
      registrationDate: json['dateregister'] ?? '',
      userId: json['user_id'] ?? -1,
      stId: json['st_ID'] ?? '',
      profileImage:
          json['st_profile'] != null ? 'https://tam.tawanaacademy.com/public/st_profile/${json['st_profile']}' : '',
      statusDelete: json['status_delete'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      status: json['status'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
