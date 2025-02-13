import 'package:course_management_project/features/data/models/daily_grade_model.dart';
import 'package:flutter/material.dart';

class DailyGradesProvider extends ChangeNotifier {
  List<DailyGradeModel> dailyGradesList = [];
  updateDailyGradesList(List<DailyGradeModel> dailyGradesListInput) {
    for (var i = 0; i < dailyGradesListInput.length; i++) {
      if (!dailyGradesList.any((element) => element.id == dailyGradesListInput[i].id)) {
        dailyGradesList.add(dailyGradesListInput[i]);
      }
    }
  }
}
