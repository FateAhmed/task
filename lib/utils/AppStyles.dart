import 'package:flutter/material.dart';
import 'AppColors.dart';

class AppStyle {
  static BoxDecoration cirularContainer() {
    return BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(5),
    );
  }

  static BoxDecoration cirularTransparentContainer() {
    return BoxDecoration(
      color: AppColors.background.withOpacity(0.5),
      borderRadius: BorderRadius.circular(5),
    );
  }
}

class TextFieldStyle {
  static InputDecoration underline() {
    return const InputDecoration(
      filled: true,
      fillColor: AppColors.backgroundSecondary,
      prefixIconColor: AppColors.backgroundSecondary,
      labelStyle: TextStyle(color: Color(0XFF8A8A8E), fontSize: 12),
      hintStyle: TextStyle(color: Color.fromARGB(255, 72, 72, 122)),
      contentPadding: EdgeInsets.symmetric(vertical: 12),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.secondary),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.secondary),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.redError),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.redError),
      ),
    );
  }

  static InputDecoration outlined() {
    return const InputDecoration(
      filled: true,
      prefixIconColor: AppColors.backgroundSecondary,
      labelStyle: TextStyle(color: Color(0XFF8A8A8E), fontSize: 12),
      hintStyle: TextStyle(color: Color(0XFF8A8A8E)),
      fillColor: Color(0XFFFAFAFA),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0XFFEEEEEE)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0XFFEEEEEE)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.redError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.redError),
      ),
    );
  }
}
