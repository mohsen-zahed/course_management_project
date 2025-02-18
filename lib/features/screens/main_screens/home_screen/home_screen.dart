import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/features/data/blocs/auth_bloc/auth_bloc.dart';
import 'package:course_management_project/features/data/blocs/home_bloc/home_bloc.dart';
import 'package:course_management_project/features/data/models/home_student_model.dart';
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
import 'package:course_management_project/packages/shimmer_package/shimmer_package.dart';
import 'package:course_management_project/utils/app_theme.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:course_management_project/widgets/custom_error_widget.dart';
import 'package:course_management_project/widgets/custom_loading_indicator.dart';
import 'package:course_management_project/widgets/full_image_widget.dart';
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
    context.read<HomeBloc>().add(AdBannerDataRequested());
    context.read<HomeBloc>().add(InfoCardsSummaryDataRequested());
  }

  @override
  void dispose() {
    HomeNotifiers.bannerValueNotifier.dispose();
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  var bannerState;
  var infoState;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is InfoCardsSummaryDataLoading) {
          infoState = state;
        } else if (state is InfoCardsSummaryDataFailure) {
          infoState = state;
        } else if (state is InfoCardsSummaryDataSuccess) {
          infoState = state;
        }
        if (state is AdBannerListLoading) {
          bannerState = state;
        } else if (state is AdBannerListFailure) {
          bannerState = state;
          FlushbarPackage.showErrorFlushbar(context, state.errorMessage);
        } else if (state is AdBannerListSuccess) {
          bannerState = state;
        }
      },
      builder: (context, state) {
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
                  drawer: HomeDrawer(scaffoldKey: _scaffoldKey),
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
                      HelperFunctions.openDrawer(details, _scaffoldKey);
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
                              context.read<HomeBloc>().add(AdBannerDataRequested());
                              context.read<HomeBloc>().add(InfoCardsSummaryDataRequested());
                            },
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  bannerState is AdBannerListLoading
                                      ? const CustomShimmer()
                                      : bannerState is AdBannerListSuccess
                                          ? CarouselSliderPackage(
                                              adList: bannerState.adList,
                                              onImageTap: (image) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return FullImageWidget(imagePath: image);
                                                    },
                                                  ),
                                                );
                                              },
                                            )
                                          : CustomErrorWidget(
                                              onTap: () {
                                                context.read<HomeBloc>().add(AdBannerDataRequested());
                                              },
                                            ),
                                  const SizedBox(height: 10),
                                  infoState is InfoCardsSummaryDataLoading
                                      ? SizedBox(
                                          height: getMediaQueryHeight(context, 0.5),
                                          child: const Center(child: CustomLoadingIndicator()),
                                        )
                                      : infoState is InfoCardsSummaryDataSuccess
                                          ? Padding(
                                              padding: const EdgeInsets.all(6),
                                              child: ListView.separated(
                                                shrinkWrap: true,
                                                physics: const BouncingScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  var student = infoState.homeInfoList[index] as HomeStudentModel;
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        width: getMediaQueryWidth(context),
                                                        margin: const EdgeInsets.fromLTRB(6, 0, 6, 5),
                                                        padding:
                                                            const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(7),
                                                          color: kStudentCardInfoColor,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              flex: 4,
                                                              child: Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  CircleAvatar(
                                                                    backgroundImage:
                                                                        CachedNetworkImageProvider(student.profile),
                                                                    radius: sizeConstants.imageXXSmall,
                                                                  ),
                                                                  const SizedBox(width: 10),
                                                                  Flexible(
                                                                    child: Text(
                                                                      student.stName,
                                                                      style: Theme.of(context)
                                                                          .textTheme
                                                                          .bodyMedium!
                                                                          .copyWith(fontWeight: FontWeight.bold),
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 1,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(width: 10),
                                                            Flexible(
                                                              child: Text(
                                                                student.stId,
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .copyWith(fontWeight: FontWeight.bold),
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      StaggeredGrid.count(
                                                        crossAxisCount: 2,
                                                        mainAxisSpacing: 5,
                                                        crossAxisSpacing: 5,
                                                        children: [
                                                          ...List.generate(
                                                            student.details.length,
                                                            (index) {
                                                              return HomeReportCard(
                                                                infoModel: student.details[index],
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                },
                                                separatorBuilder: (context, index) {
                                                  return const SizedBox(height: 15);
                                                },
                                                itemCount: infoState.homeInfoList.length,
                                              ),
                                            )
                                          : SizedBox(
                                              height: getMediaQueryHeight(context, 0.5),
                                              child: Center(
                                                child: CustomErrorWidget(
                                                  onTap: () {
                                                    context.read<HomeBloc>().add(InfoCardsSummaryDataRequested());
                                                  },
                                                ),
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
                          child:
                              const CustomLoadingIndicator(message: 'در حال خروج از برنامه...', textColor: kWhiteColor),
                        ),
                      )
                    : SizedBox.fromSize(size: Size.zero),
              ],
            );
          },
        );
      },
    );
  }
}
