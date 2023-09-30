import 'dart:convert';

import 'package:documents_app/constants/constants.dart';
import 'package:documents_app/controllers/login_controller.dart';
import 'package:documents_app/controllers/navigation_controller.dart';
import 'package:documents_app/routers/navigation.dart';
import 'package:documents_app/themes/global_button.dart';
import 'package:documents_app/themes/global_colors.dart';
import 'package:documents_app/themes/text_field_theme.dart';
import 'package:documents_app/utils/Preferences.dart';
import 'package:documents_app/utils/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          heightFactor: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  const Image(
                    image: AssetImage("assets/images/login_bg.png"),
                    fit: BoxFit.cover,
                  ),
                  // Image.asset(
                  //   "./assets/images/login_bg.png",
                  //   width: 100,
                  //   height: 100,
                  //   fit: BoxFit.contain,
                  // ),
                  const Text(
                    'Đăng Nhập Với Email',
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
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFieldThem.boxBuildTextField(
                            labelText: "Email",
                            validators: (String? value) {
                              if (value != null || value!.isNotEmpty) {
                                return null;
                              } else {
                                return Constants.invalidMessage;
                              }
                            },
                            controller: emailController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFieldThem.boxBuildTextField(
                            labelText: "Mặt khẩu",
                            obscureText: false,
                            validators: (String? value) {
                              if (value != null || value!.isNotEmpty) {
                                return null;
                              } else {
                                return Constants.invalidMessage;
                              }
                            },
                            controller: passwordController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GlobalButton.buildBorderButton(
                            context,
                            btnWidthRatio: 1,
                            title: "Đăng nhập",
                            btnColor: GlobalColors.appColor,
                            btnBorderColor: GlobalColors.appColor,
                            txtColor: Colors.white,
                            onPress: () {
                              if (_formKey.currentState!.validate()) {
                                final Map<String, dynamic> body = {
                                  'email': emailController.text,
                                  'password': passwordController.text,
                                };
                                controller.loginUser(body).then((value) async {
                                  if (value != null) {
                                    print('>>>check sign up successful');
                                    Preferences.setString(Preferences.userId,
                                        value.data!.id.toString());
                                    Preferences.setString(
                                        Preferences.user, jsonEncode(value));
                                    await Preferences.setUserData(value);
                                    Preferences.setBoolean(
                                        Preferences.isLogin, true);
                                    CommonWidget.showSnackBarAlert(
                                        message: 'Đăng kí thành công',
                                        color: GlobalColors.accept,
                                        icon: Icons.check);

                                    NavigationController navigationController =
                                        Get.put(NavigationController());
                                    navigationController.isLogin.value =
                                        Preferences.getBoolean(
                                            Preferences.isLogin);
                                    Get.offAll(
                                      () => Navigation(),
                                      // duration:
                                      //     const Duration(milliseconds: 400),
                                      // transition: Transition.rightToLeft,
                                    );
                                    // CommonFunction.goHomeScreen();
                                  } else {
                                    CommonWidget.showSnackBarAlert(
                                      message: controller.errMessage.value,
                                      color: GlobalColors.error,
                                    );
                                  }
                                  // final Map<String, dynamic> body = {
                                  //   "userId": value.user!.uid,
                                  //   "email": value.user!.email,
                                  //   "firstName": firstNameController.text,
                                  //   "lastName": lastNameController.text,
                                  //   "phone": controller.phoneNumber.value,
                                  // };
                                  // controller
                                  //     .addUserData(body)
                                  //     .then((value) async {
                                  //   print(
                                  //       '>>>check value add user data: ${value}');
                                  //   if (value != null) {
                                  //     Preferences.setString(
                                  //         Preferences.userId,
                                  //         value.data!.id.toString());
                                  //     Preferences.setString(Preferences.user,
                                  //         jsonEncode(value));
                                  //     await Preferences.setUserData(value);
                                  //     Preferences.setBoolean(
                                  //         Preferences.isLogin, true);
                                  //     CommonWidget.showSnackBarAlert(
                                  //         message: 'Đăng kí thành công',
                                  //         color: GlobalColors.accept,
                                  //         icon: Icons.check);
                                  //     Get.offAll(
                                  //       Navigation(),
                                  //       duration:
                                  //           const Duration(milliseconds: 400),
                                  //       transition: Transition.rightToLeft,
                                  //     );
                                  //   } else {
                                  //     CommonWidget.showSnackBarAlert(
                                  //       message:
                                  //           controller.errorMessage.value,
                                  //       color: GlobalColors.error,
                                  //     );
                                  //   }
                                  // });
                                  // } else {
                                  //   CommonWidget.showSnackBarAlert(
                                  //     message: controller.errMessage.value,
                                  //     color: GlobalColors.error,
                                  //   );
                                  // }
                                });
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
