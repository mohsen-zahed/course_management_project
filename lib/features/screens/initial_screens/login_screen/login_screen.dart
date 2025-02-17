import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/config/constants/images_paths.dart';
import 'package:course_management_project/features/data/blocs/auth_bloc/auth_bloc.dart';
import 'package:course_management_project/features/screens/initial_screens/login_screen/notifiers/login_notifiers.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/home_screen.dart';
import 'package:course_management_project/packages/flushbar_package/flushbar_package.dart';
import 'package:course_management_project/packages/dio_package/status_codes.dart';
import 'package:course_management_project/utils/app_theme.dart';
import 'package:course_management_project/widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  static const String id = '/login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    LoginNotifiers.showPasswordValueNotifier = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _formKey.currentState?.dispose();
    LoginNotifiers.showPasswordValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(sizeConstants.radiusXLarge),
                  bottomRight: Radius.circular(sizeConstants.radiusXLarge),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.blue[300]!,
                    Colors.green[300]!,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'appIcon',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            ImagesPaths.tawanaWhiteLogoJpg,
                            height: sizeConstants.imageLarge,
                          ),
                        ),
                      ),
                      SizedBox(height: sizeConstants.buttonHeightSmall),
                      Text(
                        'ورود به برنامه',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12.0.h),
                      Text(
                        'برای ادامه لطفا وارد حساب کاربری خود شوید!',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    prefixIcon: Icons.email,
                    suffixIcon: Icons.alternate_email_rounded,
                    hintText: 'ایمیل آدرس',
                    controller: _emailController,
                    showPassword: false,
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                      _emailController.text = value;
                    },
                    keyboardInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  ValueListenableBuilder(
                    valueListenable: LoginNotifiers.showPasswordValueNotifier,
                    builder: (context, showPassword, child) {
                      return CustomTextField(
                        prefixIcon: Icons.lock,
                        suffixIcon: Icons.remove_red_eye,
                        showPassword: showPassword,
                        controller: _passwordController,
                        onSuffixIconTap: () {
                          LoginNotifiers.showPasswordValueNotifier.value =
                              !LoginNotifiers.showPasswordValueNotifier.value;
                        },
                        hintText: 'رمز عبور',
                        onChanged: (value) {
                          _formKey.currentState?.validate();
                          _passwordController.text = value;
                        },
                      );
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) async {
                      if (state is AuthInitial) {
                      } else if (state is AuthSuccess) {
                        FlushbarPackage.showSuccessFlushbar(context, 'شما موفقانه وارد حساب خود شدید!');
                        Future.delayed(const Duration(seconds: 2), () {
                          _emailController.clear();
                          _passwordController.clear();
                          Navigator.pushNamed(context, HomeScreen.id);
                        });
                      } else if (state is AuthFailure) {
                        if (state.errorMessage.contains(StatusCodes.unAthurizedCode)) {
                          FlushbarPackage.showErrorFlushbar(
                              context, 'ایمیل یا رمز عبور درست نمیباشد، دوباره امتحان کنید!');
                        } else {
                          FlushbarPackage.showErrorFlushbar(context, state.errorMessage);
                        }
                      }
                    },
                    builder: (context, state) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: sizeConstants.buttonHeightLarge,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            enableFeedback: true,
                            shape:
                                WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                            backgroundColor: const WidgetStatePropertyAll(kBlueColor),
                            elevation: const WidgetStatePropertyAll(5),
                            foregroundColor: const WidgetStatePropertyAll(kWhiteColor),
                          ),
                          onPressed: state is! AuthenticatingUser
                              ? () {
                                  if (_emailController.text.toString().trim().isEmpty) {
                                    HapticFeedback.heavyImpact();
                                    FlushbarPackage.showErrorFlushbar(context, 'ایمیل را وارد کنید!');
                                  } else if (!_emailController.text.toString().trim().endsWith('@gmail.com')) {
                                    HapticFeedback.heavyImpact();
                                    FlushbarPackage.showErrorFlushbar(context, 'ایمیل معتبر نمیباشد');
                                  } else if (_passwordController.text.toString().trim().isEmpty) {
                                    HapticFeedback.heavyImpact();
                                    FlushbarPackage.showErrorFlushbar(context, 'رمز عبور را وارد کنید');
                                  } else {
                                    context.read<AuthBloc>().add(
                                          LoginRequested(
                                            email: _emailController.text.toString().trim(),
                                            password: _passwordController.text.toString().trim(),
                                          ),
                                        );
                                  }
                                }
                              : () {
                                  HapticFeedback.heavyImpact();
                                },
                          child: state is AuthenticatingUser
                              ? const CupertinoActivityIndicator(color: kWhiteColor)
                              : Text(
                                  'ورود',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
