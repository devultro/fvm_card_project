import 'package:flutter/material.dart';

import '../../utils/colors/custom_color.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final int? maxLength;
  final bool obscureText;
  final bool redonly;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final int? maxline;
  final FocusNode? focusNode;
  final String? Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const MyTextField(
      {super.key,
      this.controller,
      this.hintText,
      required this.obscureText,
      this.keyboardType,
      this.suffixIcon,
      this.onTap,
      this.prefixIcon,
      this.focusNode,
      this.onChanged,
      this.validator,
      this.maxline,
      required this.redonly,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      validator: validator,
      onTap: onTap,
      maxLength: maxLength,
      readOnly: redonly,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: CustomColors.textBg),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: CustomColors.textBg),
        ),
        fillColor: CustomColors.textBg,
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(
            color: CustomColors.txtBlack,
            fontFamily: "RedHatDisplay",
            fontSize: 16,
            fontWeight: FontWeight.w500),
      ),
      style: const TextStyle(
          color: CustomColors.black,
          fontFamily: "RedHatDisplay",
          fontSize: 19,
          fontWeight: FontWeight.w700),
    );
  }
}
