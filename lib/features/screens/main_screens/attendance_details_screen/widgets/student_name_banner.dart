import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:flutter/material.dart';

class StudentNameBanner extends StatelessWidget {
  const StudentNameBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: kGreyColor300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(flex: 2, child: Text('عبدالصبور', style: Theme.of(context).textTheme.titleLarge, maxLines: 2)),
          const SizedBox(width: 10),
          Flexible(
              flex: 3,
              child: Text('American English File 4',
                  style: Theme.of(context).textTheme.titleMedium, textDirection: TextDirection.ltr)),
        ],
      ),
    );
  }
}
