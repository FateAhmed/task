import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hiring_task/utils/AppColors.dart';

void showLoadingHUD(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return loaderWidget();
    },
  );
}

loaderWidget() {
  return const PopScope(
    canPop: false,
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 30,
      ),
      child: SpinKitSpinningLines(color: AppColors.primary, size: 60),
    ),
  );
}
