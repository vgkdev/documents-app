import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonWidget {
  static showSnackBarAlert({
    required String message,
    required Color color,
    IconData icon = Icons.error,
  }) {
    return Get.showSnackbar(GetSnackBar(
      borderRadius: 20,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
      isDismissible: true,
      message: message,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 5),
      // mainButton: const Row(
      //   children: [
      //     Icon(
      //       Icons.cancel,
      //       color: Colors.white,
      //     ),
      //     SizedBox(width: 10),
      //   ],
      // ),
    ));
  }
}
