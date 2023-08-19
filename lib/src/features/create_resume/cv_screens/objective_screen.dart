import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:job_platform/src/core/utils/app_colors.dart';
import 'package:job_platform/src/core/utils/constants.dart';
import 'package:job_platform/src/core/utils/styles_manager.dart';
import 'package:job_platform/src/job_platform/presentation/widgets/custom_text_filed.dart';
import 'package:job_platform/src/job_platform/presentation/widgets/down_section.dart';
import 'package:job_platform/translations/locale_keys.g.dart';

import '../../../../../core/utils/values_manager.dart';

class ObjectiveScreen extends StatelessWidget {
  ObjectiveScreen({Key? key}) : super(key: key);
  final objectiveController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleKeys.objective)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppPadding.p16),
              children: [
                CustomTextFiled(
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  controller: objectiveController,
                  hintText: tr(LocaleKeys.objective),
                  minline: 1,
                  maxline: 10,
                ),
                const SizedBox(
                  height: AppSize.s20,
                ),
                GestureDetector(
                  onTap: () {
                    Constants.showModalBottomSheet(
                        context,
                        SafeArea(
                          child: Container(
                            color: Theme.of(context).cardColor,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(AppPadding.p16),
                              itemCount: _savedObjective.length,
                              itemBuilder: (_, index) {
                                return GestureDetector(
                                  onTap: () {
                                    objectiveController.text =
                                        _savedObjective[index];
                                    Get.back();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(AppPadding.p12),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: AppMargin.m8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(4.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.hint.withOpacity(.1),
                                          blurRadius: 2,
                                          spreadRadius: 4
                                        )
                                      ]
                                    ),
                                    child: Text(
                                      _savedObjective[index],
                                      style: getRegularStyle(
                                        fontSize: 12.sp
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ));
                  },
                  child: DottedBorder(
                    color: Theme.of(context).primaryColor,
                    dashPattern: [5],
                    borderType: BorderType.RRect,
                    radius: Radius.circular(4.r),
                    padding: EdgeInsets.all(6),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: Padding(
                          padding: const EdgeInsets.all(AppPadding.p12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline),
                              const SizedBox(
                                width: AppSize.s10,
                              ),
                              Text(tr(LocaleKeys.selected) +
                                  '  ' +
                                  tr(LocaleKeys.objective)),
                            ],
                          ),
                        )),
                  ),
                )
              ],
            ),
          ),
          DownSection(
              text1: tr(LocaleKeys.save),
              text2: tr(LocaleKeys.help),
              onTap1: () {
                Get.back();
              },
              onTap2: () {})
        ],
      ),
    );
  }

  List<String> _savedObjective = [
    'Diligent [Job Title] with [Number] years of success in product roadmap development, market research and data analysis. Highly skilled in identifying opportunities to maximize revenue.',
    'Hardworking College Student seeking employment. Bringing forth a motivated attitude and a variety of powerful skills. Adept in various social media platforms and office technology programs. Committed to utilizing my skills further.',
    'Experienced [Job Title] with over [Number] years of experience in [Industry]. Very good at managing multiple priorities with a positive attitude. Willingness to take on added responsibilities to meet team goals.'
  ];
}
