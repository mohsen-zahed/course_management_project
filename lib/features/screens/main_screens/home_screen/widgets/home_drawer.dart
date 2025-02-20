import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/config/constants/images_paths.dart';
import 'package:course_management_project/features/data/blocs/auth_bloc/auth_bloc.dart';
import 'package:course_management_project/features/data/providers/user_provider.dart';
import 'package:course_management_project/features/screens/initial_screens/login_screen/login_screen.dart';
import 'package:course_management_project/features/screens/main_screens/about_us_screen/about_us_screen.dart';
import 'package:course_management_project/features/screens/main_screens/latest_news_screen/latest_news_screen.dart';
import 'package:course_management_project/features/screens/main_screens/students_screen/students_screen.dart';
import 'package:course_management_project/packages/flushbar_package/flushbar_package.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:course_management_project/widgets/custom_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key, required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250.w,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: getMediaQueryWidth(context),
                height: 170.h,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImagesPaths.wallpaperJpg),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromARGB(150, 0, 0, 0), // Faded black (with alpha channel)
                        kTransparentColor,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // showDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       return const UserInfoBox();
                            //     });
                          },
                          child: CircleAvatar(
                            backgroundImage: const AssetImage(ImagesPaths.profileDemoJpeg),
                            radius: 36.w,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          context.read<UserProvider>().userModel!.name,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kWhiteColor),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          context.read<UserProvider>().userModel!.email,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kWhiteColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomListTile(
            leading: Icons.people_alt_rounded,
            tileColor: kBlueColor,
            title: 'خانه',
            onTap: () {
              if (scaffoldKey.currentState!.isDrawerOpen) {
                scaffoldKey.currentState!.closeDrawer();
              }
            },
          ),
          const SizedBox(height: 20),
          CustomListTile(
            leading: Icons.people_alt_rounded,
            tileColor: kBlueColor,
            title: 'لیست شاگردان',
            onTap: () {
              if (scaffoldKey.currentState!.isDrawerOpen) {
                scaffoldKey.currentState!.closeDrawer();
              }
              Navigator.pushNamed(context, StudentsScreen.id);
            },
          ),
          const SizedBox(height: 10),
          CustomListTile(
            leading: Icons.newspaper_rounded,
            tileColor: kBlueColor,
            title: 'آخرین اخبار',
            onTap: () {
              if (scaffoldKey.currentState!.isDrawerOpen) {
                scaffoldKey.currentState!.closeDrawer();
              }
              Navigator.pushNamed(context, LatestNewsScreen.id);
            },
          ),
          const SizedBox(height: 10),
          CustomListTile(
            leading: Icons.account_circle_outlined,
            tileColor: kBlueColor,
            title: 'درباره ما',
            onTap: () {
              if (scaffoldKey.currentState!.isDrawerOpen) {
                scaffoldKey.currentState!.closeDrawer();
              }
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUsScreen()));
            },
          ),
          const SizedBox(height: 30),
          CustomListTile(
            leading: Icons.logout_rounded,
            tileColor: kRedColor,
            title: 'خروج از حساب',
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthFailure) {
                          FlushbarPackage.showErrorFlushbar(context, 'خطایی در هنگام خروج از حساب رخ داده است!');
                        } else if (state is AuthSuccess) {
                          Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => true);
                        }
                      },
                      builder: (context, state) {
                        return AlertDialog(
                          content: Text(
                            'از حساب کاربری خود خارج میشوید؟',
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('خیر'),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () {
                                if (scaffoldKey.currentState!.isDrawerOpen) {
                                  scaffoldKey.currentState!.closeDrawer();
                                }
                                if (state is! LoggingOut) {
                                  context.read<AuthBloc>().add(
                                        LogoutRequested(id: context.read<UserProvider>().userModel!.id),
                                      );
                                } else {
                                  HapticFeedback.mediumImpact();
                                }
                              },
                              child: state is LoggingOut ? const CupertinoActivityIndicator() : const Text('بله'),
                            ),
                          ],
                        );
                      },
                    );
                  });
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
