import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/config/constants/images_paths.dart';
import 'package:course_management_project/features/data/blocs/auth_bloc/auth_bloc.dart';
import 'package:course_management_project/features/data/blocs/home_bloc/home_bloc.dart';
import 'package:course_management_project/features/data/models/home_info_model.dart';
import 'package:course_management_project/features/data/providers/user_provider.dart';
import 'package:course_management_project/features/screens/initial_screens/login_screen/login_screen.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/notifiers/home_notifiers.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/widgets/home_appbar.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/widgets/home_drawer.dart';
import 'package:course_management_project/helpers/exit_app_helper.dart';
import 'package:course_management_project/helpers/theme_helpers.dart';
import 'package:course_management_project/packages/flushbar_package/flushbar_package.dart';
import 'package:course_management_project/packages/dio_package/status_codes.dart';
import 'package:course_management_project/utils/app_theme.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:course_management_project/widgets/custom_loading_indicator.dart';
import 'package:course_management_project/widgets/scaffold_background_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String id = '/home_screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  @override
  void initState() {
    super.initState();
    HomeNotifiers.bannerValueNotifier = ValueNotifier(0);
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  void dispose() {
    HomeNotifiers.bannerValueNotifier.dispose();
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  List<String> adBanners = [
    'https://adespresso.com/wp-content/uploads/2020/06/banner-ad-examples-1024x536.jpg',
    'https://alidropship.com/wp-content/uploads/2019/12/50-best-banner-ads-examples.jpg',
    'https://www.creatopy.com/blog/wp-content/uploads/2024/04/Banner-Ad-Design-Examples.png',
  ];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is LoggingOut) {
          Navigator.pop(context);
        } else if (state is LogoutSuccess) {
          FlushbarPackage.showSuccessFlushbar(context, 'شما موفقانه از حساب خود خارج شدید!');
          Future.delayed(const Duration(seconds: 1), () {
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false);
            }
          });
        } else if (state is LogoutFailure) {
          if (state.errorMessage.contains(StatusCodes.unAthurizedCode)) {
            FlushbarPackage.showErrorFlushbar(context, 'خطایی در هنگام خروج از حساب رخ داده است!');
          } else {
            FlushbarPackage.showErrorFlushbar(context, 'خطایی رخ داده است، لطفا دوباره امتحان کنید!');
          }
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              drawer: const HomeDrawer(),
              key: _scaffoldKey,
              appBar: AppBar(
                toolbarHeight: 80,
                leadingWidth: 0,
                title: HomeAppbar(
                  onImageTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
                leading: const Icon(null),
              ),
              body: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  // Detect swipe from left to right to open the drawer
                  if (details.primaryDelta! < 5) {
                    _scaffoldKey.currentState?.openDrawer(); // Open the drawer when swiped right
                  }
                },
                child: ScaffoldBackgroundImage(
                  child: SafeArea(
                    child: PopScope(
                      canPop: false,
                      onPopInvoked: (didPop) async {
                        await ExitAppHandler.handleExitApp(context);
                      },
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<HomeBloc>().add(StudentsListRequested());
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              CustomCarouselSlider(bannersList: adBanners),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: StaggeredGrid.count(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                  children: [
                                    ...List.generate(
                                      infoList.length,
                                      (index) {
                                        return HomeReportCard(infoModel: infoList[index]);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            state is LoggingOut
                ? Positioned.fill(
                    child: Container(
                      color: kBlackColor.withOpacity(0.5),
                      child: const CustomLoadingIndicator(message: 'در حال خروج از برنامه...', textColor: kWhiteColor),
                    ),
                  )
                : SizedBox.fromSize(size: Size.zero),
          ],
        );
      },
    );
  }
}

class CustomCarouselSlider extends StatelessWidget {
  const CustomCarouselSlider({
    super.key,
    required this.bannersList,
  });

  final List<String> bannersList;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HomeNotifiers.bannerValueNotifier,
      builder: (context, adIndicator, child) {
        return Stack(
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
            Positioned(
              right: 0,
              left: 0,
              bottom: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(
                    bannersList.length,
                    (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: adIndicator == index ? 25 : 9,
                        height: 6,
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
            ),
          ],
        );
      },
    );
  }
}

List<HomeInfoModel> infoList = [
  const HomeInfoModel(
    image: ImagesPaths.loanIconPng,
    title: 'مجموع باقی داری',
    value: '1200',
  ),
  const HomeInfoModel(
    image: ImagesPaths.lessonIconPng,
    title: 'مجموع صنوف',
    value: '3',
  ),
  const HomeInfoModel(
    image: ImagesPaths.gradeIconPng,
    title: 'مجموع نمرات روزانه',
    value: '86',
  ),
  const HomeInfoModel(
    image: ImagesPaths.reviewIconPng,
    title: 'تعداد نظریات',
    value: '31',
  ),
];

class HomeReportCard extends StatelessWidget {
  const HomeReportCard({super.key, required this.infoModel});
  final HomeInfoModel infoModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kBlueCustomColor.withOpacity(0.3),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(infoModel.image, height: sizeConstants.imageSmall),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: kBlueCustomColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                infoModel.title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: kBlueCustomColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              child: Text(
                infoModel.value,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.title,
    required this.leading,
    required this.trailing,
    required this.tileColor,
    required this.onTap,
  });
  final String title;
  final IconData leading;
  final IconData trailing;
  final Color tileColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        tileColor: tileColor.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        dense: true,
        splashColor: kBlackColor12,
        onTap: onTap,
        leading: Icon(leading, color: tileColor),
        trailing: Icon(trailing, size: 20.w, color: tileColor),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, color: tileColor),
        ),
      ),
    );
  }
}

class UserInfoBox extends StatelessWidget {
  const UserInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {},
        builder: (context, state) {
          return Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: sizeConstants.imageMedium,
                    height: sizeConstants.imageMedium,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kBlueColor),
                      image: const DecorationImage(
                        image: AssetImage(ImagesPaths.profileDemoJpeg),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    userProvider.userModel!.name,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    userProvider.userModel!.email,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    height: sizeConstants.buttonHeightSmall,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kRedColor.withOpacity(0.1),
                    ),
                    child: TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              LogoutRequested(id: context.read<UserProvider>().userModel!.id),
                            );
                      },
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      ),
                      child: state is LoggingOut
                          ? const CupertinoActivityIndicator()
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'خروج از حساب',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: kRedColor, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 7),
                                Icon(Icons.logout, color: kRedColor, size: 15.sp),
                              ],
                            ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
