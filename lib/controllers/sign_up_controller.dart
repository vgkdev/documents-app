import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:documents_app/configs/fire_base_config.dart';
import 'package:documents_app/models/user_model.dart';
import 'package:documents_app/servers/collection_cloud_firestore.dart';
import 'package:documents_app/utils/show_toast_dialog.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpController extends GetxController {
  RxString errorMessage = "".obs;
  RxString phoneNumber = "".obs;
  RxBool isPhoneValid = false.obs;
  RxBool isError = false.obs;

  Future<UserCredential?> signUp(Map<String, dynamic> bodyParams) async {
    try {
      ShowToastDialog.showLoader('Vui lòng chờ');
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: bodyParams['email'],
        password: bodyParams['password'],
      );
      ShowToastDialog.closeLoader();
      return credential;
    } on FirebaseAuthException catch (e) {
      ShowToastDialog.closeLoader();
      if (e.code == 'weak-password') {
        errorMessage.value = "Mật khẩu phải có ít nhất 6 ký tự";
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        errorMessage.value = "Tài khoản đã tồn tại";
        print('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      ShowToastDialog.closeLoader();
      errorMessage.value = "Đã xảy ra lỗi";
      print(e);
      return null;
    }
  }

  Future<UserModel?> addUserData(Map<String, dynamic> bodyParams) async {
    try {
      ShowToastDialog.showLoader('Vui lòng chờ');
      DocumentReference documentReference = FirebaseConfig.db
          .collection(CollectionCloudFireStore.users)
          .doc(bodyParams['userId']);

      await documentReference.set(bodyParams);
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
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      print(">>>error add user data: $e");
    }
    errorMessage.value = "Đã xảy ra lỗi";
    return null;
  }
}
