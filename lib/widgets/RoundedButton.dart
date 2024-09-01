import 'package:flutter/material.dart';
import 'package:hiring_task/utils/AppColors.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final double? height;
  final Color? color;

  const RoundedButton({super.key, this.color, required this.text, required this.press, this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: InkWell(
        onTap: press,
        child: Container(
          height: height ?? 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: color ?? AppColors.primary,
          ),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
