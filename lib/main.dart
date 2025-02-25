import 'package:course_management_project/features/data/blocs/auth_bloc/auth_bloc.dart';
import 'package:course_management_project/features/data/blocs/home_bloc/home_bloc.dart';
import 'package:course_management_project/features/data/blocs/news_bloc/news_bloc.dart';
import 'package:course_management_project/features/data/blocs/student_details_bloc/student_details_bloc.dart';
import 'package:course_management_project/features/data/blocs/time_table_bloc/time_table_bloc.dart';
import 'package:course_management_project/features/data/providers/attendance_provider.dart';
import 'package:course_management_project/features/data/providers/daily_grades_provider.dart';
import 'package:course_management_project/features/data/providers/internet_provider.dart';
import 'package:course_management_project/features/data/providers/news_provider.dart';
import 'package:course_management_project/features/data/providers/transaction_provider.dart';
import 'package:course_management_project/features/data/providers/user_provider.dart';
import 'package:course_management_project/features/data/repository/iauth_repository.dart';
import 'package:course_management_project/features/data/repository/idata_repository.dart';
import 'package:course_management_project/features/screens/main_screens/attendance_details_screen/attendance_details_screen.dart';
import 'package:course_management_project/features/screens/main_screens/comments_details_screen/comments_details_screen.dart';
import 'package:course_management_project/features/screens/initial_screens/login_screen/login_screen.dart';
import 'package:course_management_project/features/screens/initial_screens/splash_screen/splash_screen.dart';
import 'package:course_management_project/features/screens/main_screens/daily_grades_screen/daily_grades_screen.dart';
import 'package:course_management_project/features/screens/main_screens/home_screen/home_screen.dart';
import 'package:course_management_project/features/screens/main_screens/grades_details_screen/grades_details_screen.dart';
import 'package:course_management_project/config/l10n/l10n.dart';
import 'package:course_management_project/features/screens/main_screens/latest_news_screen/latest_news_screen.dart';
import 'package:course_management_project/features/screens/main_screens/no_internet_screen/no_internet_screen.dart';
import 'package:course_management_project/features/screens/main_screens/students_screen/students_screen.dart';
import 'package:course_management_project/features/screens/main_screens/time_table_screen/time_table_screen.dart';
import 'package:course_management_project/features/screens/main_screens/transactions_details_screen/transactions_details_screen.dart';
import 'package:course_management_project/packages/get_it_package/get_it_package.dart';
import 'package:course_management_project/utils/app_theme.dart';
import 'package:course_management_project/widgets/full_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
// import 'package:course_management_project/packages/flutter_secure_storage_package/flutter_secure_storage_const.dart';
// import 'package:course_management_project/packages/flutter_secure_storage_package/flutter_secure_storage_package.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await setupGetIt();
  // await FlutterSecureStoragePackage.clearSecureStorage(accessTokenStorageKey);
  await authRepository.loadUserCredential();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di<InternetProvider>()..initialize()),
        ChangeNotifierProvider(create: (_) => di<UserProvider>()),
        ChangeNotifierProvider(create: (_) => di<AttendanceProvider>()),
        ChangeNotifierProvider(create: (_) => di<TransactionProvider>()),
        ChangeNotifierProvider(create: (_) => di<DailyGradesProvider>()),
        ChangeNotifierProvider(create: (_) => di<NewsProvider>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(authRepository)),
          BlocProvider(create: (_) => HomeBloc(dataRepository)),
          BlocProvider(create: (_) => StudentDetailsBloc(dataRepository)),
          BlocProvider(create: (_) => TimeTableBloc(dataRepository)),
          BlocProvider(create: (_) => NewsBloc(dataRepository)),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Consumer<InternetProvider>(
      builder: (context, internetProvider, child) {
        return Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return Consumer<AttendanceProvider>(
              builder: (context, attendanceProvider, child) {
                return Consumer<NewsProvider>(
                  builder: (context, newsProvider, child) {
                    return ScreenUtilInit(
                      designSize: const Size(360.0, 825.0),
                      splitScreenMode: true,
                      minTextAdapt: true,
                      builder: (context, child) {
                        return MaterialApp(
                          title: 'Tawana App',
                          theme: lightTheme(context),
                          darkTheme: darkTheme(context),
                          debugShowCheckedModeBanner: false,
                          supportedLocales: AppLocalizations.supportedLocales,
                          localizationsDelegates: AppLocalizations.localizationsDelegates,
                          locale: const Locale('fa'),
                          routes: {
                            SplashScreen.id: (context) => const SplashScreen(),
                            LoginScreen.id: (context) => const LoginScreen(),
                            HomeScreen.id: (context) => const HomeScreen(),
                            GradesDetailsScreen.id: (context) =>
                                const GradesDetailsScreen(studentId: 0, type: '', studentName: ''),
                            CommentsDetailsScreen.id: (context) =>
                                const CommentsDetailsScreen(studentId: 0, type: '', studentName: ''),
                            AttendanceDetailsScreen.id: (context) =>
                                const AttendanceDetailsScreen(studentId: 0, studentName: '', timeId: 0),
                            TransactionsDetailsScreen.id: (context) =>
                                const TransactionsDetailsScreen(studentId: 0, type: '', studentName: ''),
                            DailyGradesScreen.id: (context) =>
                                const DailyGradesScreen(studentId: 0, type: '', studentName: ''),
                            FullImageWidget.id: (context) => const FullImageWidget(imagePath: ''),
                            StudentsScreen.id: (context) => const StudentsScreen(),
                            TimeTableScreen.id: (context) => const TimeTableScreen(studentId: 0, studentName: ''),
                            LatestNewsScreen.id: (context) => const LatestNewsScreen(),
                            NoInternetScreen.id: (context) => const NoInternetScreen(),
                          },
                          themeMode: ThemeMode.system,
                          home: const SplashScreen(),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
// Attendance - Transaction - Grades - Profile - Comments