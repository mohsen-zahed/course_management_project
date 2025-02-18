import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/config/constants/images_paths.dart';
import 'package:course_management_project/features/screens/main_screens/latest_news_screen/widgets/expandable_text.dart';
import 'package:course_management_project/helpers/date_formatters.dart';
import 'package:course_management_project/utils/app_theme.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:course_management_project/widgets/custom_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.date,
  });
  final String title;
  final String description;
  final String image;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: sizeConstants.imageSmall,
                height: sizeConstants.imageSmall,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kBlueColor),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: Image.asset(ImagesPaths.tawanaWhiteLogoJpg, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اکادمی توانا',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_month_rounded, size: 10, color: kGreyColor400),
                      const SizedBox(width: 3),
                      Text(
                        DateFormatters.calculateDateRangeFromShamsiString(
                            DateFormatters.convertToShamsiWithDayName(date, hideDay: true)),
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: kGreyColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: getMediaQueryWidth(context, 0.3),
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          color: kGreyColor300,
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ExpandableText(text: description),
        ),
        const SizedBox(height: 5),
        Container(
          width: getMediaQueryWidth(context),
          height: 350.h,
          decoration: BoxDecoration(color: kGreyColor100),
          child: CustomCachedNetworkImage(
            imageUrl: image,
            shape: BoxShape.rectangle,
          ),
        ),
        const SizedBox(height: 10),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 15),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       GestureDetector(
        //         onTap: () {},
        //         child: Container(
        //           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        //           decoration: BoxDecoration(
        //             color: kGreyColor100,
        //             borderRadius: BorderRadius.circular(5),
        //           ),
        //           child: const Row(
        //             mainAxisSize: MainAxisSize.min,
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: [
        //               Icon(Icons.thumb_up_alt_rounded),
        //               SizedBox(width: 4),
        //               Text('لایک'),
        //             ],
        //           ),
        //         ),
        //       ),
        //       Container(
        //         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(5),
        //           color: kGreyColor100,
        //         ),
        //         child: const Text('1.5k'),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
