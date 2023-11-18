import 'package:documents_app/controllers/navigation_controller.dart';
import 'package:documents_app/controllers/profile_controller.dart';
import 'package:documents_app/routers/navigation.dart';
import 'package:documents_app/themes/global_button.dart';
import 'package:documents_app/themes/global_colors.dart';
import 'package:documents_app/themes/responsive.dart';
import 'package:documents_app/utils/Preferences.dart';
import 'package:documents_app/utils/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalInformation extends StatefulWidget {
  PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  final profileController = Get.put(ProfileController());
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();

  late FocusNode firstNameFocus;
  late FocusNode lastNameFocus;

  @override
  void initState() {
    super.initState();
    firstNameFocus = FocusNode();
    lastNameFocus = FocusNode();
    firstName.text = profileController.firstName.value;
    lastName.text = profileController.lastName.value;
  }

  @override
  void dispose() {
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: GlobalColors.background,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: GlobalColors.appColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                Get.back();
              },
            ),
            title: const Text(
              'Thông tin cá nhân',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    Preferences.clearKeyData(Preferences.isLogin);
                    Preferences.clearKeyData(Preferences.user);
                    Preferences.clearKeyData(Preferences.userId);

                    NavigationController navigationController =
                        Get.put(NavigationController());
                    navigationController.isLogin.value =
                        Preferences.getBoolean(Preferences.isLogin);
                    Get.offAll(
                      () => Navigation(),
                      // duration: const Duration(milliseconds: 400),
                      // transition: Transition.rightToLeft,
                    );
                  },
                  child: const Text('Đăng xuất'),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: GlobalColors.appColor,
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
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(children: [
                          profileTile(
                            profileController: controller,
                            label: 'Họ',
                            data: controller.firstName.toString(),
                            textController: firstName,
                            focus: firstNameFocus,
                            hangdleOnChange: controller.handleChangeFirstName,
                          ),
                          Divider(
                            height: 1,
                            color: Colors.grey,
                            indent: Responsive.width(5.0, context),
                            endIndent: Responsive.width(5.0, context),
                          ),
                          profileTile(
                            profileController: controller,
                            label: 'Tên',
                            data: controller.lastName.toString(),
                            textController: lastName,
                            focus: lastNameFocus,
                            hangdleOnChange: controller.handleChangeLastName,
                          ),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      if (controller.hasChangedFirstName.value == true ||
                          controller.hasChangedLastName.value == true)
                        GlobalButton.buildBorderButton(
                          context,
                          title: "Cập nhật",
                          btnColor: GlobalColors.appColor,
                          btnBorderColor: GlobalColors.appColor,
                          txtColor: Colors.white,
                          onPress: () {
                            final Map<String, dynamic> body = {
                              "userId":
                                  Preferences.getString(Preferences.userId),
                              "firstName": firstName.text,
                              "lastName": lastName.text,
                            };
                            controller.updateUserData(body).then((value) async {
                              print(
                                  '>>>check update user data: ${value!.toJson()}');
                              if (value.data != null) {
                                CommonWidget.showSnackBarAlert(
                                    message: 'Cập nhật thành công',
                                    color: GlobalColors.accept,
                                    icon: Icons.check);
                                await Preferences.setUserData(value);
                                controller.getUserData();
                                controller.reset();
                              }
                            });
                          },
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget profileTile({
    required ProfileController profileController,
    required String label,
    required String? data,
    required TextEditingController textController,
    required FocusNode? focus,
    Function? hangdleOnChange,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 3.0,
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Text(label),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: TextFormField(
                controller: textController,
                // initialValue: data ?? "",
                textAlign: TextAlign.end,
                focusNode: focus,
                readOnly: !enabled,
                onChanged: (value) {
                  hangdleOnChange!(value);
                },
                onTapOutside: (event) {
                  textController.selection = TextSelection.fromPosition(
                      TextPosition(offset: textController.text.length));
                  focus?.unfocus();
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          if (enabled)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                focus?.requestFocus();
                textController.selection = TextSelection.fromPosition(
                    TextPosition(offset: textController.text.length));
              },
            ),
        ],
      ),
    );
  }
}
