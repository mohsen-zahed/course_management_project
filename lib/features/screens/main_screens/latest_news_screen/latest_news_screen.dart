import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/features/data/blocs/news_bloc/news_bloc.dart';
import 'package:course_management_project/features/data/models/news_model.dart';
import 'package:course_management_project/features/data/providers/news_provider.dart';
import 'package:course_management_project/features/screens/main_screens/latest_news_screen/widgets/post_widget.dart';
import 'package:course_management_project/features/screens/main_screens/no_internet_screen/no_internet_screen.dart';
import 'package:course_management_project/packages/dio_package/dio_package.dart';
import 'package:course_management_project/packages/dio_package/status_codes.dart';
import 'package:course_management_project/packages/flushbar_package/flushbar_package.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:course_management_project/widgets/custom_cached_network_image.dart';
import 'package:course_management_project/widgets/custom_error_widget.dart';
import 'package:course_management_project/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
                        if (state.errorMessage.contains(StatusCodes.noInternetConnectionCode)) {
                          Navigator.pushNamedAndRemoveUntil(context, NoInternetScreen.id, (route) => false);
                        } else {
                          FlushbarPackage.showErrorFlushbar(context, state.errorMessage);
                        }
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
