// import 'package:animate_do/animate_do.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:job_platform/src/core/utils/app_colors.dart';
// import 'package:job_platform/src/core/utils/values_manager.dart';
// import 'package:job_platform/translations/locale_keys.g.dart';
// import 'package:pdf/pdf.dart';
// import 'package:printing/printing.dart';
// import 'package:pdf/widgets.dart' as wd;
// import '../../../../cubits/cv_cubit/cv_cubit.dart';
// import '../../generate_resume/pdf/common/configuration_pdf.dart';
// import '../../generate_resume/pdf/generate_pdf.dart';
//
// class EditCvColorsScreen extends StatefulWidget {
//   const EditCvColorsScreen({Key? key}) : super(key: key);
//
//   @override
//   State<EditCvColorsScreen> createState() => _EditCvColorsScreenState();
// }
//
// class _EditCvColorsScreenState extends State<EditCvColorsScreen> {
//   int _selectedIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(tr(LocaleKeys.edit_colors)),
//       ),
//       body: Column(
//         children: [
//           StatefulBuilder(builder: (context, setStateConf) {
//             return Row(
//               children: [
//                 PopupMenuButton(
//                     icon: Icon(Icons.settings),
//                     itemBuilder: (_) {
//                       return [
//                         PopupMenuItem(
//                           onTap: () {
//                             setStateConf(() {
//                               _selectedIndex = 0;
//                             });
//                           },
//                           child: Text(tr(LocaleKeys.colors)),
//                         ),
//                         PopupMenuItem(
//                           onTap: () {
//                             setStateConf(() {
//                               _selectedIndex = 1;
//                             });
//                           },
//                           child: Text(tr(LocaleKeys.photo)),
//                         ),
//                       ];
//                     }),
//                 _selectedIndex == 0
//                     ? SlideInLeft(
//                         child: Padding(
//                           padding: EdgeInsets.all(AppPadding.p20.sp),
//                           child:
//                               Wrap(alignment: WrapAlignment.center, children: [
//                             for (int i = 0;
//                                 i < currentConfCvPdf.colors.length;
//                                 i++) ...[
//                               GestureDetector(
//                                 onTap: () async {
//                                   final color = await showDialog(
//                                     context: context,
//                                     builder: (ctx) => ColorPickerDialog(
//                                         selectedColor: Color(currentConfCvPdf
//                                             .colors[i]
//                                             .toInt())),
//                                   );
//                                   if (color != null) {
//                                     await currentConfCvPdf.setColor(
//                                         i, PdfColor.fromInt(color.value));
//                                     setState(() {});
//                                   }
//                                 },
//                                 child: Padding(
//                                   padding: EdgeInsets.all(AppPadding.p4.sp),
//                                   child: SlideInLeft(
//                                     child: Container(
//                                       padding: EdgeInsets.all(18.sp),
//                                       decoration: BoxDecoration(
//                                         boxShadow: [
//                                           BoxShadow(
//                                               color: AppColors.shadowColor,
//                                               blurRadius: 6.sp)
//                                         ],
//                                         shape: BoxShape.circle,
//                                         color: Color(
//                                             currentConfCvPdf.colors[i].toInt()),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ]
//                           ]),
//                         ),
//                       )
//                     : Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: SlideInLeft(
//                             child: DropdownButtonFormField(
//                                 decoration: InputDecoration(
//                                     contentPadding: EdgeInsets.symmetric(
//                                         vertical: 0, horizontal: 8),
//                                     border: OutlineInputBorder(),
//                                     hintText: 'Selecte one'),
//                                 items: wd.BoxFit.values
//                                     .map(
//                                       (e) => DropdownMenuItem(
//                                         child: Text(
//                                           '${e.name}',
//                                         ),
//                                         value: e,
//                                       ),
//                                     )
//                                     .toList(),
//                                 onChanged: (value) {
//                                   if (value != null) {
//                                     setState(() {
//                                       currentConfCvPdf.boxFitImage = value;
//                                     });
//                                   }
//                                 }),
//                           ),
//                         ),
//                       )
//               ],
//             );
//           }),
//           Expanded(
//             flex: 3,
//             child: IgnorePointer(
//               ignoring: true,
//               child: PdfPreview(
//                 scrollViewDecoration: BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: [BoxShadow(color: Colors.white)]),
//                 padding: EdgeInsets.zero,
//                 previewPageMargin: EdgeInsets.zero,
//                 useActions: false,
//                 dynamicLayout: false,
//                 canDebug: false,
//                 canChangeOrientation: false,
//                 canChangePageFormat: false,
//                 allowSharing: false,
//                 allowPrinting: false,
//                 build: (format) =>
//                     generatePdf(cv: BlocProvider.of<CvCubit>(context).cv!),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: ElevatedButton(
//                 onPressed: () {}, child: Text(tr(LocaleKeys.save))),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class ColorPickerDialog extends StatefulWidget {
//   Color selectedColor;
//
//   ColorPickerDialog({this.selectedColor = Colors.red});
//
//   @override
//   _ColorPickerDialogState createState() => _ColorPickerDialogState();
// }
//
// class _ColorPickerDialogState extends State<ColorPickerDialog> {
//   // initialize with a default color
//   CircleColorPickerController controllerColor = CircleColorPickerController();
//
//   @override
//   Widget build(BuildContext context) {
//     controllerColor =
//         CircleColorPickerController(initialColor: (widget.selectedColor));
//
//     return AlertDialog(
//       content: CircleColorPicker(
//         controller: controllerColor,
//         onChanged: (color) {
//           setState(() {
//             widget.selectedColor = color;
//           });
//         },
//         size: const Size(240, 240),
//         strokeWidth: 10,
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop(widget
//                 .selectedColor); // return selected color to the previous screen
//           },
//           child: Text(tr(LocaleKeys.ok)),
//         ),
//       ],
//     );
//   }
// }
