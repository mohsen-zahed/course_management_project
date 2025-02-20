import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/helpers/theme_helpers.dart';
import 'package:course_management_project/utils/app_theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.prefixIcon,
    required this.suffixIcon,
    this.showPassword,
    required this.hintText,
    this.onChanged,
    this.validator,
    this.onSubmit,
    required this.controller,
    this.keyboardInputType,
    this.onSuffixIconTap,
    this.focusNode,
  });
  final FocusNode? focusNode;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final bool? showPassword;
  final String hintText;
  final Function(String value)? onChanged;
  final String? Function(String? value)? validator;
  final Function(String value)? onSubmit;
  final TextEditingController controller;
  final TextInputType? keyboardInputType;
  final VoidCallback? onSuffixIconTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: sizeConstants.buttonHeightLarge,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacingXXSmall, vertical: sizeConstants.spacingXXSmall),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            color: kBlackColor12,
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.circular(15),
        color: isThemeLight(context) ? kGreyColor300 : kGreyColor700,
      ),
      child: Center(
        child: TextFormField(
          keyboardType: keyboardInputType ?? TextInputType.text,
          obscureText: showPassword ?? true,
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          onFieldSubmitted: onSubmit,
          cursorErrorColor: kRedColor,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: isThemeLight(context) ? kGreyColor700 : kGreyColor400, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: hintText,
            labelStyle: const TextStyle(color: kRedColor),
            hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kGreyColor500),
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            prefixIcon: Icon(prefixIcon, color: kGreyColor400, size: sizeConstants.iconMedium),
            suffixIcon: GestureDetector(
                onTap: onSuffixIconTap, child: Icon(suffixIcon, color: kGreyColor400, size: sizeConstants.iconMedium)),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
