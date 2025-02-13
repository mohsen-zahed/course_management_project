import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/features/data/blocs/student_details_bloc/student_details_bloc.dart';
import 'package:course_management_project/features/data/models/attendance_model.dart';
import 'package:course_management_project/features/data/providers/attendance_provider.dart';
import 'package:course_management_project/features/screens/initial_screens/login_screen/login_screen.dart';
import 'package:course_management_project/features/screens/main_screens/attendance_details_screen/notifiers/attendance_notifiers.dart';
import 'package:course_management_project/helpers/date_formatters.dart';
import 'package:course_management_project/helpers/theme_helpers.dart';
import 'package:course_management_project/packages/dio_package/dio_package.dart';
import 'package:course_management_project/packages/flushbar_package/flushbar_package.dart';
import 'package:course_management_project/packages/dio_package/status_codes.dart';
import 'package:course_management_project/utils/app_theme.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:course_management_project/widgets/custom_empty_widget.dart';
import 'package:course_management_project/widgets/custom_error_widget.dart';
import 'package:course_management_project/widgets/custom_expansion_tile.dart';
import 'package:course_management_project/widgets/custom_loading_indicator.dart';
import 'package:course_management_project/widgets/scaffold_background_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AttendanceDetailsScreen extends StatefulWidget {
  static const String id = '/attendance_screen';
  const AttendanceDetailsScreen({super.key, required this.studentId, required this.studentName, required this.timeId});

  final int studentId;
  final String studentName;
  final int timeId;

  @override
  State<AttendanceDetailsScreen> createState() => _AttendanceDetailsScreenState();
}

