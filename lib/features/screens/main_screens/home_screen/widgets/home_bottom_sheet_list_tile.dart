import 'package:course_management_project/utils/app_theme.dart';
import 'package:flutter/material.dart';

class HomeBottomSheetListTile extends StatelessWidget {
  const HomeBottomSheetListTile({
    super.key,
    required this.onTap,
    required this.title,
  });

  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(Icons.abc, size: sizeConstants.iconMedium),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: sizeConstants.iconSmall),
    );
  }
}
