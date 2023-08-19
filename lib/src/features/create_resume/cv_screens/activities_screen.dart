import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../widgets/textfiled_app.dart';
import '/translations/locale_keys.g.dart';

class Activity {
  String activityDetail;

  Activity({required this.activityDetail});
}

List<Activity> activities = [Activity(activityDetail: 'activity')];

class ActivitiesScreen extends StatelessWidget {
  ActivitiesScreen({super.key, this.activity});

  final Activity? activity;
  final activityDetailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    activityDetailController.text = activity?.activityDetail ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  CustomTextFiled(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: activityDetailController,
                    hintText: 'Description',
                    minline: 1,
                    maxline: 10,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          // StatefulBuilder(builder: (context, setState2) {
          //   return DownSection(
          //       text1: tr(LocaleKeys.save),
          //       text2: tr(LocaleKeys.help),
          //       onTap1: () {
          //         if (_formKey.currentState!.validate()) {
          //           activities.add(Activity(
          //             activityDetail: activityDetailController.text,
          //           ),
          //           );
          //           Get.back();
          //         }
          //       },
          //       onTap2: () {
          //         Constants.showModalBottomSheet(
          //             context,
          //             Container(
          //               color: Theme
          //                   .of(context)
          //                   .cardColor,
          //             ));
          //       });
          // })
        ],
      ),
    );
  }
}
