import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/features/data/blocs/auth_bloc/auth_bloc.dart';
import 'package:course_management_project/features/data/blocs/home_bloc/home_bloc.dart';
import 'package:course_management_project/features/data/models/home_student_model.dart';
import 'package:course_management_project/features/screens/initial_screens/login_screen/login_screen.dart';
import 'package:course_management_project/features/screens/main_screens/comments_details_screen/comments_details_screen.dart';
import 'package:course_management_project/features/screens/main_screens/daily_grades_screen/daily_grades_screen.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/notifiers/home_notifiers.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/widgets/home_appbar.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/widgets/home_drawer.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/widgets/home_report_card.dart';
import 'package:course_management_project/features/screens/main_screens/time_table_screen/time_table_screen.dart';
import 'package:course_management_project/features/screens/main_screens/transactions_details_screen/transactions_details_screen.dart';
import 'package:course_management_project/helpers/date_formatters.dart';
import 'package:course_management_project/helpers/exit_app_helper.dart';
import 'package:course_management_project/helpers/helper_functions.dart';
import 'package:course_management_project/packages/carousel_slider_package/carousel_slider_package.dart';
import 'package:course_management_project/packages/dio_package/dio_package.dart';
import 'package:course_management_project/packages/flushbar_package/flushbar_package.dart';
import 'package:course_management_project/packages/dio_package/status_codes.dart';
import 'package:course_management_project/packages/shimmer_package/shimmer_package.dart';
import 'package:course_management_project/utils/app_theme.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:course_management_project/widgets/custom_error_widget.dart';
import 'package:course_management_project/widgets/custom_loading_indicator.dart';
import 'package:course_management_project/widgets/full_image_widget.dart';
import 'package:course_management_project/widgets/scaffold_background_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatefulWidget {
  static const String id = '/home_screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    HomeNotifiers.bannerValueNotifier = ValueNotifier(0);
    _scaffoldKey = GlobalKey<ScaffoldState>();
    context.read<HomeBloc>().add(AdBannerDataRequested());
    context.read<HomeBloc>().add(InfoCardsSummaryDataRequested());
    context.read<HomeBloc>().add(StudentsHistoryRecordsRequested());
  }

  @override
  void dispose() {
    HomeNotifiers.bannerValueNotifier.dispose();
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  var bannerState;
  var infoState;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is InfoCardsSummaryDataLoading) {
          infoState = state;
        } else if (state is InfoCardsSummaryDataFailure) {
          infoState = state;
        } else if (state is InfoCardsSummaryDataSuccess) {
          infoState = state;
        }
        if (state is AdBannerListLoading) {
          bannerState = state;
        } else if (state is AdBannerListFailure) {
          bannerState = state;
          FlushbarPackage.showErrorFlushbar(context, state.errorMessage);
        } else if (state is AdBannerListSuccess) {
          bannerState = state;
        }
      },
      builder: (context, state) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is LoggingOut) {
              Navigator.pop(context);
            } else if (state is LogoutSuccess) {
              FlushbarPackage.showSuccessFlushbar(context, 'شما موفقانه از حساب خود خارج شدید!');
              Future.delayed(const Duration(seconds: 1), () {
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false);
                }
              });
            } else if (state is LogoutFailure) {
              if (state.errorMessage.contains(StatusCodes.unAthurizedCode)) {
                FlushbarPackage.showErrorFlushbar(context, 'خطایی در هنگام خروج از حساب رخ داده است!');
              } else {
                FlushbarPackage.showErrorFlushbar(context, 'خطایی رخ داده است، لطفا دوباره امتحان کنید!');
              }
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Scaffold(
                  drawer: HomeDrawer(scaffoldKey: _scaffoldKey),
                  key: _scaffoldKey,
                  appBar: AppBar(
                    toolbarHeight: 80,
                    leadingWidth: 0,
                    title: HomeAppbar(
                      onImageTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                    leading: const Icon(null),
                  ),
                  body: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      HelperFunctions.openDrawer(details, _scaffoldKey);
                    },
                    child: ScaffoldBackgroundImage(
                      child: SafeArea(
                        child: PopScope(
                          canPop: false,
                          onPopInvoked: (didPop) async {
                            if (_scaffoldKey.currentState!.isDrawerOpen) {
                              _scaffoldKey.currentState!.closeDrawer();
                            } else {
                              await ExitAppHandler.handleExitApp(context);
                            }
                          },
                          child: RefreshIndicator(
                            onRefresh: () async {
                              context.read<HomeBloc>().add(AdBannerDataRequested());
                              context.read<HomeBloc>().add(InfoCardsSummaryDataRequested());
                              context.read<HomeBloc>().add(StudentsHistoryRecordsRequested());
                            },
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  bannerState is AdBannerListLoading
                                      ? const CustomShimmer()
                                      : bannerState is AdBannerListSuccess
                                          ? CarouselSliderPackage(
                                              adList: bannerState.adList,
                                              onImageTap: (image) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return FullImageWidget(imagePath: image);
                                                    },
                                                  ),
                                                );
                                              },
                                            )
                                          : CustomErrorWidget(
                                              onTap: () {
                                                context.read<HomeBloc>().add(AdBannerDataRequested());
                                              },
                                            ),
                                  const SizedBox(height: 10),
                                  infoState is InfoCardsSummaryDataLoading
                                      ? SizedBox(
                                          height: getMediaQueryHeight(context, 0.5),
                                          child: const Center(child: CustomLoadingIndicator()),
                                        )
                                      : infoState is InfoCardsSummaryDataSuccess
                                          ? Padding(
                                              padding: const EdgeInsets.all(6),
                                              child: ListView.separated(
                                                shrinkWrap: true,
                                                physics: const BouncingScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  var student = infoState.homeInfoList[index] as HomeStudentModel;
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        width: getMediaQueryWidth(context),
                                                        margin: const EdgeInsets.fromLTRB(6, 0, 6, 5),
                                                        padding:
                                                            const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(7),
                                                          color: kStudentCardInfoColor,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              flex: 4,
                                                              child: Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  CircleAvatar(
                                                                    backgroundImage:
                                                                        CachedNetworkImageProvider(student.profile),
                                                                    radius: sizeConstants.imageXXSmall,
                                                                  ),
                                                                  const SizedBox(width: 10),
                                                                  Flexible(
                                                                    child: Text(
                                                                      student.stName,
                                                                      style: Theme.of(context)
                                                                          .textTheme
                                                                          .bodyMedium!
                                                                          .copyWith(fontWeight: FontWeight.bold),
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 1,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(width: 10),
                                                            Flexible(
                                                              child: Text(
                                                                student.stCode,
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .copyWith(fontWeight: FontWeight.bold),
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      StaggeredGrid.count(
                                                        crossAxisCount: 2,
                                                        mainAxisSpacing: 5,
                                                        crossAxisSpacing: 5,
                                                        children: [
                                                          ...List.generate(
                                                            student.details.length,
                                                            (index) {
                                                              return HomeReportCard(
                                                                infoModel: student.details[index],
                                                                onTap: () {
                                                                  if (index == 0) {
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) {
                                                                          return DailyGradesScreen(
                                                                            studentId: student.stId,
                                                                            type: 'dailyGrade',
                                                                            studentName: student.stName,
                                                                          );
                                                                        },
                                                                      ),
                                                                    );
                                                                  } else if (index == 1) {
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) {
                                                                          return TransactionsDetailsScreen(
                                                                            studentId: student.stId,
                                                                            type: 'Transaction',
                                                                            studentName: student.stName,
                                                                          );
                                                                        },
                                                                      ),
                                                                    );
                                                                  } else if (index == 2) {
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) {
                                                                          return TimeTableScreen(
                                                                            studentId: student.stId,
                                                                            studentName: student.stName,
                                                                          );
                                                                        },
                                                                      ),
                                                                    );
                                                                  } else if (index == 3) {
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) {
                                                                          return CommentsDetailsScreen(
                                                                            studentId: student.stId,
                                                                            type: 'Comments',
                                                                            studentName: student.stName,
                                                                          );
                                                                        },
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                },
                                                separatorBuilder: (context, index) {
                                                  return const SizedBox(height: 15);
                                                },
                                                itemCount: infoState.homeInfoList.length,
                                              ),
                                            )
                                          : SizedBox(
                                              height: getMediaQueryHeight(context, 0.5),
                                              child: Center(
                                                child: CustomErrorWidget(
                                                  onTap: () {
                                                    context.read<HomeBloc>().add(InfoCardsSummaryDataRequested());
                                                  },
                                                ),
                                              ),
                                            ),
                                  const StudentTable(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                state is LoggingOut
                    ? Positioned.fill(
                        child: Container(
                          color: kBlackColor.withOpacity(0.5),
                          child:
                              const CustomLoadingIndicator(message: 'در حال خروج از برنامه...', textColor: kWhiteColor),
                        ),
                      )
                    : SizedBox.fromSize(size: Size.zero),
              ],
            );
          },
        );
      },
    );
  }
}

