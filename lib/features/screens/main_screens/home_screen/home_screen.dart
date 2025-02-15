import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/config/constants/images_paths.dart';
import 'package:course_management_project/features/data/blocs/auth_bloc/auth_bloc.dart';
import 'package:course_management_project/features/data/blocs/home_bloc/home_bloc.dart';
import 'package:course_management_project/features/data/models/home_info_model.dart';
import 'package:course_management_project/features/screens/initial_screens/login_screen/login_screen.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/notifiers/home_notifiers.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/widgets/home_appbar.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/widgets/home_drawer.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/widgets/home_report_card.dart';
import 'package:course_management_project/helpers/exit_app_helper.dart';
import 'package:course_management_project/helpers/helper_functions.dart';
import 'package:course_management_project/packages/carousel_slider_package/carousel_slider_package.dart';
import 'package:course_management_project/packages/flushbar_package/flushbar_package.dart';
import 'package:course_management_project/packages/dio_package/status_codes.dart';
import 'package:course_management_project/widgets/custom_loading_indicator.dart';
import 'package:course_management_project/widgets/scaffold_background_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
                        if (_scaffoldKey.currentState!.isDrawerOpen) {
                          _scaffoldKey.currentState!.closeDrawer();
                        } else {
                          await ExitAppHandler.handleExitApp(context);
                        }
                      },
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<HomeBloc>().add(StudentsListRequested());
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              CarouselSliderPackage(bannersList: adBanners),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: BlocConsumer<HomeBloc, HomeState>(
                                  listener: (context, state) {},
                                  builder: (context, state) {
                                    return StaggeredGrid.count(
                                      crossAxisCount: 2,
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
                                    );
                                  },
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

List<HomeInfoModel> infoList = [
  HomeInfoModel(
    image: ImagesPaths.loanIconPng,
    title: 'مجموع باقی داری',
    value: HelperFunctions.formatCurrencyAfghani(double.parse('1200')),
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
