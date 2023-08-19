import 'package:flutter/material.dart';
import 'package:job_platform_web/src/features/auth/login/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform_web/src/features/auth/sign_up/signup_screen.dart';
import 'package:job_platform_web/src/features/profile/profile_screen.dart';

import 'constants/app_colors.dart';

class JopPlatformWeb extends StatelessWidget {
  const JopPlatformWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.aBeeZee().fontFamily,
        primarySwatch:
            ConvertToMaterialColor.getMaterialColor(AppColors.primary.value),
      ).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 60.0),
          ),
        ),
      ),
      home: ProfileScreen(),
      // home: SignUpScreen(),
      // home: LoginScreen(),
    );
  }
}
