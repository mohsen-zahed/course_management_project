import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2/1,
      child: Shimmer.fromColors(
        direction: ShimmerDirection.rtl,
        enabled: true,
        baseColor: kGreyColor200,
        highlightColor: kGreyColor400,
        child: Container(
          width: getMediaQueryWidth(context),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kGreyColor100,
          ),
        ),
      ),
    );
  }
}
