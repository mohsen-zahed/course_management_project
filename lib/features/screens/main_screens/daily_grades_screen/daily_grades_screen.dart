import 'package:course_management_project/features/data/blocs/student_details_bloc/student_details_bloc.dart';
import 'package:course_management_project/features/data/models/daily_grade_model.dart';
import 'package:course_management_project/features/data/providers/daily_grades_provider.dart';
import 'package:course_management_project/features/screens/initial_screens/login_screen/login_screen.dart';
import 'package:course_management_project/features/screens/main_screens/daily_grades_screen/widgets/daily_grade_info_card.dart';
import 'package:course_management_project/packages/dio_package/dio_package.dart';
import 'package:course_management_project/packages/dio_package/status_codes.dart';
import 'package:course_management_project/packages/flushbar_package/flushbar_package.dart';
import 'package:course_management_project/widgets/custom_empty_widget.dart';
import 'package:course_management_project/widgets/custom_error_widget.dart';
import 'package:course_management_project/widgets/custom_loading_indicator.dart';
import 'package:course_management_project/widgets/scaffold_background_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class DailyGradesScreen extends StatefulWidget {
  static const String id = '/daily_grades_screen';
  const DailyGradesScreen({super.key, required this.studentId, required this.type, required this.studentName});

  final int studentId;
  final String type;
  final String studentName;

  @override
  State<DailyGradesScreen> createState() => _DailyGradesScreenState();
}

class _DailyGradesScreenState extends State<DailyGradesScreen> {
  late ScrollController _scrollController;
  late VoidCallback _scrollListener;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollListener = () {
      if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
        if (StudentDetailsBloc.dailyGradesHasMore) {
          context.read<StudentDetailsBloc>().add(
                DailyGradeDetailsRequested(
                  studentId: widget.studentId,
                  type: widget.type,
                  page: StudentDetailsBloc.dailyGradesPage + 1,
                  hideLoading: true,
                ),
              );
        }
      }
    };
    _scrollController.addListener(_scrollListener);
    context.read<StudentDetailsBloc>().add(
          DailyGradeDetailsRequested(
            studentId: widget.studentId,
            type: widget.type,
            page: 1,
          ),
        );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentDetailsBloc, StudentDetailsState>(
      listener: (context, state) {
        if (state is DailyGradeFailure) {
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
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            if (state is StudentDetailsLoading && !cancelToken.isCancelled) {
              cancelToken.cancel();
            }
            context.read<DailyGradesProvider>().dailyGradesList.clear();
          },
          child: Scaffold(
            appBar: AppBar(title: Text('ارزیابی روزانه ${widget.studentName}')),
            body: Consumer<DailyGradesProvider>(
              builder: (context, dailyGradeProvider, child) {
                return ScaffoldBackgroundImage(
                  child: state is StudentDetailsLoading
                      ? const CustomLoadingIndicator()
                      : state is DailyGradesSuccess
                          ? state.dailyGradesList.isEmpty
                              ? const CustomEmptyWidget()
                              : RefreshIndicator(
                                  onRefresh: () async {
                                    context.read<StudentDetailsBloc>().add(
                                          DailyGradeDetailsRequested(
                                            studentId: widget.studentId,
                                            type: widget.type,
                                            page: 1,
                                          ),
                                        );
                                  },
                                  child: ListView.separated(
                                    controller: _scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: dailyGradeProvider.dailyGradesList.length + 1,
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                    itemBuilder: (context, index) {
                                      if (index < dailyGradeProvider.dailyGradesList.length) {
                                        DailyGradeModel dailyGradeModel = dailyGradeProvider.dailyGradesList[index];
                                        String studentName = dailyGradeModel.name;
                                        String lastName = dailyGradeModel.lastName;
                                        return DailyGradeInfoCard(
                                          index: index,
                                          studentName: studentName,
                                          lastName: lastName,
                                          dailyGradeModel: dailyGradeModel,
                                        );
                                      } else if (StudentDetailsBloc.dailyGradesHasMore &&
                                          index == dailyGradeProvider.dailyGradesList.length &&
                                          dailyGradeProvider.dailyGradesList.length >= 30) {
                                        return const CustomLoadingIndicator();
                                      }
                                      return SizedBox.fromSize(size: Size.zero);
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(height: 15);
                                    },
                                  ),
                                )
                          : CustomErrorWidget(
                              onTap: () {
                                context.read<StudentDetailsBloc>().add(
                                      DailyGradeDetailsRequested(
                                        studentId: widget.studentId,
                                        type: widget.type,
                                        page: 1,
                                      ),
                                    );
                              },
                            ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
