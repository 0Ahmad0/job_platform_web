import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:job_platform/src/job_platform/cubits/domain_cubit/domain_cubit.dart';
import 'package:job_platform/src/job_platform/presentation/screens/create_resume/cv_screens/work_experience_screen.dart';
import 'package:job_platform/src/job_platform/presentation/widgets/drop_down_search.dart';

import '../../../../cubits/cv_cubit/cv_cubit.dart';
import '../../../../data/datasource/configuration/data_configuration.dart';
import '../../../../data/models/models.dart';
import '../../../widgets/cv/level_bar.dart';
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

// class Skills {
//   String skillName;
//   int level;
//   Skills({required this.skillName, this.level = 1});
// }
//
// class SkillLevel {
//   String skillLevelName;
//   int level;
//
//   SkillLevel({required this.skillLevelName, this.level = 1});
// }

Map<int, dynamic> skillLevels = DataConfiguration.skillLevels;

//List<Skills> skills = [Skills(skillName: 'skillName')];
Skills? skills;

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({Key? key}) : super(key: key);

  init(BuildContext context) {
    skills = bloc.BlocProvider.of<CvCubit>(context).cv!.skills;
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => (DataConfiguration
                        .configurationCv[KeysConfigurationCv.countAllow.name]
                    [ComponentCv.skills.name] >=
                skills!.listSkill.length)
            ? Get.to(() => FillSkillsScreen(skill: Skill(level: 1)),
                transition: Transition.upToDown)
            : Constants.showErrorDialog(
                context: context,
                message: tr(LocaleKeys.sorry_count_items_limited) +
                    ' ' +
                    '${DataConfiguration.configurationCv[KeysConfigurationCv.countAllow.name][ComponentCv.skills.name]}'),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(tr(LocaleKeys.skill)),
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
                  ?.skills
                  ?.listSkill
                  .length ==
              0)
            //TODO @hariri add widget empty data
            return EmptyDataView();
          else {
            init(context);
            return buildListSkill(context);
          }
        },
      ),
    );
  }

  Widget buildListSkill(BuildContext context) => ListView.builder(
        itemCount: skills?.listSkill.length,
        itemBuilder: (_, index) {
          return DismissibleItem(
            confirmDismiss: (confirmDismiss) async {
              deleteDialog(
                context,
                btnOk: () async => await bloc.BlocProvider.of<CvCubit>(context)
                    .deleteSkill(context, skill: skills!.listSkill[index]),
              );
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
                child: ListTile(
                    onTap: () {
                      Get.to(
                        () => FillSkillsScreen(
                          skill: skills!.listSkill[index],
                          index: index,
                          //   Skills(
                          //       skillName: skills[index].skillName,
                          //       level: skills[index].level+1),
                        ),
                      );
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(skills!.listSkill[index].subDomain!.name),
                        LevelBar(
                          level: skills!.listSkill[index].level,
                          countDegree: skillLevels.length,
                        )
                      ],
                    ))),
          );
        },
      );
}

class FillSkillsScreen extends StatelessWidget {
  FillSkillsScreen({
    super.key,
    required this.skill,
    this.index = 0,
  });
  final int index;
  Skill skill;
  final skillNameController = TextEditingController();
  final levelController = TextEditingController();
  SubDomain? selectedItem;
  final _formKey = GlobalKey<FormState>();

  bool currentlyStudyHere = false;
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];
  int? selectedValue;

  @override
  Widget build(BuildContext context) {
    levelController.text = skillLevels[skill.level];
    selectedValue = skill.level;
    selectedItem = skill.subDomain;
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleKeys.skill)),
        actions: [
          Visibility(
            visible: skill.id != null,
            child: IconButton(
                onPressed: () async {
                  deleteDialog(context, btnOk: () async {
                    await bloc.BlocProvider.of<CvCubit>(context)
                        .deleteSkill(context, skill: skill);
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
                  //TODO @hariri here drop searcj
                  DropDownSearchSubDomain(
                    selectedItem: selectedItem,
                    onChange: (value) {
                      selectedItem = value;
                    },
                  ),
                  const SizedBox(
                    height: AppSize.s10,
                  ),
                  StatefulBuilder(builder: (context, setState1) {
                    return Container(
                      padding: EdgeInsets.all(AppPadding.p4),
                      decoration: BoxDecoration(
                          color: AppColors.hint.withOpacity(.2),
                          borderRadius: BorderRadius.circular(4.r)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          iconStyleData: IconStyleData(
                              icon: Icon(Icons.keyboard_arrow_down)),
                          isExpanded: true,
                          dropdownStyleData: DropdownStyleData(
                            padding: EdgeInsets.zero,
                          ),
                          hint: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                skillLevels[skill.level],
                              ),
                              LevelBar(
                                level: skill.level,
                                countDegree: skillLevels.length,
                              )
                            ],
                          ),
                          items: skillLevels.entries
                              .map((item) => DropdownMenuItem(
                                  value: item.key,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(item.value),
                                      LevelBar(
                                        level: item.key,
                                        countDegree: skillLevels.length,
                                      )
                                    ],
                                  )))
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            selectedValue = value;
                            setState1(() {});
                          },
                        ),
                      ),
                    );
                  }),
                  /*
                  DropdownButtonFormField(
                    icon: Icon(Icons.keyboard_arrow_down_rounded),
                      isExpanded: true,
                      decoration: InputDecoration(

                        hintText: tr(LocaleKeys.level)
                      ),
                      items: [
                        for(int skil = 0 ;skil < skillLevels.length;skil++ )
                          DropdownMenuItem(
                      child: Container(
                        color: Theme.of(context).primaryColor.withOpacity(.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(skillLevels[skil].skillLevelName),
                            Row(
                              children: [
                                for(int i = 0 ; i< skillLevels.length ; i++)
                                  Container(
                                    width: 10.w,
                                    height: 10.w,
                                    padding: const EdgeInsets.all(AppPadding.p4),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: AppMargin.m4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2.r),
                                        color: skillLevels[i].level <= skillLevels[skil].level
                                            ?Theme.of(context).primaryColor
                                            :AppColors.lightGray
                                    ),
                                  )

                              ],
                            )
                          ],
                        ),
                      ),
                      value: skillLevels[skil].level,
                    ),
                  ], onChanged: (val) {})
                  */
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
                    skill = Skill(
                        subDomain: selectedItem,
                        id: skill.id,
                        level: selectedValue!);
                    (skill.id == null)
                        ? await bloc.BlocProvider.of<CvCubit>(context)
                            .addSkill(context, skill: skill)
                        : await bloc.BlocProvider.of<CvCubit>(context)
                            .updateSkill(context, skill: skill, index: index);
                    // skills.add(Skills(
                    //   skillName: skillNameController.text,
                    //   level: skillLevels.indexOf(
                    //       SkillLevel(skillLevelName: levelController.text)),
                    // ));
                    //Get.back();
                  }
                },
                onTap2: () {
                  List<String> helperList = cvSkills.split('.');
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
