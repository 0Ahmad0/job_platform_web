import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:job_platform/src/job_platform/data/datasource/configuration/data_configuration.dart';
import 'package:job_platform/src/job_platform/data/models/models.dart';
import 'package:job_platform/src/job_platform/presentation/widgets/cv/level_bar.dart';
import '../../../../cubits/cv_cubit/cv_cubit.dart';
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

// class Languages {
//   String languageName;
//   int level;
//
//   Languages({required this.languageName, this.level = 1});
// }

class LanguageLevel {
  String languageLevelName;
  int level;

  LanguageLevel({required this.languageLevelName, this.level = 1});
}

Map<int, dynamic> languageLevels = DataConfiguration.languageLevels;
Languages? languages;

class LanguagesScreen extends StatelessWidget {
  const LanguagesScreen({Key? key}) : super(key: key);
  init(BuildContext context) {
    languages = bloc.BlocProvider.of<CvCubit>(context).cv!.languages;
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => (DataConfiguration
                        .configurationCv[KeysConfigurationCv.countAllow.name]
                    [ComponentCv.languages.name] >=
                languages!.listLanguage.length)
            ? Get.to(
                () => FillLanguagesScreen(
                    language: Language(languageName: '', level: 1)),
                transition: Transition.upToDown)
            : Constants.showErrorDialog(
                context: context,
                message: tr(LocaleKeys.sorry_count_items_limited) +
                    ' ' +
                    '${DataConfiguration.configurationCv[KeysConfigurationCv.countAllow.name][ComponentCv.languages.name]}'),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(tr(LocaleKeys.languages)),
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
                  ?.languages
                  ?.listLanguage
                  .length ==
              0)
            //TODO @hariri add widget empty data
            return EmptyDataView();
          else {
            init(context);
            return buildListLanguage(context);
          }
        },
      ),
    );
  }

  Widget buildListLanguage(BuildContext context) => ListView.builder(
        itemCount: languages!.listLanguage.length,
        itemBuilder: (_, index) {
          return DismissibleItem(
            confirmDismiss: (confirmDismiss) async {
              deleteDialog(context,
                  btnOk: () async =>
                      await bloc.BlocProvider.of<CvCubit>(context)
                          .deleteLanguage(context,
                              language: languages!.listLanguage[index],
                              index: index));
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
                        () => FillLanguagesScreen(
                          language: languages!.listLanguage[index],
                          index: index,
                        ),
                      );
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(languages!.listLanguage[index].languageName),
                        LevelBar(
                          level: languages!.listLanguage[index].level,
                          countDegree: languageLevels.length,
                        )
                      ],
                    ))),
          );
        },
      );
}

class FillLanguagesScreen extends StatelessWidget {
  FillLanguagesScreen({super.key, required this.language, this.index = 0});

  final int index;
  Language language;
  final languageNameController = TextEditingController();
  final levelController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int? selectedValue;

  @override
  Widget build(BuildContext context) {
    languageNameController.text = language.languageName;
    selectedValue = language.level;
    levelController.text = languageLevels[language.level];
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleKeys.languages)),
        actions: [
          Visibility(
            visible: language.id != null,
            child: IconButton(
                onPressed: () async {
                  deleteDialog(context, btnOk: () async {
                    await bloc.BlocProvider.of<CvCubit>(context).deleteLanguage(
                        context,
                        language: language,
                        index: index);
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
                    controller: languageNameController,
                    hintText: tr(LocaleKeys.skill),
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
                              // Text(languageLevels[0].languageLevelName,),
                              Text(
                                languageLevels[language.level],
                              ),
                              LevelBar(
                                level: language.level,
                                countDegree: languageLevels.length,
                              )
                            ],
                          ),
                          items: languageLevels.entries
                              .map((item) => DropdownMenuItem(
                                  value: item.key, //languageLevelName,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Text(item.languageLevelName),
                                      Text(item.value),
                                      LevelBar(
                                        level: item.key,
                                        countDegree: languageLevels.length,
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
                    language = Language(
                        id: language.id,
                        languageName: languageNameController.text,
                        level: selectedValue!);
                    (language.id == null)
                        ? await bloc.BlocProvider.of<CvCubit>(context)
                            .addLanguage(context, language: language)
                        : await bloc.BlocProvider.of<CvCubit>(context)
                            .updateLanguage(context,
                                language: language, index: index);
                    // languages.add(Languages(
                    //   languageName: languageNameController.text,
                    //   level: languageLevels.indexOf(
                    //       LanguageLevel(languageLevelName: levelController.text)),
                    // ));
                    // Get.back();
                  }
                },
                onTap2: () {
                  List<String> helperList = cvLanguage.split('\n');
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
