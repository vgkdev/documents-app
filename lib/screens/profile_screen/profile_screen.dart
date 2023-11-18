import 'package:documents_app/controllers/navigation_controller.dart';
import 'package:documents_app/controllers/profile_controller.dart';
import 'package:documents_app/routers/navigation.dart';
import 'package:documents_app/screens/auth_screen/login_screen.dart';
import 'package:documents_app/screens/auth_screen/sign_up_screen.dart';
import 'package:documents_app/screens/profile_screen/personal_infomation.dart';
import 'package:documents_app/themes/global_button.dart';
import 'package:documents_app/themes/global_colors.dart';
import 'package:documents_app/themes/responsive.dart';
import 'package:documents_app/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: controller.isLogin.value
              ? Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: GlobalColors.appColor,
                      // decoration: BoxDecoration(
                      //     gradient: LinearGradient(colors: [
                      //   GlobalColors.appColor,
                      //   GlobalColors.accept
                      // ])),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 50.0,
                            child: Icon(
                              Icons.person,
                              size: 80,
                            ),
                            // backgroundImage: NetworkImage('URL_AVATAR_IMAGE'),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            "${controller.firstName.value} ${controller.lastName.value}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          profileTile(
                            icon: Icons.person,
                            title: 'Thông tin cá nhân',
                            onPress: () {
                              Get.to(PersonalInformation());
                            },
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(children: [
                              profileTile(
                                icon: Icons.my_library_books_sharp,
                                title: 'Tài liệu đã đăng',
                                onPress: () {},
                              ),
                              Divider(
                                height: 1,
                                color: Colors.grey,
                                indent: Responsive.width(5.0, context),
                                endIndent: Responsive.width(5.0, context),
                              ),
                              profileTile(
                                icon: Icons.notifications,
                                title: 'Thông báo',
                                onPress: () {},
                              ),
                            ]),
                          ),
                        ],
                      ),
                    )
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
      },
    );
  }

  Widget profileTile({
    required IconData icon,
    required String title,
    required Function()? onPress,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.0),
      onTap: onPress,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title),
              ),
              const Icon(Icons.keyboard_arrow_right),
            ],
          ),
        ),
      ),
    );
  }
}
