import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/features/data/models/student_model.dart';
import 'package:course_management_project/features/screens/main_screens/comments_details_screen/comments_details_screen.dart';
import 'package:course_management_project/features/screens/main_screens/daily_grades_screen/daily_grades_screen.dart';
import 'package:course_management_project/features/screens/main_screens/grades_details_screen/grades_details_screen.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/widgets/home_bottom_sheet_list_tile.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/widgets/horizontal_details_info.dart';
import 'package:course_management_project/features/screens/main_screens/time_table_screen/time_table_screen.dart';
import 'package:course_management_project/features/screens/main_screens/transactions_details_screen/transactions_details_screen.dart';
import 'package:course_management_project/helpers/date_formatters.dart';
import 'package:course_management_project/helpers/theme_helpers.dart';
import 'package:course_management_project/utils/app_theme.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:course_management_project/widgets/custom_cached_network_image.dart';
import 'package:course_management_project/widgets/full_image_widget.dart';
import 'package:flutter/material.dart';

class StudentBox extends StatefulWidget {
  const StudentBox({super.key, required this.studentModel});

  final StudentModel studentModel;

  @override
  State<StudentBox> createState() => _StudentBoxState();
}

class _StudentBoxState extends State<StudentBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _handleOnStudentTap(widget.studentModel);
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 100),
        padding: const EdgeInsets.fromLTRB(15, 12, 10, 12),
        decoration: BoxDecoration(
          color: isThemeLight(context) ? kStudentCardInfoColor : kGreyColor700,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomCachedNetworkImage(
                  imageUrl: widget.studentModel.profileImage,
                  onTap: () {
                    _handleOnImageTap(widget.studentModel);
                  },
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${widget.studentModel.name} ${widget.studentModel.lastName}',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.studentModel.fName,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'آی دی:',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.studentModel.stId,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'وضعیت:',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _getStatus(widget.studentModel.status),
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleOnImageTap(StudentModel student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(sizeConstants.spacingMedium),
          actionsPadding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: getMediaQueryWidth(context),
                  // margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5), color: kStudentCardInfoColor.withOpacity(0.1)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: kStudentCardInfoColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            student.profileImage.isNotEmpty
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullImageWidget(imagePath: student.profileImage),
                                    ),
                                  )
                                : null;
                          },
                          child: CustomCachedNetworkImage(
                            imageUrl: student.profileImage,
                            height: sizeConstants.imageMedium,
                            borderColor: kStudentCardInfoColor,
                          ),
                        ),
                        const SizedBox(height: 15),
                        HorizontalDetailsInfo(title: 'آی دی', value: student.stId),
                        const SizedBox(height: 10),
                        HorizontalDetailsInfo(title: 'نام', value: student.name),
                        const SizedBox(height: 10),
                        HorizontalDetailsInfo(title: 'نام پدر', value: student.fName),
                        const SizedBox(height: 10),
                        HorizontalDetailsInfo(title: 'تخلص', value: student.lastName),
                        const SizedBox(height: 10),
                        HorizontalDetailsInfo(title: 'شماره تماس', value: student.phoneNum),
                        const SizedBox(height: 10),
                        HorizontalDetailsInfo(
                            title: 'تاریخ تولد',
                            value: DateFormatters.convertToShamsiWithDayName(student.dateOfBirth, hideDay: true)),
                        const SizedBox(height: 10),
                        HorizontalDetailsInfo(
                            title: 'تاریخ ثبت نام',
                            value: DateFormatters.convertToShamsiWithDayName(student.registrationDate, hideDay: true)),
                        // const SizedBox(height: 10),
                        // HorizontalDetailsInfo(title: 'کارت', value: student.printCardStatus),
                        const SizedBox(height: 10),
                        HorizontalDetailsInfo(title: 'وضعیت', value: _getStatus(student.status)),
                        const SizedBox(height: 10),
                        HorizontalDetailsInfo(title: 'توضیحات', value: student.description, hideBottomLine: true),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                overlayColor: WidgetStatePropertyAll(
                  kBlueColor.withOpacity(0.2),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  Text('بازگشت', style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  _getStatus(String status) {
    switch (status) {
      case 'Studying':
        return 'در حال جریان';
      case 'Graduated':
        return 'فارغ شده';
      default:
        return status;
    }
  }

  _handleOnStudentTap(StudentModel student) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isDismissible: true,
      isScrollControlled: true,
      builder: (modalContext) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: kTransparentColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(sizeConstants.radiusSmall),
              topRight: Radius.circular(sizeConstants.radiusSmall),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HomeBottomSheetListTile(
                  title: 'ارزیابی روزانه',
                  onTap: () {
                    Navigator.pop(modalContext);
                    Future.delayed(const Duration(milliseconds: 200), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DailyGradesScreen(
                            studentId: student.studentId,
                            type: 'dailyGrade',
                            studentName: student.name,
                          ),
                        ),
                      );
                    });
                    // HelperFunctions.showSnackBar(context: context, message: 'به زودی...');
                  },
                ),
                const SizedBox(height: 10),
                HomeBottomSheetListTile(
                  title: 'جزئیات تبادلات پولی',
                  onTap: () {
                    Navigator.pop(modalContext);
                    Future.delayed(const Duration(milliseconds: 200), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionsDetailsScreen(
                            studentId: student.studentId,
                            type: 'Transaction',
                            studentName: student.name,
                          ),
                        ),
                      );
                    });
                    // HelperFunctions.showSnackBar(context: context, message: 'به زودی...');
                  },
                ),
                const SizedBox(height: 10),
                HomeBottomSheetListTile(
                  title: 'جزئیات نمرات',
                  onTap: () {
                    Navigator.pop(modalContext);
                    Future.delayed(
                      const Duration(milliseconds: 200),
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GradesDetailsScreen(
                              studentId: student.studentId,
                              type: 'Grades',
                              studentName: student.name,
                            ),
                          ),
                        );
                      },
                    );
                    // HelperFunctions.showSnackBar(context: context, message: 'به زودی...');
                  },
                ),
                const SizedBox(height: 10),
                HomeBottomSheetListTile(
                  title: 'جزئیات حاضری',
                  onTap: () {
                    Navigator.pop(modalContext);
                    Future.delayed(
                      const Duration(milliseconds: 200),
                      () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return TimeTableScreen(studentId: student.studentId, studentName: student.name);
                        }));
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => AttendanceDetailsScreen(
                        //       studentId: student.studentId,
                        //       studentName: student.name,
                        //       type: 'Attendance',
                        //     ),
                        //   ),
                        // );
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
                HomeBottomSheetListTile(
                  title: 'جزئیات نظریات',
                  onTap: () {
                    Navigator.pop(modalContext);
                    Future.delayed(
                      const Duration(milliseconds: 200),
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentsDetailsScreen(
                              studentId: student.studentId,
                              type: 'Comments',
                              studentName: student.name,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
