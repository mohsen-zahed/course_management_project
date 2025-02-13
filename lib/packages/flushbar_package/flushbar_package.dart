import 'package:another_flushbar/flushbar.dart';
import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlushbarPackage {
  FlushbarPackage._();

  static showFlushbar(BuildContext context, String message) {
    return Flushbar(
      message: message,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(5),
      icon: Icon(
        Icons.info_outline,
        size: 25.sp,
        color: Colors.blue[300],
      ),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: const Duration(seconds: 3),
      blockBackgroundInteraction: false,
      leftBarIndicatorColor: kTransparentColor,
    )..show(context);
  }

  static showErrorFlushbar(BuildContext context, String message) {
    return Flushbar(
      messageText: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: kWhiteColor),
      ),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(10),
      backgroundColor: kErrorMessageBackgroundColor,
      icon: const Icon(Icons.info_outline, size: 28.0, color: kRedColor),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: const Duration(seconds: 3),
      leftBarIndicatorColor: kTransparentColor,
    )..show(context);
  }

  static showSuccessFlushbar(BuildContext context, String message) {
    return Flushbar(
      messageText: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: kWhiteColor),
      ),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(10),
      backgroundColor: kSuccessMessageBackgroundColor,
      icon: Icon(Icons.verified_user_rounded, size: 20.sp, color: kSuccessIconColor),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: const Duration(seconds: 3),
      leftBarIndicatorColor: kTransparentColor,
    )..show(context);
  }
}
