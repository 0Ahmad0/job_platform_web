import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Gender {
  male,
  female,
}

class Constants {
  static const int spalshDelay = 5;
  static const int spalshDelayAppName = 200;

  // static loading(context) {
  //   Get.dialog(
  //       Center(
  //         child: Container(
  //             alignment: Alignment.center,
  //             width: ScreenUtil.defaultSize.width * 0.2,
  //             height: ScreenUtil.defaultSize.width * 0.2,
  //             decoration: BoxDecoration(
  //                 color: AppColors.white,
  //                 borderRadius: BorderRadius.circular(8.sp //AppSize.s8
  //                 )),
  //             child: LoadingAnimationWidget.inkDrop(
  //                 color: AppColors.primary,
  //                 size: ScreenUtil.defaultSize.width * 0.1)),
  //       ),
  //       barrierDismissible: false);
  // }

  // static void showErrorDialog(
  //     {required BuildContext context, required String message}) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => CupertinoAlertDialog(
  //       title: Text(message),
  //       actions: [
  //         TextButton(
  //             onPressed: () {
  //               Get.back();
  //             },
  //             child: Text(tr(LocaleKeys.ok))),
  //       ],
  //     ),
  //   );
  // }

  static selectData(
      {required BuildContext context,
      required TextEditingController controller}) async {
    DateTime _selectedDate = DateTime.now();
    var newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      //todo
      // builder: (context, child) {
      //   return Theme(
      //     data: appTheme().copyWith(
      //         textTheme: TextTheme(
      //           overline: getRegularStyle(
      //               fontSize: 16.sp
      //           ),
      //          caption: getRegularStyle(
      //              fontSize: 14.sp
      //          ),
      //           button: getRegularStyle(
      //               fontSize: 16.sp
      //           ),
      //
      //
      //
      //         )
      //     ),
      //     child: child!,
      //   );
      // }
    );

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      controller
        ..text = DateFormat('yyyy-MM-dd').format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: controller.text.length, affinity: TextAffinity.upstream));
    }
  }

  // static showTOAST(BuildContext context,
  //     {String textToast = "This Is Toast",
  //       position = StyledToastPosition.top}) {
  //   showToast(
  //     textToast,
  //     context: context,
  //     position: StyledToastPosition.top,
  //     animation: StyledToastAnimation.fadeScale,
  //     textStyle: getRegularStyle(color: AppColors.white),
  //   );
  // }

  static showModalBottomSheetII(BuildContext context, Widget child) {
    return showModalBottomSheet(context: context, builder: (_) => child);
  }
}
