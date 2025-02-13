import 'package:course_management_project/features/data/models/attendance_model.dart';
import 'package:flutter/material.dart';

class AttendanceProvider extends ChangeNotifier {
  List<AttendanceModel> attendanceList = [];

  updateAttendanceList(List<AttendanceModel> attendanceListInput) {
    for (var i = 0; i < attendanceListInput.length; i++) {
      if (!attendanceList.any((element) => element.id == attendanceListInput[i].id)) {
        attendanceList.add(attendanceListInput[i]);
      }
    }
    notifyListeners();
  }
}
