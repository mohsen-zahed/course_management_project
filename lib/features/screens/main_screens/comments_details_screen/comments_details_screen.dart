import 'package:course_management_project/features/data/blocs/student_details_bloc/student_details_bloc.dart';
import 'package:course_management_project/features/screens/initial_screens/login_screen/login_screen.dart';
import 'package:course_management_project/features/screens/main_screens/comments_details_screen/widgets/comments_card.dart';
import 'package:course_management_project/helpers/date_formatters.dart';
import 'package:course_management_project/packages/dio_package/status_codes.dart';
import 'package:course_management_project/packages/flushbar_package/flushbar_package.dart';
import 'package:course_management_project/widgets/custom_empty_widget.dart';
import 'package:course_management_project/widgets/custom_error_widget.dart';
import 'package:course_management_project/widgets/custom_loading_indicator.dart';
import 'package:course_management_project/widgets/scaffold_background_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentsDetailsScreen extends StatefulWidget {
  static const String id = '/comments_screen';
  const CommentsDetailsScreen({super.key, required this.studentId, required this.type, required this.studentName});

  final int studentId;
  final String type;
  final String studentName;

  @override
  State<CommentsDetailsScreen> createState() => _CommentsDetailsScreenState();
}

class _CommentsDetailsScreenState extends State<CommentsDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StudentDetailsBloc>().add(
          CommentsDetailsRequested(studentId: widget.studentId, type: widget.type),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('نظریات')),
      body: ScaffoldBackgroundImage(
        child: BlocConsumer<StudentDetailsBloc, StudentDetailsState>(
          listener: (context, state) {
            if (state is CommentsFailure) {
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
            } else if (state is CommentsSuccess && state.commentsList.isEmpty) {
              return const CustomEmptyWidget();
            } else if (state is CommentsSuccess) {
              return ListView.separated(
                itemCount: state.commentsList.length,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                itemBuilder: (context, index) {
                  final commentModel = state.commentsList[index];
                  return CommentCard(
                    date: DateFormatters.convertToShamsiWithDayName(commentModel.date),
                    description: commentModel.comment,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
              );
            } else if (state is CommentsFailure && state.errorMessage.contains(StatusCodes.noInternetConnectionCode)) {
              return CustomNoWifiWidget(
                onTap: () {
                  context.read<StudentDetailsBloc>().add(
                        CommentsDetailsRequested(studentId: widget.studentId, type: widget.type),
                      );
                },
              );
            } else {
              return CustomErrorWidget(
                onTap: () {
                  context.read<StudentDetailsBloc>().add(
                        CommentsDetailsRequested(studentId: widget.studentId, type: widget.type),
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
