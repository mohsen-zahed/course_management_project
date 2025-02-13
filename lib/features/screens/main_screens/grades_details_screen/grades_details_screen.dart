import 'package:course_management_project/features/data/blocs/student_details_bloc/student_details_bloc.dart';
import 'package:course_management_project/features/screens/initial_screens/login_screen/login_screen.dart';
import 'package:course_management_project/features/screens/main_screens/grades_details_screen/widgets/grades_info_card.dart';
import 'package:course_management_project/packages/flushbar_package/flushbar_package.dart';
import 'package:course_management_project/packages/dio_package/status_codes.dart';
import 'package:course_management_project/widgets/custom_empty_widget.dart';
import 'package:course_management_project/widgets/custom_error_widget.dart';
import 'package:course_management_project/widgets/custom_loading_indicator.dart';
import 'package:course_management_project/widgets/scaffold_background_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GradesDetailsScreen extends StatefulWidget {
  static const String id = '/grades_screen';
  const GradesDetailsScreen({super.key, required this.studentId, required this.type, required this.studentName});

  final int studentId;
  final String type;
  final String studentName;

  @override
  State<GradesDetailsScreen> createState() => _GradesDetailsScreenState();
}

class _GradesDetailsScreenState extends State<GradesDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StudentDetailsBloc>().add(
          GradesDetailsRequested(studentId: widget.studentId, type: widget.type),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('جزئیات نمرات ${widget.studentName}')),
      body: ScaffoldBackgroundImage(
        child: BlocConsumer<StudentDetailsBloc, StudentDetailsState>(
          listener: (context, state) {
            if (state is GradesFailure) {
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
            if (state is StudentDetailsLoading) {
              return const CustomLoadingIndicator();
            } else if (state is GradesSuccess) {
              return state.gradesList.isEmpty
                  ? const CustomEmptyWidget()
                  : RefreshIndicator(
                      onRefresh: () async {
                        context.read<StudentDetailsBloc>().add(
                              GradesDetailsRequested(studentId: widget.studentId, type: widget.type),
                            );
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        itemCount: state.gradesList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GradesInfoCard(
                            gradeModel: state.gradesList[index],
                            index: index,
                            lastName: state.gradesList[index].lastName,
                            studentName: state.gradesList[index].name,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 10);
                        },
                      ),
                    );
            } else {
              return CustomErrorWidget(
                onTap: () {
                  context.read<StudentDetailsBloc>().add(
                        GradesDetailsRequested(studentId: widget.studentId, type: widget.type),
                      );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
