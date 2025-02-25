import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData lightTheme(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: kWhiteColor,
    textTheme: getLightTextTheme(context),
    brightness: Brightness.light,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(kBlueColor),
        foregroundColor: const WidgetStatePropertyAll(kWhiteColor),
        textStyle: WidgetStatePropertyAll(
          Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: kWhiteColor),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: kWhiteColor,
      elevation: 10,
      shadowColor: kBlackColor26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      actionsPadding: const EdgeInsets.only(bottom: 10, left: 10),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        textStyle: WidgetStatePropertyAll(
          Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: kBlueCustomColor,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: const IconThemeData(color: kWhiteColor),
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: sizeConstants.titleMedium, fontWeight: FontWeight.bold, color: kWhiteColor),
    ),
    dialogBackgroundColor: kWhiteColor,
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: kWhiteColor),
    listTileTheme: const ListTileThemeData(iconColor: kBlackColor),
    iconTheme: const IconThemeData(color: kBlackColor),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: kWhiteColor,
      contentTextStyle: TextStyle(color: kBlackColor),
      showCloseIcon: true,
      closeIconColor: kBlackColor,
    ),
    // listTileTheme: const ListTileThemeData(
    //   tileColor: kTransparentColor,
    // ),
  );
}

ThemeData darkTheme(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: kGreyColor800,
    brightness: Brightness.dark,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    dialogTheme: DialogTheme(
      backgroundColor: kGreyColor900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      actionsPadding: const EdgeInsets.only(bottom: 10, left: 10),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(kBlueColor),
        foregroundColor: const WidgetStatePropertyAll(kWhiteColor),
        textStyle: WidgetStatePropertyAll(
          Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: kWhiteColor),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        textStyle: WidgetStatePropertyAll(
          Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: kGreyColor700,
      elevation: 10,
      shadowColor: kGreyColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: kBlueCustomColor,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: const IconThemeData(color: kWhiteColor),
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: sizeConstants.titleMedium, fontWeight: FontWeight.bold, color: kWhiteColor),
    ),
    dialogBackgroundColor: kGreyColor800,
    listTileTheme: const ListTileThemeData(iconColor: kWhiteColor),
    textTheme: getDarkTextTheme(context),
    iconTheme: const IconThemeData(color: kWhiteColor),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: kGreyColor800),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: kGreyColor800,
      contentTextStyle: const TextStyle(color: kWhiteColor),
      showCloseIcon: true,
      closeIconColor: kWhiteColor,
    ),
  );
}

getLightTextTheme(BuildContext context) {
  return TextTheme(
    bodySmall: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: kBlackColor,
          fontSize: sizeConstants.bodySmall,
        ),
    bodyMedium: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: kBlackColor,
          fontSize: sizeConstants.bodyMedium,
        ),
    bodyLarge: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: kBlackColor,
          fontSize: sizeConstants.bodyLarge,
        ),
    displaySmall: Theme.of(context).textTheme.displaySmall!.copyWith(
          color: kBlackColor,
          fontSize: sizeConstants.displaySmall,
        ),
    displayMedium: Theme.of(context).textTheme.displayMedium!.copyWith(
          color: kBlackColor,
          fontSize: sizeConstants.displayMedium,
        ),
    displayLarge: Theme.of(context).textTheme.displayLarge!.copyWith(
          color: kBlackColor,
          fontSize: sizeConstants.displayLarge,
        ),
    headlineSmall: Theme.of(context).textTheme.headlineSmall!.copyWith(
          color: kBlackColor,
          fontSize: sizeConstants.headlineSmall,
        ),
    headlineMedium: Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: kBlackColor,
          fontSize: sizeConstants.headlineMedium,
        ),
    headlineLarge: Theme.of(context).textTheme.headlineLarge!.copyWith(
          color: kBlackColor,
          fontSize: sizeConstants.headlineLarge,
        ),
    labelSmall: Theme.of(context).textTheme.labelSmall!.copyWith(
          color: kBlackColor,
          fontSize: sizeConstants.labelSmall,
        ),
    labelMedium: Theme.of(context).textTheme.labelMedium!.copyWith(
          color: kBlackColor,
          fontSize: sizeConstants.labelMedium,
        ),
    labelLarge: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: kBlackColor,
          fontSize: sizeConstants.labelLarge,
        ),
    titleSmall: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: kBlackColor,
          fontSize: sizeConstants.titleSmall,
        ),
    titleMedium: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: kBlackColor,
          fontSize: sizeConstants.titleMedium,
        ),
    titleLarge: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: kBlackColor,
          fontSize: sizeConstants.titleLarge,
        ),
  );
}

