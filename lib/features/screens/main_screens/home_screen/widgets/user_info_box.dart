import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/config/constants/images_paths.dart';
import 'package:course_management_project/features/data/blocs/auth_bloc/auth_bloc.dart';
import 'package:course_management_project/features/data/providers/user_provider.dart';
import 'package:course_management_project/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class UserInfoBox extends StatelessWidget {
  const UserInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {},
        builder: (context, state) {
          return Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: sizeConstants.imageMedium,
                    height: sizeConstants.imageMedium,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kBlueColor),
                      image: const DecorationImage(
                        image: AssetImage(ImagesPaths.profileDemoJpeg),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    userProvider.userModel!.name,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    userProvider.userModel!.email,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    height: sizeConstants.buttonHeightSmall,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kRedColor.withOpacity(0.1),
                    ),
                    child: TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              LogoutRequested(id: context.read<UserProvider>().userModel!.id),
                            );
                      },
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      ),
                      child: state is LoggingOut
                          ? const CupertinoActivityIndicator()
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'خروج از حساب',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: kRedColor, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 7),
                                Icon(Icons.logout, color: kRedColor, size: 15.sp),
                              ],
                            ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
