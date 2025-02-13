import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({super.key, this.buttonText, required this.onTap});
  final String? buttonText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: getMediaQueryHeight(context, 0.1),
            color: kRedColor,
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  buttonText ?? 'تلاش دوباره',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5),
                 Icon(Icons.refresh, size: 17.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomNoWifiWidget extends StatelessWidget {
  const CustomNoWifiWidget({super.key, this.buttonText, required this.onTap});
  final String? buttonText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: getMediaQueryHeight(context, 0.1),
            color: kRedColor.withOpacity(0.4),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  buttonText ?? 'تلاش دوباره',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.refresh, size: 17),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
