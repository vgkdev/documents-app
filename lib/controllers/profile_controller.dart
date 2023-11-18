import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:documents_app/configs/fire_base_config.dart';
import 'package:documents_app/constants/constants.dart';
import 'package:documents_app/models/user_model.dart';
import 'package:documents_app/servers/collection_cloud_firestore.dart';
import 'package:documents_app/utils/Preferences.dart';
import 'package:documents_app/utils/show_toast_dialog.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxString errorMessage = "".obs;
  RxBool isLogin = false.obs;
  Rx<UserModel>? userModel = UserModel().obs;
  RxString firstName = "".obs;
  RxString lastName = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxBool hasChangedFirstName = false.obs;
  RxBool hasChangedLastName = false.obs;

  @override
  void onInit() {
    isLogin.value = Preferences.getBoolean(Preferences.isLogin);
    if (isLogin.value == true) {
      getUserData();
    }
    // print('>>>check run: ${isLogin.value}');
    super.onInit();
  }

  reset() {
    hasChangedFirstName.value = false;
    hasChangedLastName.value = false;
  }

  getUserData() async {
    UserModel userModel = Constants.getUserData();
    firstName.value = userModel.data?.firstName ?? "";
    lastName.value = userModel.data?.lastName ?? "";
    email.value = userModel.data?.email ?? "";
    phone.value = userModel.data?.phone ?? "";
    this.userModel?.value = userModel;
  }

  handleChangeFirstName(String data) {
    hasChangedFirstName.value = firstName.value == data ? false : true;
  }

  handleChangeLastName(String data) {
    hasChangedLastName.value = lastName.value == data ? false : true;
  }

  Future<UserModel?> updateUserData(Map<String, dynamic> bodyParams) async {
    print('>>>check body update: ${bodyParams}');
    try {
      ShowToastDialog.showLoader('Vui lòng chờ');
      DocumentReference documentReference = FirebaseConfig.db
          .collection(CollectionCloudFireStore.users)
          .doc(bodyParams['userId']);

      await documentReference.update(bodyParams).then(
            (value) => print("DocumentSnapshot successfully updated!"),
            onError: (e) => print("Error updating document $e"),
          );
      // print('Document successfully set!');
      ShowToastDialog.closeLoader();

      DocumentSnapshot documentSnapshot = await documentReference.get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> retrievedData =
            documentSnapshot.data() as Map<String, dynamic>;
        UserModel? user = UserModel.fromJson({
          'success': 'success',
          'data': retrievedData,
        });
        // print('>>>check user from json success: ${user.toJson()}');
        return user;
      } else {
        print('>>>error document does not exist');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      print(">>>error update user data: $e");
    } on FirebaseException catch (e) {
      ShowToastDialog.closeLoader();
      print(">>>error update user data: $e");
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      print(">>>error update user data: $e");
    }
    errorMessage.value = "Đã xảy ra lỗi";
    return null;
  }
}
