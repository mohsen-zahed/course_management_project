import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/features/data/models/student_model.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/widgets/info_details_box.dart';
import 'package:course_management_project/widgets/custom_cached_network_image.dart';
import 'package:course_management_project/widgets/full_image_widget.dart';
import 'package:flutter/material.dart';

class StudentsDetailsCardImageWithName extends StatelessWidget {
  final StudentModel student;
  const StudentsDetailsCardImageWithName({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
              height: 60,
              borderColor: kStudentCardInfoColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: InfoDetailsBox(
                        text: student.name,
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(4)),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: InfoDetailsBox(
                        text: student.fName,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(4)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: InfoDetailsBox(
                        text: student.phoneNum,
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(4)),
                        textStyle: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: InfoDetailsBox(
                        text: student.stId,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(4)),
                        textStyle: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
