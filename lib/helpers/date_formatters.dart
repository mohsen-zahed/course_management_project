import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

class DateFormatters {
  const DateFormatters._();
  static String convertToShamsiWithDayName(String gregorianDate, {bool? hideDay = false, bool? replaceSymbol}) {
    try {
      final simplifiedDate = gregorianDate.split(RegExp('T'))[0];
      final normalizedDate = simplifiedDate.replaceAll(RegExp(r'[-/.]'), ' ').trim();
      final parts = normalizedDate.split(' ');

      if (parts.length != 3) {
        debugPrint('Error While Converting Date!');
        return gregorianDate;
      }

      final int year = int.parse(parts[0]);
      final int month = int.parse(parts[1]);
      final int day = int.parse(parts[2]);

      // Validate the Persian date
      if (!_isValidPersianDate(year, month, day)) {
        debugPrint('Invalid Persian Date!');
        return gregorianDate; // You can return an error string or the original date
      }

      final Gregorian gregorian = Gregorian(year, month, day);
      final Jalali jalaliDate = gregorian.toJalali();

      // Get the day of the week (0=Saturday, 1=Sunday, ..., 6=Friday)
      final int weekDay = jalaliDate.weekDay;

      // Get the corresponding Persian day name
      String weekDayName = '';
      switch (weekDay) {
        case 1:
          weekDayName = 'شنبه'; // Saturday
          break;
        case 2:
          weekDayName = 'یکشنبه'; // Sunday
          break;
        case 3:
          weekDayName = 'دوشنبه'; // Monday
          break;
        case 4:
          weekDayName = 'سه‌شنبه'; // Tuesday
          break;
        case 5:
          weekDayName = 'چهارشنبه'; // Wednesday
          break;
        case 6:
          weekDayName = 'پنج‌شنبه'; // Thursday
          break;
        case 7:
          weekDayName = 'جمعه'; // Friday
          break;
        default:
          weekDayName = ''; // None
      }

      // // Map the month number to the Persian month name
      // String monthName = '';
      // switch (month) {
      //   case 1:
      //     monthName = 'حمل'; // Farvardin
      //     break;
      //   case 2:
      //     monthName = 'ثور'; // Ordibehesht
      //     break;
      //   case 3:
      //     monthName = 'جوزا'; // Khordad
      //     break;
      //   case 4:
      //     monthName = 'سرطان'; // Tir
      //     break;
      //   case 5:
      //     monthName = 'اسد'; // Mordad
      //     break;
      //   case 6:
      //     monthName = 'سنبله'; // Shahrivar
      //     break;
      //   case 7:
      //     monthName = 'میزان'; // Mehr
      //     break;
      //   case 8:
      //     monthName = 'عقرب'; // Aban
      //     break;
      //   case 9:
      //     monthName = 'قوس'; // Azar
      //     break;
      //   case 10:
      //     monthName = 'جدی'; // Dey
      //     break;
      //   case 11:
      //     monthName = 'دلو'; // Bahman
      //     break;
      //   case 12:
      //     monthName = 'حوت'; // Esfand
      //     break;
      //   default:
      //     monthName = '';
      // }

      // Return the formatted Shamsi date along with the day name
      if (hideDay == true) {
        return '${jalaliDate.year}/${jalaliDate.month.toString().padLeft(2, '0')}/${jalaliDate.day.toString().padLeft(2, '0')}';
      }
      return '$weekDayName - ${jalaliDate.year}/${jalaliDate.month.toString().padLeft(2, '0')}/${jalaliDate.day.toString().padLeft(2, '0')}';
    } catch (e) {
      debugPrint(e.toString());
      return gregorianDate;
    }
  }

// Helper function to validate Persian date
  static bool _isValidPersianDate(int year, int month, int day) {
    // Check if the month is valid (1-12)
    if (month < 1 || month > 12) return false;

    // Days per month for the Persian calendar
    final daysInMonth = {
      1: 31, 2: 31, 3: 31, 4: 31, 5: 31, 6: 31,
      7: 30, 8: 30, 9: 30, 10: 30, 11: 30, 12: 29 // Esfand (12th month) has 29 days in non-leap years
    };

    // Check if the day is valid for the given month
    if (day < 1 || day > daysInMonth[month]!) {
      return false;
    }

    return true;
  }

  static calculateDateRangeFromShamsiString(String dateToCompareStr) {
    try {
      // Split the string into year, month, and day components
      List<String> dateParts = dateToCompareStr.split('/');

      // Ensure the string is in the correct format (yyyy-MM-dd)
      if (dateParts.length != 3) {
        return 'Invalid Shamsi date format';
      }

      // Parse the components into integers
      int year = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int day = int.parse(dateParts[2]);

      // Create a Jalali (Shamsi) date object
      Jalali jalaliDate = Jalali(year, month, day);

      // Convert the Jalali (Shamsi) date to a Gregorian DateTime object
      DateTime dateToCompare = jalaliDate.toDateTime();

      // Get the current date (Gregorian)
      DateTime today = DateTime.now();

      // Calculate the difference in days
      Duration difference = today.difference(dateToCompare);

      // Return the difference in days with 'd' suffix
      if (difference.inDays == 0) {
        return 'امروز';
      } else {
        return '${difference.inDays.abs()}d';
      }
    } catch (e) {
      // Catch any errors (like invalid date format or parsing issues)
      return 'Invalid Shamsi date format';
    }
  }
}

List<String> daysOfWeek = [
  'شنبه',
  'یکشنبه',
  'دوشنبه',
  'سه شنبه',
  'چهار شنبه',
  'پنجشنبه',
  'جمعه',
];
