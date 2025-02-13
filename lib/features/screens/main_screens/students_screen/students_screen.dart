import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/features/data/blocs/home_bloc/home_bloc.dart';
import 'package:course_management_project/features/screens/initial_screens/login_screen/login_screen.dart';
import 'package:course_management_project/features/screens/main_screens/students_screen/widgets/student_box.dart';
import 'package:course_management_project/packages/dio_package/status_codes.dart';
import 'package:course_management_project/packages/flushbar_package/flushbar_package.dart';
import 'package:course_management_project/widgets/custom_empty_widget.dart';
import 'package:course_management_project/widgets/custom_loading_indicator.dart';
import 'package:course_management_project/widgets/scaffold_background_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentsScreen extends StatefulWidget {
  static const String id = '/students_screen';
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(StudentsListRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is StudentsListFailure) {
          if (state.errorMessage.contains(StatusCodes.unAthurizedCode)) {
            Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false);
            FlushbarPackage.showFlushbar(context, 'لطفا دوباره وارد حساب خود شوید!');
          } else if (state.errorMessage.contains(StatusCodes.noInternetConnectionCode)) {
            FlushbarPackage.showFlushbar(context, 'اتصال به اینترنت خود را چک کنید!');
          } else if (state.errorMessage.contains(StatusCodes.noServerFoundCode)) {
            FlushbarPackage.showFlushbar(context, 'خطایی از طرف سرور رخ داده است، دوباره امتحان کنید!');
          } else if (state.errorMessage.contains(StatusCodes.badStateCode)) {
            FlushbarPackage.showFlushbar(context, 'خطایی رخ داده است، دوباره امتحان کنید!');
          } else if (state.errorMessage.contains(StatusCodes.unknownCode)) {
            FlushbarPackage.showFlushbar(context, 'خطایی نامشخص رخ داده است، بعدا امتحان کنید!');
          } else {
            FlushbarPackage.showErrorFlushbar(context, state.errorMessage);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('لیست شاگردان')),
          body: ScaffoldBackgroundImage(
            child: BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {},
              builder: (context, state) {
                return state is HomeLoading
                    ? const CustomLoadingIndicator()
                    : state is StudentsListSuccess
                        ? state.studentsList.isEmpty
                            ? CustomEmptyWidget(
                                message: 'اطلاعاتی برای نمایش وجود ندارد!',
                                onTap: () {
                                  context.read<HomeBloc>().add(StudentsListRequested());
                                },
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                itemCount: state.studentsList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return StudentBox(studentModel: state.studentsList[index]);
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 10);
                                },
                              )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error, color: kRedColor, size: 120),
                              const SizedBox(height: 10),
                              Text('خطا در دریافت اطلاعات',
                                  style:
                                      Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    context.read<HomeBloc>().add(StudentsListRequested());
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('تلاش دوباره',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(fontWeight: FontWeight.w600)),
                                      const SizedBox(width: 5),
                                      const Icon(Icons.refresh, size: 18),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
              },
            ),
          ),
        );
      },
    );
  }
}
