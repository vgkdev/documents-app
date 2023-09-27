import 'package:documents_app/screens/documents_screen/documents_screen.dart';
import 'package:documents_app/screens/home_screen/home_screen.dart';
import 'package:documents_app/screens/profile_screen/profile_screen.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  RxInt selectedBottomIndex = 0.obs;

  @override
  void onInit() {
    //getUserData
    //updataToken
    super.onInit();
  }

  getUserData() {}

  updateToken() async {}

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
