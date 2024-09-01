import 'package:flutter/material.dart';

class GoogleSigninButton extends StatelessWidget {
  final Function() callback;
  const GoogleSigninButton({super.key, required this.callback});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0XFFFAFAFA),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: const Color(0XFFEEEEEE)),
        ),
        child: const Image(
          image: AssetImage('assets/images/google.png'),
          height: 40,
          width: 40,
        ),
      ),
    );
  }
}
