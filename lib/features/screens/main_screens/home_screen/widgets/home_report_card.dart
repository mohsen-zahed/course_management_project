import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/features/data/models/home_info_details_model.dart';
import 'package:course_management_project/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:text_scroll/text_scroll.dart';

class HomeReportCard extends StatelessWidget {
  const HomeReportCard({super.key, required this.infoModel});
  final HomeInfoDetailsModel infoModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kBlueCustomColor.withOpacity(0.3),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(infoModel.imagePath, height: sizeConstants.imageXSmall),
                Container(
                  width: sizeConstants.imageSmall + 10.w,
                  height: sizeConstants.imageXSmall,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: kBlueCustomColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  alignment: Alignment.center,
                  child: TextScrollPackage(text: infoModel.value.toString()),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              _getLabel(infoModel.label),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

_getLabel(String label) {
  switch (label) {
    case 'Daily Grade':
      return 'نمرات روزانه';
    case 'Remaining Money':
      return 'باقی داری پول';
    case 'Classes Attended':
      return 'صنوف';
    case 'Comments':
      return 'نظریات';
    default:
      return label;
  }
}

class TextScrollPackage extends StatelessWidget {
  const TextScrollPackage({super.key, required this.text, this.textStyle, this.start});
  final String text;
  final TextStyle? textStyle;
  final bool? start;

  @override
  Widget build(BuildContext context) {
    return TextScroll(
      delayBefore: const Duration(seconds: 1),
      pauseBetween: const Duration(milliseconds: 300),
      velocity: const Velocity(pixelsPerSecond: Offset(10, 0)),
      textAlign: start == true ? TextAlign.start : TextAlign.center,
      selectable: true,
      text,
      style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
    );
  }
}
