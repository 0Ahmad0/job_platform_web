import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xff334F76);
  static const secondary = Color(0xffB20B27);
  static const primaryDark = Color(0xff010A2A);
  static const secondaryDark = Color(0xff8E0000);
  static const white = Colors.white;
  static const black = Colors.black;
  static const error = Colors.red;
  static const success = Colors.green;
  static const hint = Colors.grey;
  static const lightGray = Color(0xffB7B7B7);
  static const textFormFiledColor = Color(0xffE4E4E4);
  static const manColor = Color(0xff6DBF6B);
  static const womanColor = Color(0xffF4B467);
  static const shadowColor = Color(0xffc4c4c4);
}

class ConvertToMaterialColor {
  //change to your color
  static Map<int, Color> mapColor = {
    50: Color.fromRGBO(51, 153, 255, .1),
    100: Color.fromRGBO(51, 153, 255, .2),
    200: Color.fromRGBO(51, 153, 255, .3),
    300: Color.fromRGBO(51, 153, 255, .4),
    400: Color.fromRGBO(51, 153, 255, .5),
    500: Color.fromRGBO(51, 153, 255, .6),
    600: Color.fromRGBO(51, 153, 255, .7),
    700: Color.fromRGBO(51, 153, 255, .8),
    800: Color.fromRGBO(51, 153, 255, .9),
    900: Color.fromRGBO(51, 153, 255, 1),
  };

  static MaterialColor getMaterialColor(int myColor) {
    return MaterialColor(myColor, mapColor);
  }
}