class StudentTable extends StatefulWidget {
  const StudentTable({super.key});

  @override
  State<StudentTable> createState() => _StudentTableState();
}

class _StudentTableState extends State<StudentTable> {
  var tableState;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is StudentsHistoryRecordsLoading) {
          tableState = state;
        } else if (state is StudentsHistoryRecordsFailure) {
          tableState = state;
          FlushbarPackage.showErrorFlushbar(context, 'خطایی رخ داده است!');
        } else if (state is StudentsHistoryRecorddsSuccess) {
          tableState = state;
        }
      },
      builder: (context, state) {
        if (tableState is StudentsHistoryRecordsLoading) {
          return const CustomLoadingIndicator();
        } else if (tableState is StudentsHistoryRecorddsSuccess) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tableState.studentsHistoryList.length,
            itemBuilder: (context, index) {
              final student = tableState.studentsHistoryList[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'نام دانش‌آموز: ${student.stName}',
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'کد دانش‌آموزی: ${student.stID}',
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            radius: sizeConstants.imageXXSmall,
                            backgroundImage: CachedNetworkImageProvider((student as Student).stProfile),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text('حاضری:'),
                      Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(color: kBlueCustomColor),
                            children: [
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('تاریخ', style: Theme.of(context).textTheme.bodyMedium),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('وضعیت', style: Theme.of(context).textTheme.bodyMedium),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('موضوع', style: Theme.of(context).textTheme.bodyMedium),
                              )),
                            ],
                          ),
                          ...student.attendance.map(
                            (attendance) {
                              return TableRow(
                                children: [
                                  TableCell(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(DateFormatters.convertToShamsiWithDayName(attendance.date)),
                                  )),
                                  TableCell(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(attendance.status),
                                  )),
                                  TableCell(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(attendance.subName),
                                  )),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text('نمرات روزانه:'),
                      Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(color: kBlueCustomColor),
                            children: [
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('تاریخ', style: Theme.of(context).textTheme.bodyMedium),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('نمرات', style: Theme.of(context).textTheme.bodyMedium),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('توضیحات', style: Theme.of(context).textTheme.bodyMedium),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('موضوع', style: Theme.of(context).textTheme.bodyMedium),
                              )),
                            ],
                          ),
                          ...student.dailyGrades.map((grade) {
                            return TableRow(
                              children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(DateFormatters.convertToShamsiWithDayName(grade.date)),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(grade.point.toString()),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(grade.description),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(grade.subName),
                                )),
                              ],
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text('تبادلات پولی:'),
                      Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(color: kBlueCustomColor),
                            children: [
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('تاریخ', style: Theme.of(context).textTheme.bodyMedium),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('مقدار', style: Theme.of(context).textTheme.bodyMedium),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('نوعیت', style: Theme.of(context).textTheme.bodyMedium),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('مضمون', style: Theme.of(context).textTheme.bodyMedium),
                              )),
                            ],
                          ),
                          ...student.transactions.map((transaction) {
                            return TableRow(
                              children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(DateFormatters.convertToShamsiWithDayName(transaction.date)),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(transaction.amount.toString()),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(transaction.type),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(transaction.subName),
                                )),
                              ],
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text('نظریات:'),
                      Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(color: kBlueCustomColor),
                            children: [
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('تاریخ', style: Theme.of(context).textTheme.bodyMedium),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('نظر', style: Theme.of(context).textTheme.bodyMedium),
                              )),
                            ],
                          ),
                          ...student.comments.map((comment) {
                            return TableRow(
                              children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(DateFormatters.convertToShamsiWithDayName(comment.date)),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(comment.comment),
                                )),
                              ],
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return CustomErrorWidget(
            onTap: () {
              context.read<HomeBloc>().add(StudentsHistoryRecordsRequested());
            },
          );
        }
      },
    );
  }
}

