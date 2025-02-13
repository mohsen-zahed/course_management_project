import 'package:course_management_project/features/data/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;
  updateUserModel(UserModel? userModelInput) {
    userModel = userModelInput;
    notifyListeners();
  }
}
