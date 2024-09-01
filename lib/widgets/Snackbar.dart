import 'package:flutter/material.dart';
import 'package:hiring_task/utils/AppColors.dart';

void showSnacBar(
  BuildContext context, {
  required String content,
  Duration duration = const Duration(milliseconds: 3000),
  bool error = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: duration,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: error ? AppColors.textPrimary : Colors.red,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      content: error
          ? Text(content, style: errorTextStyle)
          : Text(
              content,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
    ),
  );
}

const TextStyle errorTextStyle = TextStyle(
  color: Colors.redAccent,
);
