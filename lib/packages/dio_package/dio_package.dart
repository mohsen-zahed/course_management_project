import 'package:course_management_project/features/data/repository/iauth_repository.dart';
import 'package:course_management_project/packages/flutter_secure_storage_package/flutter_secure_storage_const.dart';
import 'package:course_management_project/packages/flutter_secure_storage_package/flutter_secure_storage_package.dart';
import 'package:dio/dio.dart';

final httpClient = Dio(BaseOptions(baseUrl: 'https://tam.tawanaacademy.com/'))
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final authInfo = AuthRepositoryImp.userModelValueNotifier.value;
        final accessToken = await FlutterSecureStoragePackage.fetchFromSecureStorage(accessTokenStorageKey);
        if (authInfo != null && authInfo.accessToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer ${authInfo.accessToken}';
        } else if (accessToken != null && accessToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        handler.next(options);
      },
    ),
  );

CancelToken cancelToken = CancelToken();
const defaultTimeOut = 60;

const String newsGetApi = 'api/show_news';
const String adBannerGetApi = 'api/show_advertisement';
const String homeInfoReportGetApi = 'api/all_information';

final String updoadsUrl = '${httpClient.options.baseUrl}/public/uploads';
final String profileUrl = '${httpClient.options.baseUrl}/public/st_profile';
