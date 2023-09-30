import 'package:documents_app/screens/documents_screen/documents_screen.dart';
import 'package:documents_app/screens/home_screen/home_screen.dart';
import 'package:documents_app/screens/profile_screen/profile_screen.dart';
import 'package:documents_app/utils/Preferences.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  RxInt selectedBottomIndex = 0.obs;
  RxBool isLogin = false.obs;

  @override
  void onInit() {
    ever(isLogin, (isLogin) {
      // print('>>>check run ever: ${isLogin}');
      if (isLogin == true) {
        onSelectBottomItemScreen(0);
        getUserData();
      } else {
        onSelectBottomItemScreen(0);
      }
    });
    isLogin.value = Preferences.getBoolean(Preferences.isLogin);
    onSelectBottomItemScreen(0);
    // print('>>>check run navigation');
    super.onInit();
  }

  @override
  void onClose() {
    // print('>>>check on close');
    super.onClose();
  }

  getUserData() {}

  updateToken() async {}

  onSelectBottomItemScreen(int index) {
    selectedBottomIndex.value = index;
  }

  getBottomItemScreen(int pos) {
    switch (pos) {
      case 0:
        return const HomeScreen();
      case 1:
        return const DocumentsScreen();
      case 2:
        return const ProfileScreen();
    }
  }
}
