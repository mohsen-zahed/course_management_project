import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/helpers/theme_helpers.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final String description;
  final String date;
  const CommentCard({super.key, required this.description, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          date,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: isThemeLight(context) ? kGreyColor : kGreyColor400, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Container(
          width: getMediaQueryWidth(context),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: isThemeLight(context) ? kGreyColor100 : kGreyColor700,
          ),
          child: Text(description, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
