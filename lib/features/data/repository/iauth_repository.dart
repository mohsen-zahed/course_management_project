import 'package:course_management_project/features/data/models/user_model.dart';
import 'package:course_management_project/features/data/providers/user_provider.dart';
import 'package:course_management_project/features/data/source/iauth_data_source.dart';
import 'package:course_management_project/packages/dio_package/dio_package.dart';
import 'package:course_management_project/packages/flutter_secure_storage_package/flutter_secure_storage_const.dart';
import 'package:course_management_project/packages/flutter_secure_storage_package/flutter_secure_storage_package.dart';
import 'package:course_management_project/packages/get_it_package/get_it_package.dart';
import 'package:flutter/material.dart';

final authRepository = AuthRepositoryImp(authDataSourceImp: AuthDataSourceImp(httpClient: httpClient));

abstract class IAuthRepository extends IAuthDataSource {}

class AuthRepositoryImp implements IAuthRepository {
  static final ValueNotifier<UserModel?> userModelValueNotifier = ValueNotifier(null);
  final AuthDataSourceImp authDataSourceImp;

  const AuthRepositoryImp({required this.authDataSourceImp});
  @override
  Future<UserModel> loginUser(String email, String password) async {
    try {
      final userModel = await authDataSourceImp.loginUser(email, password);
      await storeUserCredential(userModel);
      await loadUserCredential();
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> storeUserCredential(UserModel userModel) async {
    try {
      await FlutterSecureStoragePackage.storeToSecureStorage(accessTokenStorageKey, userModel.accessToken);
      await FlutterSecureStoragePackage.storeToSecureStorage(emailStorageKey, userModel.email);
      await FlutterSecureStoragePackage.storeToSecureStorage(userNameStorageKey, userModel.name);
      await FlutterSecureStoragePackage.storeToSecureStorage(idStorageKey, userModel.id.toString());
    } catch (e) {
      debugPrint('SecureStorage: ${e.toString()}');
    }
  }

  Future<void> loadUserCredential() async {
    try {
      final accessToken = await FlutterSecureStoragePackage.fetchFromSecureStorage(accessTokenStorageKey) ?? '';
      debugPrint('accessToken: $accessToken');
      final userName = await FlutterSecureStoragePackage.fetchFromSecureStorage(userNameStorageKey) ?? '';
      debugPrint('userName: $userName');
      final email = await FlutterSecureStoragePackage.fetchFromSecureStorage(emailStorageKey) ?? '';
      debugPrint('email: $email');
      final id = await FlutterSecureStoragePackage.fetchFromSecureStorage(idStorageKey) ?? '';
      var userModel = UserModel(name: userName, accessToken: accessToken, email: email, id: int.parse(id));
      await di<UserProvider>().updateUserModel(userModel);
      userModelValueNotifier.value = userModel;
    } catch (e) {
      debugPrint('SecureStorage: ${e.toString()}');
    }
  }

  @override
  Future<String> logoutUser(int id) async {
    try {
      final result = await authDataSourceImp.logoutUser(id);
      return result;
    } catch (e) {
      rethrow;
    } finally {
      await FlutterSecureStoragePackage.clearSecureStorage(accessTokenStorageKey);
      await FlutterSecureStoragePackage.clearSecureStorage(userNameStorageKey);
      await FlutterSecureStoragePackage.clearSecureStorage(emailStorageKey);
      await FlutterSecureStoragePackage.clearSecureStorage(idStorageKey);
    }
  }
}
