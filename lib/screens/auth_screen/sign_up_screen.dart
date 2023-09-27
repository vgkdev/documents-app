import 'package:documents_app/constants/constants.dart';
import 'package:documents_app/controllers/sign_up_controller.dart';
import 'package:documents_app/themes/global_button.dart';
import 'package:documents_app/themes/global_colors.dart';
import 'package:documents_app/themes/text_field_theme.dart';
import 'package:documents_app/utils/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final controller = Get.put(SignUpController());

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
                    image: AssetImage("assets/images/sign_up_img.png"),
                    fit: BoxFit.cover,
                  ),
                  const Text(
                    'ĐĂNG KÍ MỚI',
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
                              if (value!.isNotEmpty) {
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
                              if (value!.isNotEmpty) {
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
                          child: TextFieldThem.boxBuildTextField(
                            labelText: "Xác nhận mặt khẩu",
                            obscureText: false,
                            validators: (String? value) {
                              if (value!.isNotEmpty) {
                                if (value == passwordController.text) {
                                  return null;
                                } else {
                                  return Constants.passwordNotMatch;
                                }
                              } else {
                                return Constants.invalidMessage;
                              }
                            },
                            controller: confirmPasswordController,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 200,
                                  child: TextFieldThem.boxBuildTextField(
                                    labelText: "Tên",
                                    validators: (String? value) {
                                      if (value!.isNotEmpty) {
                                        return null;
                                      } else {
                                        return Constants.invalidMessage;
                                      }
                                    },
                                    controller: firstNameController,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 200,
                                  child: TextFieldThem.boxBuildTextField(
                                    labelText: "Họ",
                                    validators: (String? value) {
                                      if (value!.isNotEmpty) {
                                        return null;
                                      } else {
                                        return Constants.invalidMessage;
                                      }
                                    },
                                    controller: lastNameController,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: GlobalColors.textFieldBoarderColor),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            padding: const EdgeInsets.only(left: 10),
                            child: InternationalPhoneNumberInput(
                              countries: const ["VN"],
                              onInputChanged: (PhoneNumber number) {
                                controller.phoneNumber.value =
                                    number.phoneNumber.toString();
                              },
                              onInputValidated: (bool value) {
                                print('>>>check value validate: ${value}');
                                controller.isPhoneValid.value = value;
                              },
                              ignoreBlank: true,
                              // autoValidateMode: AutovalidateMode.onUserInteraction,
                              inputDecoration: const InputDecoration(
                                hintText: 'Số điện thoại',
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              selectorConfig: const SelectorConfig(
                                  selectorType: PhoneInputSelectorType.DIALOG),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GlobalButton.buildBorderButton(
                            context,
                            btnWidthRatio: 1,
                            title: "Đăng kí",
                            btnColor: GlobalColors.appColor,
                            btnBorderColor: GlobalColors.appColor,
                            txtColor: Colors.white,
                            onPress: () {
                              if (_formKey.currentState!.validate()) {
                                final Map<String, dynamic> body = {
                                  'email': emailController.text,
                                  'password': passwordController.text,
                                };
                                controller.signUp(body).then((value) {
                                  if (value != null) {
                                    // print('>>>check sign up successful');
                                    final Map<String, dynamic> body = {
                                      "userId": value.user!.uid,
                                      "email": value.user!.email,
                                      "firstName": firstNameController.text,
                                      "lastName": lastNameController.text,
                                      "phone": controller.phoneNumber.value,
                                    };
                                    controller.addUserData(body);
                                  } else {
                                    CommonWidget.showSnackBarAlert(
                                        message: controller.errorMessage.value,
                                        color: GlobalColors.error);
                                  }
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
