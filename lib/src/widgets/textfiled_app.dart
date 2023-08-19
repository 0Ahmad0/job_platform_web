import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '/translations/locale_keys.g.dart';

class CustomTextFiled extends StatefulWidget {
  CustomTextFiled(
      {Key? key,
      this.textInputAction = TextInputAction.next,
      this.keyboardType = TextInputType.text,
      this.controller,
      this.iconData,
      this.hintText,
      this.obscureText = false,
      this.suffixIcon = false,
      this.validator,
      this.onChanged,
      this.onTap,
      this.autofocus = false,
      this.readOnly = false,
      this.maxline = 1,
      this.iconPrimary = false,
      this.minline = 1,
      this.onFieldSubmitted,
      this.onTapOutside})
      : super(key: key);

  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final IconData? iconData;
  final String? hintText;
  final bool suffixIcon;
  final bool autofocus;
  final bool readOnly;
  bool obscureText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final Function(String)? onFieldSubmitted;
  final Function(PointerDownEvent)? onTapOutside;
  final int? maxline;
  final int? minline;
  bool iconPrimary;

  @override
  State<CustomTextFiled> createState() => _CustomTextFiledState();
}

class _CustomTextFiledState extends State<CustomTextFiled> {
  void _showPassword() {
    setState(() {
      widget.obscureText = !widget.obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: widget.onTapOutside,
      onFieldSubmitted: widget.onFieldSubmitted,
      maxLines: widget.maxline,
      minLines: widget.minline,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      validator: widget.validator ??
          (String? val) {
            if (val!.trim().isEmpty) return tr(LocaleKeys.field_required);
            return null;
          },
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      style: TextStyle(fontSize: 14),
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.textFormFiledColor,
          border: OutlineInputBorder(
              borderSide: BorderSide(
            width: 0.0,
            color: Colors.transparent,
          )),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                width: 0.0,
                color: AppColors.error,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.transparent, width: 0.0)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                width: 0.0,
                color: AppColors.error,
              )),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 0.0)),
          hintStyle: TextStyle(fontSize: 14, color: AppColors.hint),
          prefixIcon: widget.iconData == null
              ? null
              : Icon(
                  widget.iconData,
                  size: 24,
                  color: widget.iconPrimary
                      ? Theme.of(context).primaryColor
                      : IconThemeData().color,
                ),
          suffixIcon: widget.suffixIcon
              ? IconButton(
                  onPressed: () => _showPassword(),
                  icon: Icon(
                    widget.obscureText
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: widget.obscureText
                        ? AppColors.hint
                        : AppColors.primaryDark,
                  ))
              : null,
          hintText: widget.hintText),
    );
  }
}

// form validator

class FormValidator {
  static RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  ///@Email Validator
  static String? emailValidator(String? value) {
    if (value!.trim().isEmpty) {
      return tr(LocaleKeys.field_required);
    }
    if (!value.contains('@')) {
      return tr(LocaleKeys.enter_valid_email);
    }

    return null;
  }

  ///@Phone Validator
  static String? phoneValidator(String? value) {
    if (value!.trim().isEmpty) {
      return tr(LocaleKeys.field_required);
    }
    // if (value.length != 10 || !value.startsWith('09')) {
    //   return tr(LocaleKeys.enter_valid_phone);
    // }
    if (value.length != 9) {
      return tr(LocaleKeys.enter_valid_phone);
    }

    return null;
  }

  ///@Password Validator
  static String? passwordValidator(String? value) {
    if (value!.trim().isEmpty) {
      return tr(LocaleKeys.field_required);
    }

    ///TODO hariri
    ///لقد اوقفت قوة كلمة المرور
    // if (!validatePassword(value)) {
    //   return tr(LocaleKeys.enter_strong_password);
    // }
    if (value.length < 8) {
      return tr(LocaleKeys.enter_strong_password_length);
    }

    return null;
  }

  ///@Password Validator
  static String? confirmPasswordValidator(
      String? password, String? confirmPassword) {
    if (password!.compareTo(confirmPassword!) != 0) {
      return tr(LocaleKeys.password_do_not_match);
    }
    if (confirmPassword.trim().isEmpty) {
      return tr(LocaleKeys.field_required);
    }
    return null;
  }

/*
  ///@cvvCard Validator
  static String? cvvCardValidator(String? val){
    if(val!.trim().isEmpty)
      return AppStringsManager.filed_Required;
    if(val.length != 3)
      return AppStringsManager.cvv_3letter;

    return null;
  }

  ///@cvvCard Validator
  static String? cardNumberValidator(String? val){
    if(val!.trim().isEmpty)
      return AppStringsManager.filed_Required;
    if(val.length != 16)
      return AppStringsManager.card_number_16letter;

    return null;
  }
*/

  ///@Helper Function
  static bool validatePassword(String value) {
    return regex.hasMatch(value);
  }

  static String? validateName(String? value) {
    if (value!.trim().isEmpty) {
      return tr(LocaleKeys.field_required);
    }
    return null;
  }
}
