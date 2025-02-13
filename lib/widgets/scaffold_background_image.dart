import 'package:course_management_project/config/constants/images_paths.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:flutter/material.dart';

class ScaffoldBackgroundImage extends StatelessWidget {
  const ScaffoldBackgroundImage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getMediaQueryWidth(context),
      height: getMediaQueryHeight(context),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagesPaths.wallpaperJpg),
          opacity: 0.05,
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
