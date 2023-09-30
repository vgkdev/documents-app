import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:documents_app/configs/fire_base_config.dart';
import 'package:documents_app/constants/constants.dart';
import 'package:documents_app/models/user_model.dart';
import 'package:documents_app/servers/collection_cloud_firestore.dart';
import 'package:documents_app/utils/show_toast_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxString errMessage = "".obs;

  Future<UserModel?> loginUser(Map<String, dynamic> bodyParams) async {
    try {
      ShowToastDialog.showLoader(Constants.pleaseWait);
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: bodyParams['email'].toString(),
        password: bodyParams['password'].toString(),
      );

      DocumentReference documentReference = FirebaseConfig.db
          .collection(CollectionCloudFireStore.users)
          .doc(credential.user?.uid);

      ShowToastDialog.closeLoader();

      DocumentSnapshot documentSnapshot = await documentReference.get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> retrievedData =
            documentSnapshot.data() as Map<String, dynamic>;
        UserModel? user = UserModel.fromJson({
          'success': 'success',
          'data': retrievedData,
        });
        return user;
      }
      print('>>>check sign in data: ${credential.user?.uid}');
      ShowToastDialog.closeLoader();
    } on FirebaseAuthException catch (e) {
      ShowToastDialog.closeLoader();
      if (e.code == 'user-not-found') {
        errMessage.value = 'Không tìm thấy người dùng';
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        errMessage.value = 'Sai mật khẩu';
        print('Wrong password provided for that user.');
      }
    }
    return null;
  }
}
