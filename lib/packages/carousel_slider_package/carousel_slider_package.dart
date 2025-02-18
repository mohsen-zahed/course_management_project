import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/features/data/models/ad_banner_model.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/notifiers/home_notifiers.dart';
import 'package:course_management_project/helpers/theme_helpers.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarouselSliderPackage extends StatelessWidget {
  const CarouselSliderPackage({super.key, required this.adList, required this.onImageTap});
  final List<AdBannerModel> adList;
  final Function(String image) onImageTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HomeNotifiers.bannerValueNotifier,
      builder: (context, adIndicator, child) {
        return GestureDetector(
          onTap: () {
            onImageTap(adList[adIndicator].image);
          },
          child: Column(
            children: [
              SizedBox(
                width: getMediaQueryWidth(context, 0.95),
                child: adList.isNotEmpty
                    ? Center(
                        child: CarouselSlider.builder(
                          itemCount: adList.length,
                          itemBuilder: (context, index, realIndex) {
                            return CachedNetworkImage(
                              imageUrl: adList[index].image,
                              fit: BoxFit.cover,
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // Adding a gradient overlay on top of the image
                                  child: Container(
                                    width: getMediaQueryWidth(context),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        colors: [
                                          kBlackColor,
                                          kBlackColor.withOpacity(0.8),
                                          kBlackColor.withOpacity(0.5),
                                          kBlackColor.withOpacity(0.3),
                                          kTransparentColor,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                    alignment: AlignmentDirectional.bottomStart,
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Text(adList[index].title),
                                            );
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(25.0),
                                        child: Text(
                                          adList[index].title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(color: kWhiteColor, fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
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
                            enlargeFactor: 0.2,
                            enableInfiniteScroll: true,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(
                    adList.length,
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
          ),
        );
      },
    );
  }
}