class _AttendanceDetailsScreenState extends State<AttendanceDetailsScreen> {
  late ScrollController _scrollController;
  late VoidCallback _scrollListener;
  late String searchQuery;
  @override
  void initState() {
    super.initState();
    AttendanceNotifiers.filterValueNotifier = ValueNotifier(null);
    _scrollController = ScrollController();
    _scrollListener = () {
      if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
        if (StudentDetailsBloc.attendanceHasMore) {
          context.read<StudentDetailsBloc>().add(
                AttendanceDetailsRequested(
                  studentId: widget.studentId,
                  timeId: widget.timeId,
                  page: StudentDetailsBloc.attendancePage + 1,
                  hideLoading: true,
                ),
              );
        }
      }
    };
    _scrollController.addListener(_scrollListener);
    context.read<StudentDetailsBloc>().add(
          AttendanceDetailsRequested(studentId: widget.studentId, timeId: widget.timeId, page: 1),
        );
  }

  @override
  void dispose() {
    AttendanceNotifiers.filterValueNotifier.dispose();
    _scrollController.dispose();
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentDetailsBloc, StudentDetailsState>(
      listener: (context, state) {
        if (state is AttendanceFailure) {
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
        List<Map<String, dynamic>> attendanceStatusList = [
          {
            'title': 'حاضر',
            'color': kGreenColor.withOpacity(0.6),
            'isSelected': false,
          },
          {
            'title': 'اجازه',
            'color': kBlueCustomColor.withOpacity(0.6),
            'isSelected': false,
          },
          {
            'title': 'رخصتی',
            'color': kOrangeColor.withOpacity(0.6),
            'isSelected': false,
          },
          {
            'title': 'جمعه',
            'color': kRedColor.withOpacity(0.6),
            'isSelected': false,
          },
        ];
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            if (state is StudentDetailsLoading && !cancelToken.isCancelled) {
              cancelToken.cancel();
            }
            context.read<AttendanceProvider>().attendanceList.clear();
          },
          child: Scaffold(
            appBar: AppBar(title: Text('حاضری ${widget.studentName}')),
            body: Consumer<AttendanceProvider>(
              builder: (context, attendanceProvider, child) {
                return ScaffoldBackgroundImage(
                  child: state is StudentDetailsLoading
                      ? const CustomLoadingIndicator()
                      : state is AttendanceSuccess && attendanceProvider.attendanceList.isEmpty
                          ? const CustomEmptyWidget()
                          : state is AttendanceSuccess
                              ? RefreshIndicator(
                                  onRefresh: () async {
                                    context.read<StudentDetailsBloc>().add(
                                          AttendanceDetailsRequested(
                                              studentId: widget.studentId, timeId: widget.timeId, page: 1),
                                        );
                                  },
                                  child: Stack(
                                    children: [
                                      ValueListenableBuilder(
                                        valueListenable: AttendanceNotifiers.filterValueNotifier,
                                        builder: (context, filterNotifier, child) {
                                          List<AttendanceModel> sortedList = attendanceProvider.attendanceList;
                                          if (filterNotifier != null) {
                                            if (filterNotifier == 'جمعه') {
                                              sortedList = List.from(
                                                attendanceProvider.attendanceList.where(
                                                  (element) {
                                                    return DateFormatters.convertToShamsiWithDayName(element.date)
                                                        .contains('جمعه');
                                                  },
                                                ),
                                              );
                                            } else if (filterNotifier == 'رخصتی') {
                                              sortedList = List.from(
                                                attendanceProvider.attendanceList.where((element) =>
                                                    _getPresentStatus(element.status.trim()) == filterNotifier &&
                                                    !DateFormatters.convertToShamsiWithDayName(element.date)
                                                        .contains('جمعه')),
                                              );
                                            } else {
                                              sortedList = List.from(
                                                attendanceProvider.attendanceList.where((element) =>
                                                    _getPresentStatus(element.status.trim()) == filterNotifier),
                                              );
                                            }
                                          }
                                          return ListView.builder(
                                            controller: _scrollController,
                                            itemCount: sortedList.length + 1,
                                            padding: EdgeInsets.fromLTRB(0, sizeConstants.buttonHeightLarge, 0, 10),
                                            physics: const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              // Ensure that we are checking for the range of the loaded items.
                                              if (index < sortedList.length) {
                                                // Format the date
                                                String date =
                                                    DateFormatters.convertToShamsiWithDayName(sortedList[index].date);

                                                // Return the list item for the current attendance record.
                                                return CustomExpansionTile(
                                                  index: index,
                                                  backgroundColor: date.contains('جمعه')
                                                      ? isThemeLight(context)
                                                          ? kRedCustom1Color
                                                          : const Color.fromARGB(178, 99, 50, 47)
                                                      : null,
                                                  title: '$date\n${_getPresentStatus(sortedList[index].status)}',
                                                  subTitle: sortedList[index].bookName,
                                                  trailing: Container(
                                                    width: 55,
                                                    height: getMediaQueryHeight(context),
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: date.contains('جمعه')
                                                          ? kRedColor.withOpacity(0.2)
                                                          : _getPresentStatusColor(sortedList[index].status, context)
                                                              .withOpacity(0.6),
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: const Text(''),
                                                  ),
                                                  onTap: () {},
                                                );
                                              } else {
                                                // Check if more data is available to load and show the loading indicator once at the bottom
                                                if (StudentDetailsBloc.attendanceHasMore &&
                                                    index == sortedList.length &&
                                                    sortedList.length >= 30) {
                                                  return const CustomLoadingIndicator(); // Show loading indicator only once at the bottom
                                                }
                                                return SizedBox.fromSize(size: Size.zero);
                                              }
                                            },
                                          );
                                        },
                                      ),
                                      Positioned(
                                        child: ValueListenableBuilder(
                                          valueListenable: AttendanceNotifiers.filterValueNotifier,
                                          builder: (context, filterNotifier, child) {
                                            return Container(
                                              width: getMediaQueryWidth(context),
                                              height: 50.h,
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              alignment: AlignmentDirectional.center,
                                              decoration: BoxDecoration(
                                                color: isThemeLight(context) ? kWhiteColor : kGreyColor700,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    offset: Offset(0, 0),
                                                    spreadRadius: 3,
                                                    blurRadius: 5,
                                                    color: kBlackColor12,
                                                  ),
                                                ],
                                              ),
                                              child: ListView.separated(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.horizontal,
                                                itemCount: filterNotifier != null
                                                    ? attendanceStatusList.length + 1
                                                    : attendanceStatusList.length,
                                                itemBuilder: (context, index) {
                                                  return index < attendanceStatusList.length
                                                      ? AttendanceLegendBox(
                                                          isSelected:
                                                              filterNotifier == attendanceStatusList[index]['title'],
                                                          onTap: () {
                                                            AttendanceNotifiers.filterValueNotifier.value =
                                                                attendanceStatusList[index]['title'];
                                                          },
                                                          title: attendanceStatusList[index]['title'],
                                                          color: attendanceStatusList[index]['color'],
                                                        )
                                                      : InkWell(
                                                          onTap: () {
                                                            AttendanceNotifiers.filterValueNotifier.value = null;
                                                          },
                                                          child: const Icon(Icons.delete_sweep, color: kRedColor),
                                                        );
                                                },
                                                separatorBuilder: (context, index) {
                                                  return SizedBox(width: filterNotifier != null ? 10 : 20);
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : (state is AttendanceFailure &&
                                      state.errorMessage.contains(StatusCodes.noInternetConnectionCode)
                                  ? CustomNoWifiWidget(
                                      onTap: () {
                                        context.read<StudentDetailsBloc>().add(
                                              AttendanceDetailsRequested(
                                                studentId: widget.studentId,
                                                timeId: widget.timeId,
                                                page: 1,
                                              ),
                                            );
                                      },
                                    )
                                  : CustomErrorWidget(
                                      onTap: () {
                                        context.read<StudentDetailsBloc>().add(
                                              AttendanceDetailsRequested(
                                                studentId: widget.studentId,
                                                timeId: widget.timeId,
                                                page: 1,
                                              ),
                                            );
                                      },
                                    )),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Text(
  //     date.contains('جمعه') ? 'رخصت' : _getPresentStatus(state.attendanceList[index].status),
  //     style: Theme.of(context).textTheme.bodyMedium!.copyWith(
  //           fontWeight: FontWeight.bold,
  //           color: date.contains('جمعه')
  //               ? kRedColor
  //               : _getPresentStatusColor(state.attendanceList[index].status, context),
  //         ),
  //   ),

  _getPresentStatus(String presentStatus) {
    switch (presentStatus) {
      case 'present':
        return 'حاضر';
      case 'sick':
        return 'اجازه';
      case 'absent':
        return 'غیر حاضر';
      case 'leave':
        return 'رخصتی';
      default:
        return presentStatus;
    }
  }

  Color _getPresentStatusColor(String presentStatus, BuildContext context) {
    switch (presentStatus) {
      case 'present':
        return kGreenColor;
      case 'sick':
        return kBlueColor1;
      case 'absent':
        return kRedColor;
      case 'leave':
        return kOrangeColor;
      default:
        return isThemeLight(context) ? kBlackColor87 : kWhiteColor;
    }
  }
}

class AttendanceLegendBox extends StatelessWidget {
  const AttendanceLegendBox({
    super.key,
    required this.title,
    required this.color,
    required this.onTap,
    this.isSelected,
  });
  final String title;
  final Color color;
  final VoidCallback onTap;
  final bool? isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected != null && isSelected == true ? color : kTransparentColor,
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kWhiteColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
