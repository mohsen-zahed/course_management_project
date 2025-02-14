import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.boxFit,
    this.height,
    this.onTap,
    this.borderColor,
    this.shape,
  });
  final String imageUrl;
  final BoxFit? boxFit;
  final double? height;
  final VoidCallback? onTap;
  final Color? borderColor;
  final BoxShape? shape;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: boxFit ?? BoxFit.cover,
        useOldImageOnUrlChange: true,
        // progressIndicatorBuilder: (context, url, progress) => CircularProgressIndicator(value: progress.progress),

        imageBuilder: (context, imageProvider) {
          return Container(
            width: height ?? sizeConstants.avatarSmallMed,
            height: height ?? sizeConstants.avatarSmallMed,
            decoration: BoxDecoration(
              shape: shape ?? BoxShape.circle,
              border: Border.all(color: borderColor ?? kWhiteColor, width: 2),
              image: DecorationImage(image: imageProvider, fit: boxFit ?? BoxFit.cover),
            ),
          );
        },
        placeholder: (context, url) {
          return Container(
            width: height ?? 60,
            height: height ?? 60,
            decoration: BoxDecoration(
              color: kGreyColor300,
              shape: shape ?? BoxShape.circle,
            ),
            child: const CupertinoActivityIndicator(),
          );
        },
        errorWidget: (context, url, error) {
          return Container(
            width: height ?? 70,
            height: height ?? 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor ?? kWhiteColor, width: 2),
            ),
            child: const Icon(Icons.broken_image),
          );
        },
      ),
    );
  }
}
