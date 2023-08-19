import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:job_platform_web/src/features/create_resume/create_resume_screen.dart';

import '../../../translations/locale_keys.g.dart';
import '../../constants/const.dart';
import '../../widgets/textfiled_app.dart';
import 'widgets/profile_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final phoneControllerChange = TextEditingController();
  final genderController = TextEditingController();
  String gender = "";
  final dataBirthController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final gabH = size.width * 0.015;
    final gabW = size.width * 0.015;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Profile"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => CreateResumeScreen()));
              },
              icon: Icon(Icons.edit_document))
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: gabW),
          children: [
            ProfileImage(),
            SizedBox(
              height: gabH,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'First Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: gabH,
                    ),
                    CustomTextFiled(
                      iconPrimary: true,
                      validator: (value) => FormValidator.validateName(value),
                      controller: fNameController,
                      iconData: Icons.person,
                      hintText: 'First Name',
                    ),
                  ],
                )),
                SizedBox(
                  width: gabH,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Last Name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: gabH,
                    ),
                    CustomTextFiled(
                      iconPrimary: true,
                      validator: (value) => FormValidator.validateName(value),
                      controller: lNameController,
                      iconData: Icons.person,
                      hintText: 'Last Name',
                    ),
                  ],
                )),
              ],
            ),
            SizedBox(
              height: gabH,
            ),

            ///***************************
            Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: gabH,
            ),
            CustomTextFiled(
              iconPrimary: true,
              validator: (value) => FormValidator.emailValidator(value),
              controller: emailController,
              iconData: Icons.alternate_email,
              hintText: 'Email',
            ),
            SizedBox(
              height: gabH,
            ),

            ///***************************
            Text(
              'Phone',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: gabH,
            ),
            CustomTextFiled(
              readOnly: true,
              iconPrimary: true,
              //  validator: (value) => FormValidator.phoneValidator(value),
              controller: phoneController,
              iconData: Icons.phone_android_outlined,
              hintText: 'Phone',
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    String codeNumber = '963';
                    Constants.showModalBottomSheetII(
                        context,
                        Container(
                          padding: EdgeInsets.all(gabH),
                          height: size.height / 1.25,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(24)),
                            color: Theme.of(context).cardColor,
                          ),
                          child: Column(
                            children: [
                              Text('Phone Number'),
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

                                    controller: phoneControllerChange,
                                    disableLengthCheck: true,
                                    invalidNumberMessage:
                                        tr(LocaleKeys.enter_valid_phone),
                                    validator: (phoneNumber) =>
                                        FormValidator.phoneValidator(
                                            phoneNumber!.number),
                                    //todo: change by language[arabic start , english end]
                                    textAlign: TextAlign.start,

                                    showDropdownIcon: false,
                                    initialCountryCode: 'SY',
                                    decoration: InputDecoration(
                                      hintText: 'Phone',
                                    ),
                                    onCountryChanged: (val) {
                                      codeNumber = val.dialCode;
                                    },
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Padding(
                                padding: EdgeInsets.only(bottom: gabH),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        phoneController.text = '+' +
                                            codeNumber +
                                            phoneControllerChange.text;
                                        phoneControllerChange.clear();
                                        codeNumber = '963';
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('Save')),
                              ),
                            ],
                          ),
                        ));
                  },
                  child: Text('Change Phone'),
                ),
              ],
            ),

            ///***************************
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gender',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: gabH,
                    ),
                    CustomTextFiled(
                      iconPrimary: true,
                      controller: genderController,
                      readOnly: true,
                      onTap: () {
                        ///change gender
                        // Constants.showModalBottomSheet(
                        //     context, _modalBottomSheetContent(context));
                      },
                      hintText: 'Gender',
                      iconData: Icons.male,
                    ),
                  ],
                )),
                SizedBox(
                  width: gabH,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date Of Birth",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: gabH,
                    ),
                    CustomTextFiled(
                      iconPrimary: true,
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

            ///***************************
            SizedBox(
              height: gabH,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    // BlocProvider.of<UserCubit>(context).updateProfile(
                    //   context,
                    //   email: emailController.text,
                    //   firstName: fNameController.text,
                    //   lastName: lNameController.text,
                    //   gender: gender.toUpperCase(),
                    //   phoneNumber: phoneController.text,
                    //   birthDate: dataBirthController.text,
                    //   //image: ImageAssets.imageProfile
                    // );
                  }
                },
                child: Text('Refresh')),
            Row(
              children: [
                // TextButton(
                //     onPressed: () {
                //       Constants.showModalBottomSheetII(
                //         context,
                //         UpdatePassword(),
                //       );
                //     },
                //     child: Text(
                //       'ChangePassword?',
                //     )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