class Attendance {
  final String date;
  final String status;
  final String subName;

  const Attendance({
    required this.date,
    required this.status,
    required this.subName,
  });

  // fromJson constructor
  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      date: json['date'],
      status: json['status'],
      subName: json['sub_name'],
    );
  }
}

class DailyGrade {
  final String date;
  final int point;
  final String description;
  final String subName;

  const DailyGrade({
    required this.date,
    required this.point,
    required this.description,
    required this.subName,
  });

  // fromJson constructor
  factory DailyGrade.fromJson(Map<String, dynamic> json) {
    return DailyGrade(
      date: json['date'],
      point: json['point'],
      description: json['description'],
      subName: json['sub_name'],
    );
  }
}

class Comments {
  final String date;
  final String comment;

  const Comments({
    required this.date,
    required this.comment,
  });

  // fromJson constructor
  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      date: json['date'],
      comment: json['comment'],
    );
  }
}

class Transaction {
  final String date;
  final int amount;
  final String type;
  final String subName;

  const Transaction({
    required this.date,
    required this.amount,
    required this.type,
    required this.subName,
  });

  // fromJson constructor
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      date: json['date'],
      amount: json['amount'],
      type: json['type'],
      subName: json['sub_name'],
    );
  }
}

class Student {
  final String stName;
  final String stProfile;
  final String stID;
  final List<Attendance> attendance;
  final List<DailyGrade> dailyGrades;
  final List<Comments> comments;
  final List<Transaction> transactions;

  const Student({
    required this.stName,
    required this.stProfile,
    required this.stID,
    required this.attendance,
    required this.dailyGrades,
    required this.comments,
    required this.transactions,
  });

  // fromJson constructor
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      stName: json['st_name'],
      stProfile: json['st_profile'] != null ? '$profileUrl/${json['st_profile']}' : '',
      stID: json['st_ID'],
      attendance: (json['attendance'] as List).map((item) => Attendance.fromJson(item)).toList(),
      dailyGrades: (json['daily_grades'] as List).map((item) => DailyGrade.fromJson(item)).toList(),
      comments: (json['comments'] as List).map((item) => Comments.fromJson(item)).toList(),
      transactions: (json['transactions'] as List).map((item) => Transaction.fromJson(item)).toList(),
    );
  }
}
