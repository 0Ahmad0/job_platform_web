import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../cubits/cv_cubit/cv_cubit.dart';
import '../../../../data/datasource/configuration/data_configuration.dart';
import '../../../../data/models/models.dart';
import '../../../widgets/dialog/deleteDialog.dart';
import '../../../widgets/dismissible.dart';
import '../../../widgets/widgets_Informative/empty_data_view.dart';
import '../../../widgets/widgets_Informative/error_view.dart';
import '../../../widgets/widgets_Informative/loading_data_view.dart';
import '/src/core/utils/app_colors.dart';
import '/src/core/utils/constants.dart';
import '/src/core/utils/styles_manager.dart';
import '/src/job_platform/presentation/widgets/custom_text_filed.dart';
import '/translations/locale_keys.g.dart';

import '../../../../../core/utils/values_manager.dart';
import '../../../widgets/down_section.dart';

// class References {
//   String referenceName;
//   String jobTitle;
//   String companyName;
//   String email;
//   String phoneNumber;
//
//   References(
//       {required this.referenceName,
//       required this.jobTitle,
//       required this.companyName,
//       required this.email,
//       required this.phoneNumber});
// }

//List<References> references = [];
References? references;

class ReferenceScreen extends StatelessWidget {
  const ReferenceScreen({Key? key}) : super(key: key);
  init(BuildContext context) {
    references = bloc.BlocProvider.of<CvCubit>(context).cv!.references;
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => (DataConfiguration
                        .configurationCv[KeysConfigurationCv.countAllow.name]
                    [ComponentCv.references.name] >=
                references!.listReference.length)
            ? Get.to(
                () => FillEducationScreen(
                    reference:
                        Reference(email: '', mobile: '', companyName: '')),
                transition: Transition.upToDown)
            : Constants.showErrorDialog(
                context: context,
                message: tr(LocaleKeys.sorry_count_items_limited) +
                    ' ' +
                    '${DataConfiguration.configurationCv[KeysConfigurationCv.countAllow.name][ComponentCv.references.name]}'),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(tr(LocaleKeys.reference)),
      ),
      body: bloc.BlocBuilder<CvCubit, CvState>(
        builder: (context, state) {
          if (state == CvState.loading()) return LoadingDataBaseView();
          if (state.runtimeType == CvState.failure(null).runtimeType)
            return ErrorView();
          if (bloc.BlocProvider.of<CvCubit>(context).cv == null)
            return ErrorView();
          else if (bloc.BlocProvider.of<CvCubit>(context)
                  .cv
                  ?.references
                  ?.listReference
                  .length ==
              0)
            //TODO @hariri add widget empty data
            return EmptyDataView();
          else {
            init(context);
            return buildListReferences(context);
          }
        },
      ),
    );
  }

  Widget buildListReferences(BuildContext context) => ListView.builder(
        itemCount: references!.listReference.length,
        itemBuilder: (_, index) {
          return DismissibleItem(
            confirmDismiss: (confirmDismiss) async {
              deleteDialog(context,
                  btnOk: () async =>
                      await bloc.BlocProvider.of<CvCubit>(context)
                          .deleteReference(context,
                              reference: references!.listReference[index],
                              index: index!));
            },
            child: GestureDetector(
              onTap: () {
                Get.to(
                  () => FillEducationScreen(
                      reference: references!.listReference[index],
                      index: index),
                );
              },
              //TODO @hariri design screen
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.hint.withOpacity(.9),
                          blurRadius: 2,
                          spreadRadius: .5)
                    ]),
                child: Row(
                  children: [
                    Expanded(
                        child: ListTile(
                      title: Text(references!.listReference[index].companyName),
                      // title: Text(references!.listReference[index].referenceName),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: AppPadding.p10),
                        //child: Text(references!.listReference[index].jobTitle),
                      ),
                    )),
                    Column(
                      children: [
                        Text(
                          '${references!.listReference[index].email}',
                          style: getRegularStyle(),
                        ),
                        const SizedBox(
                          height: AppSize.s4,
                        ),
                        Text(
                          '${references!.listReference[index].mobile}',
                          style: getRegularStyle(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: AppSize.s10,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18.sp,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
}

class FillEducationScreen extends StatelessWidget {
  FillEducationScreen({super.key, required this.reference, this.index = 0});

  Reference reference;
  final int index;
  final referenceNameController = TextEditingController();
  final jobTitleController = TextEditingController();
  final companyNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool currentlyStudyHere = false;

  @override
  Widget build(BuildContext context) {
    //referenceNameController.text = reference.referenceName;
    //jobTitleController.text = reference.jobTitle;
    companyNameController.text = reference.companyName;
    emailController.text = reference.email;
    phoneNumberController.text = reference.mobile;
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleKeys.reference)),
        actions: [
          Visibility(
            visible: reference.id != null,
            child: IconButton(
                onPressed: () async {
                  deleteDialog(context, btnOk: () async {
                    await bloc.BlocProvider.of<CvCubit>(context)
                        .deleteReference(context,
                            reference: reference, index: index);
                    Get.back();
                  });
                },
                icon: Icon(Icons.delete_forever)),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppPadding.p16),
                children: [
                  // CustomTextFiled(
                  //   controller: referenceNameController,
                  //   hintText: tr(LocaleKeys.reference),
                  // ),
                  // const SizedBox(
                  //   height: AppSize.s10,
                  // ),
                  // CustomTextFiled(
                  //   validator: (value)=>null,
                  //   controller: jobTitleController,
                  //   hintText: tr(LocaleKeys.job_title),
                  // ),
                  // const SizedBox(
                  //   height: AppSize.s10,
                  // ),
                  CustomTextFiled(
                    validator: (value) => null,
                    controller: companyNameController,
                    hintText: tr(LocaleKeys.companyName),
                  ),
                  const SizedBox(
                    height: AppSize.s10,
                  ),
                  CustomTextFiled(
                    validator: (value) => null,
                    controller: emailController,
                    hintText: tr(LocaleKeys.email),
                  ),
                  const SizedBox(
                    height: AppSize.s10,
                  ),
                  CustomTextFiled(
                    validator: (value) => null,
                    controller: phoneNumberController,
                    hintText: tr(LocaleKeys.phone_number),
                  ),
                  const SizedBox(
                    height: AppSize.s10,
                  ),
                ],
              ),
            ),
          ),
          StatefulBuilder(builder: (context, setState2) {
            return DownSection(
                text1: tr(LocaleKeys.save),
                text2: tr(LocaleKeys.help),
                onTap1: () async {
                  if (_formKey.currentState!.validate()) {
                    reference = Reference(
                        id: reference.id,
                        email: emailController.text,
                        mobile: phoneNumberController.text,
                        companyName: companyNameController.text);

                    (reference.id == null)
                        ? await bloc.BlocProvider.of<CvCubit>(context)
                            .addReference(context, reference: reference)
                        : await bloc.BlocProvider.of<CvCubit>(context)
                            .updateReference(context,
                                reference: reference, index: index);

                    // references.add(References(
                    //     referenceName: referenceNameController.text,
                    //     jobTitle: jobTitleController.text,
                    //     companyName: companyNameController.text,
                    //     email: emailController.text,
                    //     phoneNumber: phoneNumberController.text,
                    // ));
                    //Get.back();
                  }
                },
                onTap2: () {
                  List<String> helperList = cvReference.split('.');
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
                                              padding: const EdgeInsets.only(
                                                  top: 6.0),
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
                });
          })
        ],
      ),
    );
  }
}
