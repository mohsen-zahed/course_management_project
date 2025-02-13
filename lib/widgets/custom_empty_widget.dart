import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/config/constants/images_paths.dart';
import 'package:course_management_project/helpers/theme_helpers.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomEmptyWidget extends StatelessWidget {
  const CustomEmptyWidget({super.key, this.onTap, this.message});
  final VoidCallback? onTap;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            ImagesPaths.noDataSvg,
            height: getMediaQueryHeight(context, 0.25),
          ),
          const SizedBox(height: 5),
          TextButton(
            onPressed: onTap,
            child: Text(
              message ?? 'دیتایی برای مشاهده وجود ندارد!',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isThemeLight(context) ? kGreyColor700 : kGreyColor200,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
