import 'package:get/get.dart';

import '../models/settings_model.dart';

class SettingsController extends GetxController {
  @override
  void onInit() {
    getSettingsData(); //fetch api
    super.onInit();
  }

  Future<SettingsModel?> getSettingsData() async {
    return null;
  }
}
