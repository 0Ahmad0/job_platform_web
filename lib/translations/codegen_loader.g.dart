// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> ar = {
  "ok": "نعم",
  "field_required": "هذالحقل مطلوب!",
  "enter_valid_email": "أدخل ايميل صحيح!",
  "enter_valid_phone": "أدخل رقم هاتف صحيح!",
  "enter_strong_password_length": "أدخل كلمة مرور قوية!",
  "password_do_not_match": "كلمة المرور غير متطابقة!"
};
static const Map<String,dynamic> en = {
  "ok": "Ok",
  "field_required": "The Field Required!",
  "enter_valid_email": "Enter Valid Email!",
  "enter_valid_phone": "Enter Valid Phone!",
  "enter_strong_password_length": "Enter Strong Password Length!",
  "password_do_not_match": "Password Do not Match!"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ar": ar, "en": en};
}
