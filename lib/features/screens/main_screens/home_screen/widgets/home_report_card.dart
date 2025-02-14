import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/features/data/models/home_info_model.dart';
import 'package:course_management_project/utils/app_theme.dart';
import 'package:flutter/material.dart';

class HomeReportCard extends StatelessWidget {
  const HomeReportCard({super.key, required this.infoModel});
  final HomeInfoModel infoModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kBlueCustomColor.withOpacity(0.3),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(infoModel.image, height: sizeConstants.imageSmall),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: kBlueCustomColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                infoModel.title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: kBlueCustomColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              child: Text(
                infoModel.value,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
