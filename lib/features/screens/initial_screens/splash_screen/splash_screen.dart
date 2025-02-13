import 'package:course_management_project/config/constants/images_paths.dart';
import 'package:course_management_project/features/screens/initial_screens/login_screen/login_screen.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/home_screen.dart';
import 'package:course_management_project/packages/flutter_secure_storage_package/flutter_secure_storage_const.dart';
import 'package:course_management_project/packages/flutter_secure_storage_package/flutter_secure_storage_package.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String id = '/splash_screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      _isUserLogin();
    });
  }

  _isUserLogin() async {
    try {
      final accessToken = await FlutterSecureStoragePackage.fetchFromSecureStorage(accessTokenStorageKey);
      if (accessToken == null || accessToken.isEmpty) {
        Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
      }
    } catch (e) {
      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'appIcon',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(ImagesPaths.tawanaWhiteLogoJpg, height: 150),
                ),
              ),
              const SizedBox(height: 50),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(strokeWidth: 2),
                  SizedBox(height: 8),
                  Text('در حال بارگیری...'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
