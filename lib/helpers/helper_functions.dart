import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/packages/flutter_secure_storage_package/flutter_secure_storage_const.dart';
import 'package:course_management_project/packages/flutter_secure_storage_package/flutter_secure_storage_package.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HelperFunctions {
  HelperFunctions._();

  static showSnackBar({required BuildContext context, required String message, int? durationInSec}) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            showCloseIcon: true,
            duration: Duration(seconds: durationInSec ?? 4),
            content: Text(message, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kWhiteColor)),
          ),
        );
    }
  }

  static Future<String> extractTokenId() async {
    final token = await FlutterSecureStoragePackage.fetchFromSecureStorage(accessTokenStorageKey) ?? '';
    List<String> parts = token.split('|');
    return parts[0];
  }

  static String formatCurrencyAfghani(double amount) {
    // Check if the number is a whole number (no decimals)
    bool isWholeNumber = amount == amount.toInt();

    // Set the number format pattern
    final numberFormat = NumberFormat(isWholeNumber ? "#,###" : "#,###.##", "en_US");
    return numberFormat.format(amount);
  }
}
