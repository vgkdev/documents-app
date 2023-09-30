// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/navigation_controller.dart';
import '../themes/global_colors.dart';

class Navigation extends StatelessWidget {
  Navigation({super.key});
  DateTime? currentBackPressTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: GlobalColors.primary));
    return GetX<NavigationController>(
        init: NavigationController(),
        builder: (controller) {
          // print('>>>check index: ${controller.selectedBottomIndex.value}');
          return SafeArea(
            child: WillPopScope(
              onWillPop: () async {
                final cantExit = currentBackPressTime == null ||
                    DateTime.now().difference(currentBackPressTime!) >
                        const Duration(seconds: 2);
                // print('>>>check cant exit: ${cantExit}');
                // print('>>>check date: ${currentBackPressTime}');
                if (cantExit) {
                  currentBackPressTime = DateTime.now();
                  const snack = SnackBar(
                    content: Text(
                      'Press Back button again to Exit',
                      style: TextStyle(color: Colors.white),
                    ),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.black,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snack);
                  return false;
                } else {
                  return true;
                }
              },
              child: Scaffold(
                backgroundColor: GlobalColors.background,
                body: controller
                    .getBottomItemScreen(controller.selectedBottomIndex.value),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: controller.selectedBottomIndex.value,
                  selectedItemColor: GlobalColors.appColor,
                  unselectedItemColor: Colors.grey.shade400,
                  onTap: (index) => controller.onSelectBottomItemScreen(index),
                  // showSelectedLabels: false,
                  // showUnselectedLabels: false,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Trang chủ',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.library_books),
                      label: 'Tài liệu',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Tài khoản',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'Cài đặt',
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
