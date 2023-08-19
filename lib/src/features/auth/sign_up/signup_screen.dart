import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:job_platform_web/src/constants/app_colors.dart';
import 'package:job_platform_web/src/constants/assets_manager.dart';
import 'package:job_platform_web/src/features/auth/login/login_screen.dart';
import 'package:job_platform_web/src/widgets/textfiled_app.dart';

import '../../../../translations/locale_keys.g.dart';
import '../../../constants/const.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final codeNumberController = TextEditingController();
  final genderController = TextEditingController();
  final dataBirthController = TextEditingController();
  final nameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  String gender = "";

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
                color: AppColors.secondary.withOpacity(.5),
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
                        'Start With Us!',
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
                                  'Sign Up',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: size.width / 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                'Name',
                                style: TextStyle(
                                  fontSize: size.height / 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: gabH,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: CustomTextFiled(
                                      controller: firstNameController,
                                      validator: (String? value) =>
                                          FormValidator.validateName(value),
                                      iconData: Icons.person_outline,
                                      hintText: 'First Name',
                                    ),
                                  ),
                                  SizedBox(
                                    width: gabH,
                                  ),
                                  Expanded(
                                    child: CustomTextFiled(
                                      controller: lastNameController,
                                      validator: (String? value) =>
                                          FormValidator.validateName(value),
                                      iconData: Icons.person_outline,
                                      hintText: 'Last Name',
                                    ),
                                  )

                                  // ),
                                ],
                              ),
                              SizedBox(
                                height: gabH,
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
                                'Phone Number',
                                style: TextStyle(
                                  fontSize: size.height / 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: gabH,
                              ),
                              Stack(
                                children: [
                                  IntlPhoneField(
                                    pickerDialogStyle: PickerDialogStyle(
                                        searchFieldInputDecoration:
                                            InputDecoration(
                                                hintText: 'Search Country',
                                                suffixIcon:
                                                    Icon(Icons.search))),

                                    controller: phoneController,
                                    disableLengthCheck: true,
                                    invalidNumberMessage:
                                        tr(LocaleKeys.enter_valid_phone),
                                    validator: (phoneNumber) =>
                                        FormValidator.phoneValidator(
                                            phoneNumber!.number),
                                    //todo: change by language[arabic start , english end]
                                    textAlign: TextAlign.start,
                                    flagsButtonMargin:
                                        EdgeInsets.symmetric(horizontal: gabW),
                                    showDropdownIcon: false,
                                    initialCountryCode: 'SY',
                                    decoration: InputDecoration(
                                      hintText: 'Phone Number',
                                    ),
                                    onCountryChanged: (val) {
                                      codeNumberController.text = val.dialCode;
                                    },
                                  ),
                                ],
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

                              ///
                              SizedBox(
                                height: gabH,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Gender',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: gabH,
                                      ),
                                      CustomTextFiled(
                                        controller: genderController,
                                        readOnly: true,
                                        onTap: () {
                                          Constants.showModalBottomSheetII(
                                              context,
                                              _modalBottomSheetContent(
                                                  context));
                                        },
                                        hintText: 'Gender',
                                        iconData: Icons.male,
                                      ),
                                    ],
                                  )),
                                  SizedBox(
                                    width: gabW,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date Of Birth',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: gabH,
                                      ),
                                      CustomTextFiled(
                                        readOnly: true,
                                        controller: dataBirthController,
                                        onTap: () {
                                          Constants.selectData(
                                            context: context,
                                            controller: dataBirthController,
                                          );
                                        },
                                        hintText: 'Date Of Birth',
                                        iconData: Icons.date_range,
                                      ),
                                    ],
                                  )),
                                ],
                              ),

                              SizedBox(
                                height: gabH,
                              ),
                              Text(
                                'Confirm Password',
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
                                controller: confirmPasswordController,
                                suffixIcon: true,
                                iconData: Icons.password,
                                hintText: 'Confirm Password',
                              ),

                              ///
                              SizedBox(
                                height: gabH * 2,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.secondary),
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
                                          builder: (ctx) => LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: Text.rich(TextSpan(children: [
                                      TextSpan(
                                          text: 'Already Have Account?',
                                          style: TextStyle(
                                              color: AppColors.secondary)),
                                      TextSpan(
                                          text: ' Login',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.secondary)),
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

  bool isMale = true;

  Widget _modalBottomSheetContent(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context, setState1) {
      final size = MediaQuery.of(context).size;
      final gabH = size.width * 0.015;
      final gabW = size.width * 0.015;
      return Column(
        children: [
          Spacer(),
          Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: gabH / 2, vertical: gabW / 2),
                width: double.infinity,
                height: size.height / 1.8,
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(gabH))),
                child: Column(
                  children: [
                    Text(
                      'What is your Gender?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: gabH,
                    ),
                    Text(
                      'Please choose your Gender, This Will be used to identify your needs.',
                      textAlign: TextAlign.center,
                      style: TextStyle(),
                    ),
                    SizedBox(
                      height: gabH,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                isMale = true;
                                setState1(() {});
                              },
                              child: Stack(
                                children: [
                                  AnimatedContainer(
                                    width: double.infinity,
                                    duration: const Duration(milliseconds: 300),
                                    padding: EdgeInsets.all(gabW),
                                    decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                AppColors.black.withOpacity(.1),
                                            blurRadius: isMale ? 8.0 : 0.0,
                                          )
                                        ]),
                                    child: Column(
                                      children: [
                                        Flexible(
                                          child: SvgPicture.asset(
                                            AssetsManager.manImage,
                                          ),
                                        ),
                                        SizedBox(
                                          height: gabH,
                                        ),
                                        Text(
                                          'Male',
                                          style: TextStyle(),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      backgroundColor: isMale
                                          ? AppColors.manColor
                                          : AppColors.lightGray,
                                      radius: gabW,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: gabH,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                isMale = false;
                                setState1(() {});
                              },
                              child: Stack(
                                children: [
                                  AnimatedContainer(
                                    width: double.infinity,
                                    duration: const Duration(milliseconds: 300),
                                    padding: EdgeInsets.all(gabW),
                                    decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                AppColors.black.withOpacity(.1),
                                            blurRadius: !isMale ? 8.0 : 0.0,
                                          )
                                        ]),
                                    child: Column(
                                      children: [
                                        Flexible(
                                          child: SvgPicture.asset(
                                            AssetsManager.womanImage,
                                          ),
                                        ),
                                        SizedBox(
                                          height: gabH,
                                        ),
                                        Text(
                                          'Female',
                                          style: TextStyle(),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      backgroundColor: !isMale
                                          ? AppColors.womanColor
                                          : AppColors.lightGray,
                                      radius: gabW,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: gabH,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary),
                      onPressed: () {
                        // isMale
                        //     ? genderController.text =
                        //         tr(LocaleKeys.gender_male)
                        //     : genderController.text =
                        //         tr(LocaleKeys.gender_female);
                        setState1(() {});
                        Navigator.of(context, rootNavigator: true).pop(true);
                      },
                      child: Text('Select'),
                    )
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(true);
                  },
                  icon: Icon(Icons.close))
            ],
          )
        ],
      );
    });
  }
}
