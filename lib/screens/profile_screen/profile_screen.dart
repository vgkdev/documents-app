import 'package:documents_app/screens/auth_screen/login_screen.dart';
import 'package:documents_app/screens/auth_screen/sign_up_screen.dart';
import 'package:documents_app/themes/global_button.dart';
import 'package:documents_app/themes/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/Preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Preferences.getBoolean(Preferences.isLogin)
          ? Column(
              children: [
                Container(
                  width: double.infinity,
                  color: GlobalColors.appColor,
                  padding: const EdgeInsets.all(20.0),
                  child: const Column(
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        child: Icon(
                          Icons.person,
                          size: 80,
                        ),
                        // backgroundImage: NetworkImage('URL_AVATAR_IMAGE'),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Tên của bạn',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.home),
                      onPressed: () {
                        // Xử lý khi nhấn nút Home
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        // Xử lý khi nhấn nút Settings
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        // Xử lý khi nhấn nút Notifications
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.exit_to_app),
                      onPressed: () {
                        // Xử lý khi nhấn nút Logout
                      },
                    ),
                  ],
                ),
              ],
            )
          : Center(
              heightFactor: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Bạn chưa đăng nhập',
                    style: TextStyle(
                      letterSpacing: 0.60,
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    width: 130,
                    child: Divider(
                      color: Colors.black,
                      thickness: 3,
                    ),
                  ),
                  GlobalButton.buildButton(context,
                      title: 'Đăng nhập',
                      btnColor: GlobalColors.accept,
                      txtColor: Colors.white, onPress: () {
                    Get.to(LoginScreen());
                  }),
                  const SizedBox(height: 10),
                  GlobalButton.buildButton(context,
                      title: 'Tạo tài khoản',
                      btnColor: GlobalColors.warning,
                      txtColor: Colors.white, onPress: () {
                    Get.to(SignUpScreen());
                  }),
                ],
              ),
            ),
    );
  }
}