import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_platform/src/core/utils/app_colors.dart';
import 'package:job_platform/src/core/utils/app_url.dart';
import 'package:job_platform/src/core/utils/assets_manager.dart';
import 'package:job_platform/src/core/utils/constants.dart';
import 'package:job_platform/src/core/utils/styles_manager.dart';
import 'package:job_platform/src/core/utils/values_manager.dart';
import 'package:job_platform/src/job_platform/cubits/cv_cubit/cv_cubit.dart';
import 'package:job_platform/src/job_platform/cubits/user_cubit/user_cubit.dart';
import 'package:job_platform/src/job_platform/data/datasource/configuration/data_configuration.dart';
import 'package:job_platform/src/job_platform/data/models/models.dart';
import 'package:job_platform/src/job_platform/presentation/screens/profile/widgets/profile_image.dart';
import 'package:job_platform/src/job_platform/presentation/widgets/custom_text_filed.dart';
import 'package:job_platform/src/job_platform/presentation/widgets/down_section.dart';
import '../../../widgets/widgets_Informative/empty_data_view.dart';
import '../../../widgets/widgets_Informative/error_view.dart';
import '../../../widgets/widgets_Informative/loading_data_view.dart';
import '/translations/locale_keys.g.dart';

class PersonalInformationScreen extends StatefulWidget {
  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final ImagePicker picker = ImagePicker();

  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var addressController = TextEditingController();
  var nationalityController = TextEditingController();
  var birthDayController = TextEditingController();
  var aboutMeController = TextEditingController();
  var professionController = TextEditingController();
  var materialStatusController;
  bool? materialStatus;
  final _formKey = GlobalKey<FormState>();
  XFile? _image;

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker.platform.pickImage(source: source);
      if (image == null) return;
      XFile? img = XFile(image.path);
      Get.back();
      img = await _cropImage(imageFile: img);
      BlocProvider.of<UserCubit>(context).image = _image;
      setState(() => _image = img);
    } on PlatformException catch (e) {
      print('Error ' + e.toString());
      Navigator.of(context).pop();
    }
  }

  Future<XFile?> _cropImage({required XFile imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper.platform
        .cropImage(sourcePath: imageFile.path, uiSettings: [
      AndroidUiSettings(
          toolbarTitle: tr(LocaleKeys.crop),
          toolbarColor: Theme.of(context).primaryColor,
          statusBarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Theme.of(context).primaryColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    ]);
    if (croppedImage == null) return null;
    return XFile(croppedImage.path);
  }

  _showPickerDialog(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Center(
                child: Container(
              padding: const EdgeInsets.all(AppPadding.p16),
              margin: EdgeInsets.all(AppMargin.m16),
              width: double.infinity,
              height: ScreenUtil.defaultSize.height / 3,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(LocaleKeys.select_photo),
                    style: getRegularStyle(fontSize: 16.sp),
                  ),
                  Spacer(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => _pickImage(ImageSource.gallery),
                    leading: Icon(
                      Icons.image,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      tr(LocaleKeys.select_from_gallery),
                      style: getRegularStyle(fontSize: 14.sp),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => _pickImage(ImageSource.camera),
                    leading: Icon(
                      Icons.camera_alt,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      tr(LocaleKeys.select_from_camera),
                      style: getRegularStyle(fontSize: 14.sp),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          tr(LocaleKeys.cancel),
                          style: getRegularStyle(fontSize: 16.sp),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
          );
        });
  }

  User? user;
  init() {
    user = BlocProvider.of<CvCubit>(context).cv!.personalInformation;
    fNameController.text = user!.firstName;
    lNameController.text = user!.lastName;
    phoneController.text = user!.phoneNumber!;
    emailController.text = user!.email!;
    addressController = TextEditingController(text: user!.address);
    nationalityController = TextEditingController(text: user!.nationality);
    birthDayController.text = user!.birthDate;
    aboutMeController = TextEditingController(text: user!.about_me);
    professionController = TextEditingController(text: user!.profession);

    materialStatus = user!.military_status;
    if (user!.military_status != null) {
      materialStatusController =
          '${(user!.military_status!) ? tr(LocaleKeys.ok) : tr(LocaleKeys.no)}';
    }
  }

  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).image = null;
    BlocProvider.of<UserCubit>(context).photoProfileUrl =
        BlocProvider.of<UserCubit>(context).user!.photoProfileUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    init();
    // if (_image != null) {
    //   print('${_image!.path}');
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleKeys.personal_information)),
      ),
      body: BlocBuilder<CvCubit, CvState>(
        //buildWhen: (prev,next)=>prev!=next,
        builder: (context, state) {
          if (state == CvState.loading()) return LoadingDataBaseView();
          if (state.runtimeType == CvState.failure(null).runtimeType)
            return ErrorView();
          if (BlocProvider.of<CvCubit>(context).cv == null)
            return ErrorView();
          else if (BlocProvider.of<CvCubit>(context).cv?.personalInformation ==
              null)
            //TODO @hariri add widget empty data
            return EmptyDataView();
          else {
            init();
            return buildPersonalInformation(context);
          }
        },
      ),
    );
  }

  Widget buildPersonalInformation(BuildContext context) => Column(
        children: [
          Expanded(
              child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppPadding.p16),
              children: [
                ListTile(
                  onTap: () => _showPickerDialog(context),
                  contentPadding: EdgeInsets.zero,
                  leading: Text(tr(LocaleKeys.upload_photo)),
                  trailing: Transform.scale(
                    scale: 1.5,
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      margin: const EdgeInsets.all(AppMargin.m8),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.hint.withOpacity(.3),
                              blurRadius: 4)
                        ],
                        color: Theme.of(context).primaryColor.withOpacity(.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: Image.file(
                                File(_image!.path),
                                fit: BoxFit.fill,
                              ),
                            )
                          : BlocProvider.of<UserCubit>(context)
                                      .photoProfileUrl ==
                                  null
                              ? Icon(
                                  Icons.person,
                                  color: Theme.of(context).primaryColor,
                                )
                              : extendedImage(context,
                                  url: user!.photoProfileUrl!,
                                  failUrl: getImageProfile(user!.gender)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSize.s20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextFiled(
                        validator: (value) => FormValidator.validateName(value),
                        controller: fNameController,
                        hintText: tr(LocaleKeys.f_name),
                      ),
                    ),
                    const SizedBox(
                      width: AppSize.s10,
                    ),
                    Expanded(
                      child: CustomTextFiled(
                        validator: (value) => FormValidator.validateName(value),
                        controller: lNameController,
                        hintText: tr(LocaleKeys.l_name),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSize.s10,
                ),
                CustomTextFiled(
                  validator: (value) => null,
                  controller: professionController,
                  hintText: tr(LocaleKeys.profession),
                ),
                const SizedBox(
                  height: AppSize.s10,
                ),
                CustomTextFiled(
                  readOnly: true,
                  //  validator: (value) => FormValidator.phoneValidator(value),
                  controller: phoneController,
                  hintText: tr(LocaleKeys.phone_number),
                ),
                const SizedBox(
                  height: AppSize.s10,
                ),
                CustomTextFiled(
                  validator: (value) => FormValidator.emailValidator(value),
                  controller: emailController,
                  hintText: tr(LocaleKeys.email),
                ),
                const SizedBox(
                  height: AppSize.s10,
                ),
                CustomTextFiled(
                  validator: (value) => null,
                  controller: addressController,
                  hintText: tr(LocaleKeys.address),
                ),
                const SizedBox(
                  height: AppSize.s10,
                ),
                CustomTextFiled(
                  validator: (value) => null,
                  controller: nationalityController,
                  hintText: tr(LocaleKeys.nationality),
                ),
                const SizedBox(
                  height: AppSize.s10,
                ),
                CustomTextFiled(
                  validator: (value) => null,
                  onTap: () => Constants.selectData(
                      context: context, controller: birthDayController),
                  readOnly: true,
                  controller: birthDayController,
                  hintText: tr(LocaleKeys.data_of_birth),
                ),
                const SizedBox(
                  height: AppSize.s10,
                ),
                CustomTextFiled(
                  validator: (value) => null,
                  controller: aboutMeController,
                  hintText: tr(LocaleKeys.about_me),
                ),
                const SizedBox(
                  height: AppSize.s10,
                ),
                DropdownButtonFormField<String>(
                    value: materialStatusController,
                    icon: Icon(Icons.keyboard_arrow_down_rounded),
                    decoration: InputDecoration(
                        hintText: tr(LocaleKeys.material_status)),
                    items: [tr(LocaleKeys.ok), tr(LocaleKeys.no)]
                        .map((e) => DropdownMenuItem<String>(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (value) {
                      materialStatus = tr(LocaleKeys.ok) == value;
                      materialStatusController = tr(LocaleKeys.ok);
                    })
                // CustomTextFiled(
                //   iconData: Icons.,
                //   validator: (value) => null,
                //   controller: materialStatusController,
                //   hintText: tr(LocaleKeys.material_status),
                // ),
              ],
            ),
          )),
          DownSection(
              text1: tr(LocaleKeys.save),
              text2: tr(LocaleKeys.help),
              onTap1: () {
                if (_formKey.currentState!.validate()) {
                  BlocProvider.of<CvCubit>(context).updateProfileInformation(
                      context,
                      email: emailController.text != user!.email
                          ? emailController.text
                          : null,
                      firstName: fNameController.text,
                      lastName: lNameController.text,
                      gender: user!.gender,
                      phoneNumber: phoneController.text != user!.phoneNumber
                          ? phoneController.text
                          : null,
                      birthDate: birthDayController.text,
                      image: _image == null
                          ? (BlocProvider.of<UserCubit>(context)
                                      .photoProfileUrl ==
                                  BlocProvider.of<UserCubit>(context)
                                      .user!
                                      .photoProfileUrl
                              ? null
                              : '')
                          : _image!.path,
                      address: addressController.text,
                      about_me: aboutMeController.text,
                      nationality: nationalityController.text,
                      military_status: materialStatus,
                      profession: professionController.text);
                }
              },
              onTap2: () {
                List<String> helperList = cvInformationProfile.split('\n');
                Constants.showModalBottomSheet(
                    context,
                    SafeArea(
                      child: Container(
                        color: Theme.of(context).cardColor,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                  separatorBuilder: (_, __) => Divider(),
                                  padding: EdgeInsets.all(20),
                                  itemCount: helperList.length - 1,
                                  itemBuilder: (_, index) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 6.0),
                                            child: Icon(
                                              Icons.circle,
                                              size: 6.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4.0,
                                          ),
                                          Flexible(
                                              child: Text(helperList[index]))
                                        ],
                                      )),
                            ),
                          ],
                        ),
                      ),
                    ));
              })
        ],
      );
}
