import 'package:documents_app/constants/constants.dart';
import 'package:documents_app/themes/global_button.dart';
import 'package:documents_app/themes/global_colors.dart';
import 'package:documents_app/themes/text_field_theme.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                            onPress: () {},
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
