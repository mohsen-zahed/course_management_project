import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/config/constants/images_paths.dart';
import 'package:course_management_project/features/data/providers/internet_provider.dart';
import 'package:course_management_project/features/screens/initial_screens/splash_screen/splash_screen.dart';
import 'package:course_management_project/packages/flushbar_package/flushbar_package.dart';
import 'package:course_management_project/utils/app_theme.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class NoInternetScreen extends StatelessWidget {
  static const String id = '/no_internet_screen';
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<InternetProvider>(
        builder: (context, internetProvider, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SvgPicture.asset(
                    ImagesPaths.noConnectionSvg,
                    width: getMediaQueryWidth(context, 0.8),
                    height: sizeConstants.imageXXLarge,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.wifi_off_rounded, color: kBlueColor, size: sizeConstants.iconLarge);
                    },
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.w),
                  child: Text(
                    'برای استفاده از برنامه، ابتدا از اتصال خود به اینترنت مطمئن شوید!',
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 70),
                Container(
                  width: getMediaQueryWidth(context, 0.7),
                  height: sizeConstants.buttonHeightMedium,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!internetProvider.isChecking) {
                        await context.read<InternetProvider>().checkConnection().whenComplete(() {
                          if (internetProvider.isConnected) {
                            Navigator.pushNamedAndRemoveUntil(context, SplashScreen.id, (route) => false);
                          } else {
                            FlushbarPackage.showErrorFlushbar(context, 'خطا در اتصال، دوباره امتحان کنید!');
                          }
                        });
                      } else {
                        await HapticFeedback.heavyImpact();
                      }
                    },
                    child: internetProvider.isChecking
                        ? const CupertinoActivityIndicator(color: kWhiteColor)
                        : const Text('تلاش دوباره'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
