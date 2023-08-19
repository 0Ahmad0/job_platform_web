import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '/src/core/utils/app_colors.dart';
import '/src/core/utils/constants.dart';
import '/src/core/utils/styles_manager.dart';
import '/src/job_platform/presentation/widgets/custom_text_filed.dart';
import '/translations/locale_keys.g.dart';

import '../../../../../core/utils/values_manager.dart';
import '../../../widgets/down_section.dart';


class Interest {
  String interestDetail;

  Interest({required this.interestDetail});
}


List<Interest> interests = [Interest(interestDetail: 'Interest')];


class InterestsScreen extends StatelessWidget {
  InterestsScreen({super.key,  this.interest});

  final Interest? interest;
  final interestDetailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    interestDetailController.text = interest?.interestDetail??'';
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleKeys.interest)),
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
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: interestDetailController,
                    hintText: tr(LocaleKeys.description),
                    minline: 1,
                    maxline: 10,
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
                onTap1: () {
                  if (_formKey.currentState!.validate()) {
                    interests.add(Interest(
                      interestDetail: interestDetailController.text,
                      ),
                    );
                    Get.back();
                  }
                },
                onTap2: () {
                  Constants.showModalBottomSheet(
                      context,
                      Container(
                        color: Theme
                            .of(context)
                            .cardColor,
                      ));
                });
          })
        ],
      ),
    );
  }
}
