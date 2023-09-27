import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonWidget {
  static showSnackBarAlert({
    required String message,
    Color color = Colors.green,
  }) {
    return Get.showSnackbar(GetSnackBar(
      borderRadius: 20,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
      isDismissible: true,
      message: message,
      icon: const Icon(
        Icons.error,
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
