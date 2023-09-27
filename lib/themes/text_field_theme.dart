import 'package:documents_app/themes/global_colors.dart';
import 'package:flutter/material.dart';

class TextFieldThem {
  const TextFieldThem(Key? key);

  static buildTextField(
      {required String title,
      required TextEditingController controller,
      IconData? icon,
      required String? Function(String?) validators,
      TextInputType textInputType = TextInputType.text,
      bool obscureText = true,
      bool enabled = true,
      EdgeInsets contentPadding = EdgeInsets.zero,
      maxLine = 1,
      maxLength = 300,
      String? labelText}) {
    return TextFormField(
      obscureText: !obscureText,
      validator: validators,
      keyboardType: textInputType,
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      maxLines: maxLine,
      maxLength: maxLength,
      enabled: enabled,
      decoration: InputDecoration(
          counterText: "",
          labelText: labelText,
          hintText: title,
          contentPadding: contentPadding,
          suffixIcon: Icon(icon),
          border: const UnderlineInputBorder()),
    );
  }

  static boxBuildTextField(
      {required String labelText,
      required TextEditingController controller,
      String? Function(String?)? validators,
      TextInputType textInputType = TextInputType.text,
      bool obscureText = true,
      EdgeInsets contentPadding = EdgeInsets.zero,
      maxLine = 1,
      maxLength = 300,
      bool readOnly = false,
      VoidCallback? ontap}) {
    return TextFormField(
      onTap: ontap,
      readOnly: readOnly,
      obscureText: !obscureText,
      validator: validators,
      keyboardType: textInputType,
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      maxLines: maxLine,
      maxLength: maxLength,
      decoration: InputDecoration(
        counterText: "",
        contentPadding: const EdgeInsets.all(8),
        fillColor: Colors.white,
        filled: true,
        // focusedBorder: OutlineInputBorder(
        //   borderSide:
        //       BorderSide(color: GlobalColors.textFieldBoarderColor, width: 0.7),
        // ),
        // enabledBorder: OutlineInputBorder(
        //   borderSide:
        //       BorderSide(color: GlobalColors.textFieldBoarderColor, width: 0.7),
        // ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: GlobalColors.textFieldBoarderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: GlobalColors.appColor),
        ),
        errorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: GlobalColors.textFieldBoarderColor, width: 0.7),
        ),
        border: OutlineInputBorder(
          borderSide:
              BorderSide(color: GlobalColors.textFieldBoarderColor, width: 0.7),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black87),
      ),
    );
  }
}
