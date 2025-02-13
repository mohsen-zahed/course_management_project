import 'package:course_management_project/packages/flushbar_package/flushbar_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitAppHandler {
  // Variables to keep track of back press count and times
  static int _backPressCount = 0;
  static DateTime _firstBackPressTime = DateTime.now();
  static const int _exitThresholdTimeInSeconds = 3; // Time threshold in seconds for double press

  // Function to handle back press
  static Future<void> handleExitApp(BuildContext context) async {
    final DateTime currentTime = DateTime.now();

    // Reset back press count if the time difference exceeds the threshold
    if (currentTime.difference(_firstBackPressTime).inSeconds > _exitThresholdTimeInSeconds) {
      _backPressCount = 0; // Reset back press count if the user takes too long
    }

    // If this is the first press
    if (_backPressCount == 0) {
      _firstBackPressTime = currentTime; // Record the time of the first press
      _backPressCount++; // Increment to track the first press

      return; // Don't exit the app yet, return early
    }
    if (_backPressCount == 1) {
      _firstBackPressTime = currentTime; // Record the time of the first press
      _backPressCount++; // Increment to track the first press
      // Show Snackbar (message will be on first press)
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('برای خروج از برنامه دوباره امتحان کنید!')));
      Future.delayed(const Duration(seconds: 2), () {
        _backPressCount = 0;
      });
      return; // Don't exit the app yet, return early
    }

    // If this is the second press within the allowed threshold time
    if (_backPressCount == 2 && currentTime.difference(_firstBackPressTime).inSeconds <= _exitThresholdTimeInSeconds) {
      _backPressCount++; // Increment to track the second press
      // Show Snackbar on second press
      FlushbarPackage.showFlushbar(context, 'خارج شدید!');
      SystemNavigator.pop();
      Future.delayed(const Duration(seconds: 2), () {
        _backPressCount = 0;
      });
      // Exit the app
    }
  }
}
