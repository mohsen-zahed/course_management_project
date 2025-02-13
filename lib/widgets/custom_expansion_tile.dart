import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:flutter/material.dart';

class CustomExpansionTile extends StatelessWidget {
  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.trailing,
    required this.onTap,
    this.backgroundColor,
    required this.index,
  });
  final String title;
  final String subTitle;
  final Widget trailing;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 3),
            color: kBlackColor.withOpacity(0.08),
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        child: ListTile(
          horizontalTitleGap: 3,
          leading: Text((index + 1).toString(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
          contentPadding: const EdgeInsets.fromLTRB(10, 3, 15, 3),
          tileColor: kTransparentColor,
          enableFeedback: true,
          shape: InputBorder.none,
          title: Text(title, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              subTitle,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kGreyColor500),
            ),
          ),
          trailing: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: trailing,
          ),
        ),
      ),
    );
  }
}
