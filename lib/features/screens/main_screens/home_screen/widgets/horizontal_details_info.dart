import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:flutter/material.dart';

class HorizontalDetailsInfo extends StatelessWidget {
  const HorizontalDetailsInfo({super.key, required this.title, required this.value, this.hideBottomLine = false});

  final String title;
  final String value;
  final bool? hideBottomLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$title:', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  value,
                  maxLines: 2,
                  style:
                      Theme.of(context).textTheme.bodySmall!.copyWith(color: kGreyColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: getMediaQueryHeight(context),
          height: hideBottomLine == false ? 0.5 : 0,
          color: hideBottomLine == false ? kStudentCardInfoColor : kTransparentColor,
        )
      ],
    );
  }
}
