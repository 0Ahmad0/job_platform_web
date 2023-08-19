import 'package:flutter/material.dart';
import 'package:job_platform_web/src/constants/app_colors.dart';
import 'package:job_platform_web/src/constants/assets_manager.dart';
import 'package:job_platform_web/src/features/auth/sign_up/signup_screen.dart';
import 'package:job_platform_web/src/widgets/textfiled_app.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final gabH = size.width * 0.015;
    final gabW = size.width * 0.015;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AssetsManager.backAuthImage,
            fit: BoxFit.cover,
            width: size.width,
            height: size.height,
          ),
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.5),
            ),
          ),
          Center(
            child: Container(
              width: size.width / 2,
              height: size.height,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.5),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(gabH),
                      child: Text(
                        'Hello',
                        style: TextStyle(
                          fontSize: size.width / 28,
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(gabH),
                      child: Text(
                        'You Are Welcome!',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: size.width / 30,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(gabH),
                      width: double.infinity,
                      height: size.height,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(gabW),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: size.width / 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                'Email Address',
                                style: TextStyle(
                                  fontSize: size.height / 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: gabH,
                              ),
                              CustomTextFiled(
                                controller: emailController,
                                iconData: Icons.email,
                                hintText: 'Email',
                              ),
                              SizedBox(
                                height: gabH,
                              ),
                              Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: size.height / 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: gabH,
                              ),
                              CustomTextFiled(
                                obscureText: true,
                                controller: passwordController,
                                suffixIcon: true,
                                iconData: Icons.password,
                                hintText: 'Password',
                              ),
                              SizedBox(
                                height: gabH * 2,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {}
                                  },
                                  child: Text('Login')),
                              SizedBox(
                                height: gabH,
                              ),
                              Center(
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) => SignUpScreen(),
                                        ),
                                      );
                                    },
                                    child: Text.rich(TextSpan(children: [
                                      TextSpan(text: 'Don\'t Have Account?'),
                                      TextSpan(
                                          text: ' Sign Up',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary)),
                                    ]))),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
