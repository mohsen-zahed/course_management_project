import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/features/data/models/daily_grade_model.dart';
import 'package:course_management_project/helpers/date_formatters.dart';
import 'package:course_management_project/helpers/theme_helpers.dart';
import 'package:flutter/material.dart';

class DailyGradeInfoCard extends StatelessWidget {
  const DailyGradeInfoCard({
    super.key,
    required this.index,
    required this.studentName,
    required this.lastName,
    required this.dailyGradeModel,
  });
  final int index;
  final String studentName;
  final String lastName;
  final DailyGradeModel dailyGradeModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isThemeLight(context) ? const Color.fromARGB(255, 235, 244, 252) : kGreyColor700,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            color: kBlackColor12.withOpacity(0.1),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ListTile(
        tileColor: kTransparentColor,
        leading: Text((index + 1).toString(), style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        horizontalTitleGap: 5,
        contentPadding: const EdgeInsets.fromLTRB(25, 3, 17, 3),
        title: Text(
          dailyGradeModel.bookName,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            dailyGradeModel.description.isNotEmpty
                ? '${DateFormatters.convertToShamsiWithDayName(dailyGradeModel.dailyDate)}\n${dailyGradeModel.description}'
                : DateFormatters.convertToShamsiWithDayName(dailyGradeModel.dailyDate),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: isThemeLight(context) ? kGreyColor600 : kGreyColor400, fontWeight: FontWeight.bold),
          ),
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('نمره', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 3),
            Text(dailyGradeModel.dailyPoint.toString(), style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
