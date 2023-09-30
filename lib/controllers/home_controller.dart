import 'package:documents_app/constants/constants.dart';
import 'package:documents_app/models/user_model.dart';
import 'package:documents_app/utils/Preferences.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isLogin = false.obs;
  Rx<UserModel>? userModel = UserModel().obs;
  RxString firstName = "".obs;
  RxString lastName = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;

  @override
  void onInit() {
    isLogin.value = Preferences.getBoolean(Preferences.isLogin);
    if (isLogin.value == true) {
      getUserData();
    }
    // print('>>>check run: ${isLogin.value}');
    super.onInit();
  }

  getUserData() async {
    UserModel userModel = Constants.getUserData();
    firstName.value = userModel.data?.firstName ?? "";
    lastName.value = userModel.data?.lastName ?? "";
    email.value = userModel.data?.email ?? "";
    phone.value = userModel.data?.phone ?? "";
    this.userModel?.value = userModel;
  }
}
