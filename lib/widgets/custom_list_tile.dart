import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.title,
    required this.leading,
    required this.trailing,
    required this.tileColor,
    required this.onTap,
  });
  final String title;
  final IconData leading;
  final IconData trailing;
  final Color tileColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        tileColor: tileColor.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        dense: true,
        splashColor: kBlackColor12,
        onTap: onTap,
        leading: Icon(leading, color: tileColor),
        trailing: Icon(trailing, size: 20.w, color: tileColor),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, color: tileColor),
        ),
      ),
    );
  }
}
