import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:job_platform/src/job_platform/data/models/models.dart';
import '../../../../cubits/cv_cubit/cv_cubit.dart';
import '../../../../data/datasource/configuration/data_configuration.dart';
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

// class Education {
//   String courseOrDegreeName;
//   String schoolOrUniversity;
//   DateTime startDate;
//   DateTime? endDate;
//   bool currentlyWorkHere;
//   String gradeOrScore;
//
//   Education(
//       {required this.courseOrDegreeName,
//       required this.schoolOrUniversity,
//       required this.startDate,
//       this.endDate,
//       this.currentlyWorkHere = false,
//       required this.gradeOrScore});
// }

//List<Education> educations = [];
Educations? educations;

class EducationScreen extends StatelessWidget {
  const EducationScreen({Key? key}) : super(key: key);
  init(BuildContext context) {
    educations = bloc.BlocProvider.of<CvCubit>(context).cv!.educations;
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => (DataConfiguration
                        .configurationCv[KeysConfigurationCv.countAllow.name]
                    [ComponentCv.educations.name] >=
                educations?.listEducation.length)
            ? Get.to(
                () => FillEducationScreen(
                      education: Education(
                          courseOrDegreeName: '',
                          schoolOrUniversity: '',
                          startDate: '',
                          endDate: '',
                          gradeOrScore: ''),
                    ),
                transition: Transition.upToDown)
            : Constants.showErrorDialog(
                context: context,
                message: tr(LocaleKeys.sorry_count_items_limited) +
                    ' ' +
                    '${DataConfiguration.configurationCv[KeysConfigurationCv.countAllow.name][ComponentCv.educations.name]}'),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(tr(LocaleKeys.education)),
      ),
      body: bloc.BlocBuilder<CvCubit, CvState>(
        builder: (context, state) {
          if (state == CvState.loading()) return LoadingDataBaseView();
          if (state.runtimeType == CvState.failure(null).runtimeType)
            return ErrorView();
          if (bloc.BlocProvider.of<CvCubit>(context).cv == null)
            return ErrorView();
          else if (bloc.BlocProvider.of<CvCubit>(context).cv?.educations ==
                  null ||
              bloc.BlocProvider.of<CvCubit>(context)
                      .cv
                      ?.educations!
                      .listEducation
                      .length ==
                  0)
            //TODO @hariri add widget empty data
            return EmptyDataView();
          else {
            init(context);
            return buildLisProjects(context);
          }
        },
      ),
    );
  }

  Widget buildLisProjects(BuildContext context) => ListView.builder(
        itemCount: educations!.listEducation.length,
        itemBuilder: (_, index) {
          return DismissibleItem(
            confirmDismiss: (confirmDismiss) async {
              deleteDialog(context,
                  btnOk: () async =>
                      await bloc.BlocProvider.of<CvCubit>(context)
                          .deleteEducation(context,
                              education: educations!.listEducation[index],
                              index: index));
            },
            child: GestureDetector(
              onTap: () {
                Get.to(() => FillEducationScreen(
                    education: educations!.listEducation[index], index: index));
              },
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
                      title: Text(
                          educations!.listEducation[index].courseOrDegreeName),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: AppPadding.p10),
                        child: Text(educations!
                            .listEducation[index].schoolOrUniversity),
                      ),
                    )),
                    Column(
                      children: [
                        Text(
                          '${educations!.listEducation[index].startDate}',
                          style: getRegularStyle(),
                        ),
                        const SizedBox(
                          height: AppSize.s4,
                        ),
                        Text(
                          educations!.listEducation[index].endDate ?? '',
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
  FillEducationScreen({super.key, required this.education, this.index = 0});

  final int index;
  Education education;
  final courseOrDegreeController = TextEditingController();
  final schoolOrUniversityController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  var gradeOrScoreController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool currentlyStudyHere = false;

  @override
  Widget build(BuildContext context) {
    courseOrDegreeController.text = education.courseOrDegreeName;
    schoolOrUniversityController.text = education.schoolOrUniversity;
    startDateController.text = education.startDate.toString();
    endDateController.text =
        education.endDate ?? tr(LocaleKeys.currently_work_here);
    gradeOrScoreController =
        TextEditingController(text: education.gradeOrScore);
    currentlyStudyHere = education.endDate == null && education.id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleKeys.education)),
        actions: [
          Visibility(
            visible: education.id != null,
            child: IconButton(
                onPressed: () async {
                  deleteDialog(context, btnOk: () async {
                    await bloc.BlocProvider.of<CvCubit>(context)
                        .deleteEducation(context,
                            education: education, index: index);
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
                  CustomTextFiled(
                    controller: courseOrDegreeController,
                    hintText: tr(LocaleKeys.course_or_degree_name),
                  ),
                  const SizedBox(
                    height: AppSize.s10,
                  ),
                  CustomTextFiled(
                    controller: schoolOrUniversityController,
                    hintText: tr(LocaleKeys.school_or_university),
                  ),
                  const SizedBox(
                    height: AppSize.s10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextFiled(
                          readOnly: true,
                          onTap: () => Constants.selectData(
                              context: context,
                              controller: startDateController),
                          controller: startDateController,
                          hintText: tr(LocaleKeys.start_date),
                        ),
                      ),
                      const SizedBox(
                        width: AppSize.s10,
                      ),
                      Expanded(
                        child: CustomTextFiled(
                          readOnly: true,
                          onTap: currentlyStudyHere
                              ? null
                              : () => Constants.selectData(
                                  context: context,
                                  controller: endDateController),
                          controller: endDateController,
                          hintText: tr(LocaleKeys.end_date),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSize.s10,
                  ),
                  StatefulBuilder(builder: (context, setState1) {
                    return CheckboxListTile(
                        title: Text(
                          tr(LocaleKeys.currently_study_here),
                          style: getRegularStyle(),
                        ),
                        value: currentlyStudyHere,
                        onChanged: (value) => setState1(() {
                              currentlyStudyHere = value!;
                              if (currentlyStudyHere)
                                endDateController.text =
                                    tr(LocaleKeys.currently_study_here);
                              else
                                endDateController.clear();
                            }));
                  }),
                  const SizedBox(
                    height: AppSize.s10,
                  ),
                  CustomTextFiled(
                    validator: (value) => null,
                    controller: gradeOrScoreController,
                    hintText: tr(LocaleKeys.grade_or_score),
                  )
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
                    education = Education(
                        id: education.id,
                        courseOrDegreeName: courseOrDegreeController.text,
                        schoolOrUniversity: schoolOrUniversityController.text,
                        startDate: startDateController.text,
                        endDate:
                            currentlyStudyHere ? null : endDateController.text);
                    (education.id == null)
                        ? await bloc.BlocProvider.of<CvCubit>(context)
                            .addEducation(context, education: education)
                        : await bloc.BlocProvider.of<CvCubit>(context)
                            .updateEducation(context,
                                education: education, index: index);

                    // educations.add(Education(
                    //     courseOrDegreeName: courseOrDegreeController.text,
                    //     schoolOrUniversity: schoolOrUniversityController.text,
                    //     endDate: endDateController.text ==
                    //             tr(LocaleKeys.currently_work_here)
                    //         ? null
                    //         : DateTime.parse(endDateController.text),
                    //     startDate: DateTime.parse(startDateController.text),
                    //     currentlyWorkHere: currentlyStudyHere,
                    //     gradeOrScore: gradeOrScoreController.text));
                    // Get.back();
                  }
                },
                onTap2: () {
                  List<String> helperList = cvEducation.split('.');
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
