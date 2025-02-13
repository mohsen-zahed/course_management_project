import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:flutter/material.dart';

class InfoDetailsBox extends StatelessWidget {
  final String text;
  final BorderRadius borderRadius;
  final TextStyle? textStyle;
  const InfoDetailsBox({super.key, required this.text, required this.borderRadius, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(color: kStudentCardInfoColor),
      ),
      child: Text(
        text,
        style: textStyle ?? Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
