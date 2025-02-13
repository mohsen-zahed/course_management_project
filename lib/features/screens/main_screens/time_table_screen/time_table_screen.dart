import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/features/data/blocs/time_table_bloc/time_table_bloc.dart';
import 'package:course_management_project/features/screens/main_screens/attendance_details_screen/attendance_details_screen.dart';
import 'package:course_management_project/helpers/color_helper.dart';
import 'package:course_management_project/helpers/date_formatters.dart';
import 'package:course_management_project/packages/flushbar_package/flushbar_package.dart';
import 'package:course_management_project/utils/app_theme.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:course_management_project/widgets/custom_empty_widget.dart';
import 'package:course_management_project/widgets/custom_error_widget.dart';
import 'package:course_management_project/widgets/custom_loading_indicator.dart';
import 'package:course_management_project/widgets/scaffold_background_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TimeTableScreen extends StatefulWidget {
  static const String id = '/time_table_screen';
  const TimeTableScreen({super.key, required this.studentId, required this.studentName});
  final int studentId;
  final String studentName;
  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  List<Map<String, Color>> colors = [];

  @override
  void initState() {
    super.initState();
    context.read<TimeTableBloc>().add(TimeTableRequested(studentId: widget.studentId));
    colors = getMatchingColors(5);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimeTableBloc, TimeTableState>(
      listener: (context, state) {
        if (state is TimeTableSuccess) {
        } else if (state is TimeTableFailure) {
          FlushbarPackage.showErrorFlushbar(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('تایم های صنوف درسی')),
          body: ScaffoldBackgroundImage(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: state is TimeTableLoading
                  ? const CustomLoadingIndicator()
                  : state is TimeTableSuccess
                      ? state.timeTableList.isEmpty
                          ? CustomEmptyWidget(
                              message: 'اطلاعاتی برای نمایش وجود ندارد!',
                              onTap: () {
                                context.read<TimeTableBloc>().add(TimeTableRequested(studentId: widget.studentId));
                              },
                            )
                          : StaggeredGrid.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              children: [
                                ...List.generate(state.timeTableList.length, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return AttendanceDetailsScreen(
                                            studentId: widget.studentId,
                                            studentName: widget.studentName,
                                            timeId: state.timeTableList[index].timeId,
                                          );
                                        },
                                      ));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: colors[index]['background'],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Tooltip(
                                                  message: state.timeTableList[index].courseName,
                                                  triggerMode: TooltipTriggerMode.tap,
                                                  child: Container(
                                                    height: 25,
                                                    padding: const EdgeInsets.all(1),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(3),
                                                      color: colors[index]['foreground'],
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      state.timeTableList[index].courseName,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                            fontWeight: FontWeight.w900,
                                                            color: kWhiteColor,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                flex: 2,
                                                child: Tooltip(
                                                  message: state.timeTableList[index].subName,
                                                  triggerMode: TooltipTriggerMode.tap,
                                                  child: Container(
                                                    height: 25,
                                                    padding: const EdgeInsets.symmetric(horizontal: 3),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(3),
                                                      color: colors[index]['foreground'],
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      state.timeTableList[index].subName,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                            color: kWhiteColor,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.watch_later_sharp,
                                                size: sizeConstants.iconSmall,
                                                color: colors[index]['foreground'],
                                              ),
                                              const SizedBox(width: 5),
                                              Flexible(
                                                child: Text(
                                                  '${_getTimeSplitted(state.timeTableList[index].startTime)} - ${_getTimeSplitted(state.timeTableList[index].endTime)}',
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.class_rounded,
                                                size: sizeConstants.iconSmall,
                                                color: colors[index]['foreground'],
                                              ),
                                              const SizedBox(width: 5),
                                              Flexible(
                                                child: Text(
                                                  _getSubStatus(state.timeTableList[index].statusFinish),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: getMediaQueryWidth(context),
                                            height: 0.5,
                                            margin: const EdgeInsets.symmetric(vertical: 5),
                                            color: colors[index]['foreground']!.withOpacity(0.3),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.calendar_month,
                                                          size: sizeConstants.iconSmall,
                                                          color: colors[index]['foreground'],
                                                        ),
                                                        const SizedBox(width: 5),
                                                        Text(
                                                          'ت.ش:',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .labelMedium!
                                                              .copyWith(fontWeight: FontWeight.bold),
                                                        ),
                                                        const SizedBox(width: 5),
                                                        Flexible(
                                                          child: Text(
                                                            DateFormatters.convertToShamsiWithDayName(
                                                                state.timeTableList[index].endDate,
                                                                hideDay: true),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: Theme.of(context).textTheme.labelSmall,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.date_range_rounded,
                                                          size: sizeConstants.iconSmall,
                                                          color: colors[index]['foreground'],
                                                        ),
                                                        const SizedBox(width: 5),
                                                        Text(
                                                          'ت.خ:',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .labelMedium!
                                                              .copyWith(fontWeight: FontWeight.bold),
                                                        ),
                                                        const SizedBox(width: 5),
                                                        Flexible(
                                                          child: Text(
                                                            DateFormatters.convertToShamsiWithDayName(
                                                                state.timeTableList[index].endDate,
                                                                hideDay: true),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: Theme.of(context).textTheme.labelSmall,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Tooltip(
                                                message: 'نمره کامیابی',
                                                triggerMode: TooltipTriggerMode.tap,
                                                child: Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: colors[index]['foreground'],
                                                  ),
                                                  child: Text(
                                                    state.timeTableList[index].successPoint.toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(color: kWhiteColor, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            )
                      : CustomErrorWidget(
                          onTap: () {
                            context.read<TimeTableBloc>().add(TimeTableRequested(studentId: widget.studentId));
                          },
                        ),
            ),
          ),
        );
      },
    );
  }

  _getTimeSplitted(String time) {
    try {
      List<String> splittedDate = time.split(RegExp(':'));
      String date1 = splittedDate[0];
      String date2 = splittedDate[1];
      String amOrPm = 'ق.ظ';
      if (num.parse(date1) > 12) {
        amOrPm = 'ب.ظ';
      }
      return '$date1:$date2$amOrPm';
    } catch (e) {
      return time;
    }
  }

  _getSubStatus(String status) {
    switch (status) {
      case 'Finished':
        return 'فارغ';
      case 'NoFinish':
        return 'در حال جریان...';
      default:
        return status;
    }
  }
}