getDarkTextTheme(BuildContext context) {
  return TextTheme(
    bodySmall: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: kWhiteColor,
          fontSize: sizeConstants.bodySmall,
        ),
    bodyMedium: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: kWhiteColor,
          fontSize: sizeConstants.bodyMedium,
        ),
    bodyLarge: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: kWhiteColor,
          fontSize: sizeConstants.bodyLarge,
        ),
    displaySmall: Theme.of(context).textTheme.displaySmall!.copyWith(
          color: kWhiteColor,
          fontSize: sizeConstants.displaySmall,
        ),
    displayMedium: Theme.of(context).textTheme.displayMedium!.copyWith(
          color: kWhiteColor,
          fontSize: sizeConstants.displayMedium,
        ),
    displayLarge: Theme.of(context).textTheme.displayLarge!.copyWith(
          color: kWhiteColor,
          fontSize: sizeConstants.displayLarge,
        ),
    headlineSmall: Theme.of(context).textTheme.headlineSmall!.copyWith(
          color: kWhiteColor,
          fontSize: sizeConstants.headlineSmall,
        ),
    headlineMedium: Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: kWhiteColor,
          fontSize: sizeConstants.headlineMedium,
        ),
    headlineLarge: Theme.of(context).textTheme.headlineLarge!.copyWith(
          color: kWhiteColor,
          fontSize: sizeConstants.headlineLarge,
        ),
    labelSmall: Theme.of(context).textTheme.labelSmall!.copyWith(
          color: kWhiteColor,
          fontSize: sizeConstants.labelSmall,
        ),
    labelMedium: Theme.of(context).textTheme.labelMedium!.copyWith(
          color: kWhiteColor,
          fontSize: sizeConstants.labelMedium,
        ),
    labelLarge: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: kWhiteColor,
          fontSize: sizeConstants.labelLarge,
        ),
    titleSmall: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: kWhiteColor,
          fontSize: sizeConstants.titleSmall,
        ),
    titleMedium: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: kWhiteColor,
          fontSize: sizeConstants.titleMedium,
        ),
    titleLarge: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: kWhiteColor,
          fontSize: sizeConstants.titleLarge,
        ),
  );
}

class SizeConstants {
  // Spacing
  double spacingXXSmall = 4.0.w;
  double spacingXSmall = 8.0.w;
  double spacingSmall = 12.0.w;
  double spacingMedium = 16.0.w;
  double spacingLarge = 24.0.w;
  double spacingXLarge = 32.0.w;
  double spacingXXLarge = 48.0.w;

  // Border Radius
  double radiusXSmall = 4.0.r;
  double radiusSmall = 8.0.r;
  double radiusMedium = 12.0.r;
  double radiusLarge = 16.0.r;
  double radiusXLarge = 24.0.r;
  double radiusMax = 100.0.r;

  // Font Sizes
  double bodySmall = 12.0.sp;
  double bodyMedium = 14.0.sp;
  double bodyLarge = 16.0.sp;
  double displaySmall = 24.0.sp;
  double displayMedium = 26.0.sp;
  double displayLarge = 28.0.sp;
  double headlineSmall = 32.0.sp;
  double headlineMedium = 36.0.sp;
  double headlineLarge = 40.0.sp;
  double labelSmall = 9.0.sp;
  double labelMedium = 10.0.sp;
  double labelLarge = 11.0.sp;
  double titleSmall = 18.0.sp;
  double titleMedium = 20.0.sp;
  double titleLarge = 22.0.sp;

  // Icon Sizes
  double iconXSmall = 12.0.w;
  double iconSmall = 16.0.w;
  double iconMedium = 24.0.w;
  double iconLarge = 32.0.w;
  double iconXLarge = 48.0.w;

  // Button Sized
  double buttonHeightXSmall = 32.0.h;
  double buttonHeightSmall = 36.0.h;
  double buttonHeightMedium = 48.0.h;
  double buttonHeightLarge = 56.0.h;
  double buttonRadius = 16.0.r;

  // Image Sizes
  double imageXXSmall = 16.0.w;
  double imageXSmall = 32.0.w;
  double imageSmall = 48.0.w;
  // double imageSmallMedium = 60.0.w;
  double imageMedium = 100.0.w;
  double imageLarge = 150.0.w;
  double imageLargeMed = 170.0.w;
  double imageXLarge = 200.0.w;
  double imageXXLarge = 250.0.w;

  // Avatar Sizes
  double avatarXSmall = 40.0.w;
  double avatarSmall = 60.0.w;
  double avatarSmallMed = 70.0.w;
  double avatarMedium = 80.0.w;
  double avatarLarge = 120.0.w;
  double avatarXLarge = 150.0.w;
}

SizeConstants sizeConstants = SizeConstants();
