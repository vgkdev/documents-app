import 'package:documents_app/themes/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routers/navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      if (true) {
        Get.offAll(Navigation());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GlobalColors.mainTheme,
      width: Get.width,
      height: Get.height,
      alignment: Alignment.center,
      child: Image.asset(
        "./assets/images/splash_screen.jpg",
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      ),
    );
  }
}
