import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/config/constants/images_paths.dart';
import 'package:course_management_project/features/data/blocs/news_bloc/news_bloc.dart';
import 'package:course_management_project/features/data/models/news_model.dart';
import 'package:course_management_project/features/data/providers/news_provider.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/widgets/home_report_card.dart';
import 'package:course_management_project/helpers/date_formatters.dart';
import 'package:course_management_project/packages/dio_package/dio_package.dart';
import 'package:course_management_project/packages/flushbar_package/flushbar_package.dart';
import 'package:course_management_project/packages/get_it_package/get_it_package.dart';
import 'package:course_management_project/utils/app_theme.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:course_management_project/widgets/custom_cached_network_image.dart';
import 'package:course_management_project/widgets/custom_error_widget.dart';
import 'package:course_management_project/widgets/custom_loading_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

List<String> conferenceList = [
  'https://www.norquest.ca/getmedia/ec1c2c3b-48e5-4b50-aed9-2eba78149883/Educational-Assisstant-Conference.jpg?width=1280&height=720&ext=.jpg',
  'https://www.stonebridge.uk.com/blog/wp-content/uploads/2020/09/Primary-School-Teacher-Course.jpg',
  'https://www.stonebridge.uk.com/blog/wp-content/uploads/2020/09/Primary-School-Teacher-Course.jpg',
];

class LatestNewsScreen extends StatefulWidget {
  static const String id = '/latest_news_screen';
  const LatestNewsScreen({super.key});

  @override
  State<LatestNewsScreen> createState() => _LatestNewsScreenState();
}

class _LatestNewsScreenState extends State<LatestNewsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(const NewsDataRequested(page: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        onPopInvoked: (didPop) {
          if (!cancelToken.isCancelled) {
            cancelToken.cancel();
            context.read<NewsProvider>().newsList.clear();
          }
        },
        child: CustomScrollView(
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
                      child: const CustomCachedNetworkImage(
                        shape: BoxShape.rectangle,
                        boxFit: BoxFit.cover,
                        imageUrl:
                            'https://img.freepik.com/free-photo/person-holding-speech-official-event_23-2151054195.jpg?t=st=1739468899~exp=1739472499~hmac=6602481f6efe0947bc1092d5f0e3f4053c84df7974c2010a423d5ac1a4290d73&w=826',
                      ),
                    ),
                    Positioned(
                      child: Container(
                        decoration: const BoxDecoration(
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
              delegate: SliverChildListDelegate(
                [
                  BlocConsumer<NewsBloc, NewsState>(
                    listener: (context, state) {
                      if (state is NewsFailure) {
                        FlushbarPackage.showErrorFlushbar(context, state.errorMessage);
                      }
                    },
                    builder: (context, state) {
                      return state is NewsLoading
                          ? Padding(padding: EdgeInsets.only(top: 30.h), child: const CustomLoadingIndicator())
                          : state is NewsSuccess
                              ? Consumer<NewsProvider>(
                                  builder: (context, newsProvider, child) {
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: newsProvider.newsList.length,
                                      itemBuilder: (context, index) {
                                        NewsModel news = newsProvider.newsList[index];
                                        return PostWidget(
                                          title: news.title,
                                          description: news.description,
                                          date: news.createAt,
                                          image: news.image,
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return Container(
                                          width: getMediaQueryWidth(context),
                                          height: 10,
                                          margin: const EdgeInsets.symmetric(vertical: 15),
                                          color: kGreyColor300,
                                        );
                                      },
                                    );
                                  },
                                )
                              : CustomErrorWidget(
                                  buttonText: '',
                                  onTap: () {
                                    context.read<NewsBloc>().add(const NewsDataRequested(page: 1));
                                  },
                                );
                    },
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
          child: TextScrollPackage(
            start: true,
            text: title,
            textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
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
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.thumb_up_alt_rounded),
                      SizedBox(width: 4),
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
                child: const Text('1.5k'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableText({super.key, required this.text, this.maxLines = 10});

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
        RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                text: widget.text.length > (widget.maxLines * 20) && !_isExpanded
                    ? widget.text.substring(0, widget.maxLines * 10)
                    : widget.text,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (widget.text.length > (widget.maxLines * 20))
                TextSpan(
                  text: _isExpanded ? '...نمایش کمتر' : ' ...نمایش بیشتر',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kBlueColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      setState(() {
                        _isExpanded = !_isExpanded; //
                      });
                    },
                ),
            ],
          ),
        ),
      ],
    );
  }
}
