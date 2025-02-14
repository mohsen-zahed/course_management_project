import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/notifiers/home_notifiers.dart';
import 'package:course_management_project/helpers/theme_helpers.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarouselSliderPackage extends StatelessWidget {
  const CarouselSliderPackage({
    super.key,
    required this.bannersList,
  });

  final List<String> bannersList;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HomeNotifiers.bannerValueNotifier,
      builder: (context, adIndicator, child) {
        return Column(
          children: [
            AspectRatio(
              aspectRatio: 2 / 1,
              child: SizedBox(
                width: getMediaQueryWidth(context),
                child: bannersList.isNotEmpty
                    ? CarouselSlider.builder(
                        itemCount: bannersList.length,
                        itemBuilder: (context, index, realIndex) {
                          return CachedNetworkImage(
                            imageUrl: bannersList[index],
                            fit: BoxFit.cover,
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                ),
                              );
                            },
                            placeholder: (context, url) {
                              return SizedBox(
                                width: getMediaQueryWidth(context),
                                child: const Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              );
                            },
                            errorWidget: (context, url, error) {
                              return SizedBox(
                                width: getMediaQueryWidth(context),
                                child: Center(
                                  child: Icon(
                                    Icons.wifi_off_rounded,
                                    color: isThemeLight(context) ? kGreyColor300 : kGreyColor700,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        options: CarouselOptions(
                          // aspectRatio: 2 / 1,
                          autoPlayAnimationDuration: const Duration(seconds: 1),
                          autoPlayInterval: const Duration(seconds: 10),
                          animateToClosest: true,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            HomeNotifiers.bannerValueNotifier.value = index;
                          },
                          enlargeCenterPage: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          autoPlay: true,
                          initialPage: adIndicator,
                          scrollDirection: Axis.horizontal,
                          // autoPlayCurve: Curves.easeInOut,
                          enlargeFactor: 0.2,
                          enableInfiniteScroll: true,
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(
                  bannersList.length,
                  (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: adIndicator == index ? 25 : 9,
                      height: 4,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: isThemeLight(context) ? kBlueCustomColor : kBlueCustomColor.withOpacity(0.7),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
