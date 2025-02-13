import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/features/data/models/grade_model.dart';
import 'package:course_management_project/helpers/date_formatters.dart';
import 'package:course_management_project/helpers/theme_helpers.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:flutter/material.dart';

class GradesInfoCard extends StatelessWidget {
  const GradesInfoCard(
      {super.key, required this.index, required this.studentName, required this.lastName, required this.gradeModel});
  final int index;
  final String studentName;
  final String lastName;
  final GradeModel gradeModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: isThemeLight(context) ? kStudentCardInfoColor : kGreyColor700,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text((index + 1).toString(), style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
          Container(
            width: 0.7,
            height: 90,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            color: isThemeLight(context) ? kBlueColor.withOpacity(0.2) : kGreyColor600,
          ),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Column(
                    //   mainAxisSize: MainAxisSize.min,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       studentName,
                    //       style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    //     ),
                    //     const SizedBox(height: 5),
                    //     Text(
                    //       lastName,
                    //       style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        gradeModel.bookName,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        textDirection: TextDirection.ltr,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        Text('نمره', style: Theme.of(context).textTheme.bodyMedium),
                        Text(
                          gradeModel.grade.toString(),
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  width: getMediaQueryWidth(context, 0.8),
                  height: 0.7,
                  color: isThemeLight(context) ? kBlueColor.withOpacity(0.2) : kGreyColor600,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'تاریخ نمره دهی',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            DateFormatters.convertToShamsiWithDayName(gradeModel.date, hideDay: true),
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'تاریخ شروع',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            DateFormatters.convertToShamsiWithDayName(gradeModel.startDate, hideDay: true),
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'تاریخ ختم',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            DateFormatters.convertToShamsiWithDayName(gradeModel.endDate, hideDay: true),
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
