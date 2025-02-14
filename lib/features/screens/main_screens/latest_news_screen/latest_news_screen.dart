import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/config/constants/images_paths.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/home_screen.dart';
import 'package:course_management_project/utils/app_theme.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:course_management_project/widgets/custom_cached_network_image.dart';
import 'package:course_management_project/widgets/scaffold_background_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<String> conferenceList = [
  'https://www.norquest.ca/getmedia/ec1c2c3b-48e5-4b50-aed9-2eba78149883/Educational-Assisstant-Conference.jpg?width=1280&height=720&ext=.jpg',
  'https://www.stonebridge.uk.com/blog/wp-content/uploads/2020/09/Primary-School-Teacher-Course.jpg',
  'https://www.stonebridge.uk.com/blog/wp-content/uploads/2020/09/Primary-School-Teacher-Course.jpg',
];

class LatestNewsScreen extends StatelessWidget {
  static const String id = '/latest_news_screen';
  const LatestNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 185.h,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'آخرین اخبار',
                style:
                    Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, color: kWhiteColor),
              ),
              background: Stack(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    height: getMediaQueryHeight(context),
                    child: CustomCachedNetworkImage(
                      shape: BoxShape.rectangle,
                      boxFit: BoxFit.cover,
                      imageUrl:
                          'https://img.freepik.com/free-photo/person-holding-speech-official-event_23-2151054195.jpg?t=st=1739468899~exp=1739472499~hmac=6602481f6efe0947bc1092d5f0e3f4053c84df7974c2010a423d5ac1a4290d73&w=826',
                    ),
                  ),
                  Positioned(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [kBlackColor, kTransparentColor],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return PostWidget();
                },
                separatorBuilder: (context, index) {
                  return Container(
                    width: getMediaQueryWidth(context),
                    height: 10,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    color: kGreyColor300,
                  );
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  const PostWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
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
                    Text(
                      '1403/01/01',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(color: kGreyColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ExpandableText(
              text:
                  'در دنیای امروز، تحولات سریع در زمینه فناوری‌های نوین، به ویژه هوش مصنوعی (AI)، تغییرات عظیمی را در زندگی روزمره ما ایجاد کرده است. از روزهایی که ایده‌های ابتدایی در مورد هوش مصنوعی تنها در داستان‌های علمی تخیلی مشاهده می‌شد، تا حالا که شاهد کاربردهای واقعی این فناوری در صنایع مختلف هستیم، مسیر طولانی‌ای طی شده است. اما سوالی که مطرح می‌شود این است که این پیشرفت‌ها چگونه به شکل‌گیری آینده انسانی کمک خواهند کرد؟',
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: getMediaQueryWidth(context),
            height: 350.h,
            child: CustomCachedNetworkImage(
              imageUrl:
                  'https://img.freepik.com/free-photo/person-holding-speech-official-event_23-2151054241.jpg?t=st=1739470577~exp=1739474177~hmac=a92492c99d8246228d94b4b8213636f4e73268c62ef5d51dc3d4b985c4807fa0&w=360',
              shape: BoxShape.rectangle,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    decoration: BoxDecoration(
                      color: kGreyColor100,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.thumb_up_alt_rounded),
                        const SizedBox(width: 4),
                        Text('لایک'),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: kGreyColor100,
                  ),
                  child: Text('1.5k'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  ExpandableText({required this.text, this.maxLines = 10});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: !_isExpanded ? null : widget.maxLines, // Limit lines when collapsed
          overflow: TextOverflow.ellipsis, // Add "..." at the end if text overflows
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.justify,
        ),
        if (widget.text.length > widget.maxLines * 20) // Adjust the condition based on your content length
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded; // Toggle between expanded/collapsed
              });
            },
            child: Text(
              _isExpanded ? 'Show less' : 'Show more',
              style: TextStyle(color: Colors.blue),
            ),
          ),
      ],
    );
  }
}
