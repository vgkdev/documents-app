import 'dart:convert';

import 'package:documents_app/models/user_model.dart';
import 'package:documents_app/utils/Preferences.dart';

class Constants {
  static const invalidMessage = "Vui lòng nhập thông tin";
  static const passwordNotMatch = "Mật khẩu không khớp";
  static const pleaseWait = "Vui lòng đợi";

  static UserModel getUserData() {
    final String user = Preferences.getString(Preferences.user);
    Map<String, dynamic> userMap = json.decode(user);
    return UserModel.fromJson(userMap);
  }
}
