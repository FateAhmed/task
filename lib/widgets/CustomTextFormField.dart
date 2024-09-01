import 'package:flutter/material.dart';
import 'package:hiring_task/utils/AppColors.dart';
import 'package:hiring_task/utils/AppStyles.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? title;
  final Function? onTap;
  final Function? onChange;
  final Function? onFieldSubmitted;
  final bool readOnly;
  final bool required = true;
  final double bottomPadding;
  final bool obscure;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final bool isForm;
  final bool autoFocus;
  final int? maxLines;
  final FocusNode focusNode;
  final Function validator;
  final Icon? icon;
  final Function? iconPressed;
  final InputDecoration? inputDecoration;
  final EdgeInsets? contentPadding;
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.validator,
    this.inputDecoration,
    this.iconPressed,
    this.icon,
    this.hintText = '',
    this.title,
    this.maxLines = 1,
    this.onTap,
    this.onChange,
    this.onFieldSubmitted,
    this.textInputType = TextInputType.text,
    this.autoFocus = false,
    this.obscure = false,
    this.bottomPadding = 16,
    this.textInputAction = TextInputAction.done,
    this.isForm = false,
    this.readOnly = false,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null && iconPressed == null) {
      throw 'Icon pressed parameter is required while using suffix icon';
    }
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      cursorColor: AppColors.textPrimary,
      readOnly: readOnly,
      style: const TextStyle(color: Color(0XFF8A8A8E), fontStyle: FontStyle.italic, fontSize: 15),
      decoration: inputDecoration ??
          TextFieldStyle.underline().copyWith(
            suffixIcon: icon != null
                ? GestureDetector(
                    onTap: () => iconPressed!(),
                    child: icon,
                  )
                : null,
            suffixIconColor: AppColors.textPrimary,
            labelText: title,
            contentPadding: contentPadding,
          ),
      obscureText: obscure,
      onFieldSubmitted: (val) {
        if (onFieldSubmitted != null) onFieldSubmitted!(val);
      },
      maxLines: maxLines,
      focusNode: focusNode,
      autofocus: autoFocus,
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.disabled,
      validator: (value) => validator(value),
      onTapOutside: (event) => focusNode.unfocus(),
      onChanged: (a) => onChange != null ? onChange!(a) : () {},
      onTap: () => onTap != null ? onTap!() : () {},
    );
  }
}
