import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/app_colors.dart';
import 'cv_screens/education_screen.dart';
import 'cv_screens/language_screen.dart';
import 'cv_screens/personal_information_screen.dart';
import 'cv_screens/project_screen.dart';
import 'cv_screens/references_screen.dart';
import 'cv_screens/skills_screen.dart';
import 'cv_screens/social_media_screen.dart';
import 'cv_screens/work_experience_screen.dart';

class CreateResumeScreen extends StatefulWidget {
  CreateResumeScreen({Key? key}) : super(key: key);

  @override
  State<CreateResumeScreen> createState() => _CreateResumeScreenState();
}

class _CreateResumeScreenState extends State<CreateResumeScreen> {
  @override
  void initState() {
    // bloc.BlocProvider.of<CvCubit>(context).getFullCvInformation(context);
    super.initState();
  }

  // InfoFile? cvInfoFile;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final gabH = size.width * 0.015;
    final gabW = size.width * 0.015;

    // bloc.BlocProvider.of<CvCubit>(context).getFullCvInformation(context);
    // bloc.BlocProvider.of<CvCubit>(context).calculatorDegreeCv();

    return Scaffold(
        appBar: AppBar(
          title: Text('Create Resume'),
          // actions: [
          //   bloc.BlocBuilder<CvCubit, CvState>(
          //     builder: (context, state) => IconButton(
          //         onPressed: () {
          //           bloc.BlocProvider.of<CvCubit>(context)
          //               .showDetailsProgressFn();
          //         },
          //         icon: Icon(
          //             bloc.BlocProvider.of<CvCubit>(context).showDetailsProgress
          //                 ? Icons.visibility_off
          //                 : Icons.visibility)
          //         // SvgPicture.asset(
          //         //   bloc.BlocProvider.of<CvCubit>(context).showDetailsProgress
          //         //       ? SVGAssets.hider
          //         //       : SVGAssets.viewer,
          //         //   width: 24.sp,
          //         //   height: 24.sp,
          //         // ),
          //         ),
          //   ),
          //   IconButton(
          //       onPressed: () {
          //         if (true) {
          //           // languageDialog(context);
          //         } else
          //           Constants.showModalBottomSheet(
          //               context,
          //               Container(
          //                 padding: EdgeInsets.symmetric(vertical: 10.sp),
          //                 width: double.infinity,
          //                 height: ScreenUtil.defaultSize.height / 2.5,
          //                 decoration: BoxDecoration(
          //                     color: AppColors.white,
          //                     borderRadius: BorderRadius.vertical(
          //                         top: Radius.circular(24.sp))),
          //                 child: Column(
          //                   children: [
          //                     Container(
          //                       width: 100.sp,
          //                       height: 6.sp,
          //                       decoration: BoxDecoration(
          //                           borderRadius: BorderRadius.circular(100.r),
          //                           color: AppColors.shadowColor),
          //                     ),
          //                     SizedBox(
          //                       height: 10.sp,
          //                     ),
          //                     Text(
          //                       tr(LocaleKeys.pick_cv),
          //                       style: getBoldStyle(),
          //                     ),
          //                     StatefulBuilder(builder: (context, setStateCv) {
          //                       if (!ConfigurationPdf.getConfigurationPdf()
          //                           .doneInit)
          //                         Timer.periodic(Duration(seconds: 5), (timer) {
          //                           setStateCv(() {});
          //                         });
          //                       return ConfigurationPdf.getConfigurationPdf()
          //                               .doneInit
          //                           ? Expanded(
          //                               child: ListView.builder(
          //                               scrollDirection: Axis.horizontal,
          //                               itemCount:
          //                                   ConfigurationPdf.getConfigurationPdf()
          //                                       .mapConfigurationCvPdf
          //                                       .length,
          //                               itemBuilder: (_, index) =>
          //                                   GestureDetector(
          //                                 onTap: () {
          //                                   currentConfCvPdf = ConfigurationPdf
          //                                           .getConfigurationPdf()
          //                                       .mapConfigurationCvPdf
          //                                       .values
          //                                       .toList()[index];
          //                                   Get.to(() => EditCvColorsScreen());
          //                                 },
          //                                 child: Container(
          //                                   child: ClipRRect(
          //                                     borderRadius:
          //                                         BorderRadius.circular(8.sp),
          //                                     child: Image.asset(ConfigurationPdf
          //                                                 .getConfigurationPdf()
          //                                             .mapConfigurationCvPdf
          //                                             .values
          //                                             .toList()[index]
          //                                             .imagePath ??
          //                                         ImageAssets.iconCv),
          //                                   ),
          //                                   margin: EdgeInsets.symmetric(
          //                                       horizontal: 4.sp,
          //                                       vertical: 10.sp),
          //                                   decoration: BoxDecoration(
          //                                     color: AppColors.primary,
          //                                     borderRadius:
          //                                         BorderRadius.circular(8.sp),
          //                                   ),
          //                                 ),
          //                               ),
          //                             ))
          //                           : LoadingDataView();
          //                     })
          //                   ],
          //                 ),
          //               ));
          //       },
          //       icon: Icon(Icons.color_lens))
          // ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(gabH),
                    children: [
                      _buildCvProgress(context),
                      SizedBox(
                        height: gabH,
                      ),
                      Text('Section'),
                      SizedBox(
                        height: gabH,
                      ),

                      buildListTileCvSection(
                        context,
                        text: 'Personal Info',
                        icon: Icons.person_outline,
                        progress: .5,
                        screenName: PersonalInformationScreen(),
                        // progress: progressComponentCv[
                        //     ComponentCv.personalInformation.name],
                      ),
                      SizedBox(
                        height: gabH,
                      ),
                      buildListTileCvSection(
                        context,
                        text: 'Social Media',
                        icon: Icons.contact_mail_outlined,
                        screenName: SocialMediaScreen(),
                        // progress: progressComponentCv[ComponentCv.links.name],
                      ),
                      // const SizedBox(
                      //   height: gabH,
                      // ),
                      // buildListTileCvSection(context,
                      //     text: tr(LocaleKeys.objective),
                      //     icon: Icons.data_object,
                      //     screenName: ObjectiveScreen()),
                      SizedBox(
                        height: gabH,
                      ),
                      buildListTileCvSection(
                        context,
                        text: 'Work Experience',
                        icon: Icons.work_outline,
                        screenName: WorkExperienceScreen(),
                        // progress: progressComponentCv[
                        //     ComponentCv.workExperiences.name],
                      ),
                      SizedBox(
                        height: gabH,
                      ),
                      buildListTileCvSection(
                        context,
                        text: 'Projects',
                        icon: Icons.propane_outlined,
                        // svgPath: SVGAssets.projects,
                        screenName: ProjectsScreen(),
                        // progress:
                        //     progressComponentCv[ComponentCv.projects.name],
                      ),
                      SizedBox(
                        height: gabH,
                      ),
                      buildListTileCvSection(
                        context,
                        text: 'Education',
                        icon: Icons.cast_for_education,
                        // svgPath: SVGAssets.education,
                        screenName: EducationScreen(),
                        // progress:
                        //     progressComponentCv[ComponentCv.educations.name],
                      ),
                      SizedBox(
                        height: gabH,
                      ),
                      Text('More Section'),
                      SizedBox(
                        height: gabH,
                      ),
                      buildListTileCvSection(
                        context,
                        text: 'Reference',
                        icon: Icons.group_outlined,
                        screenName: ReferenceScreen(),
                        // progress:
                        //     progressComponentCv[ComponentCv.references.name],
                      ),
                      SizedBox(
                        height: gabH,
                      ),
                      buildListTileCvSection(
                        context,
                        text: 'Skill',
                        icon: Icons.multitrack_audio,
                        screenName: SkillsScreen(),
                        // progress: progressComponentCv[ComponentCv.skills.name],
                      ),
                      // const SizedBox(
                      //   height: gabH,
                      // ),
                      // buildListTileCvSection(context,
                      //     text: tr(LocaleKeys.interest),
                      //     icon: Icons.interests_sharp,
                      //     screenName: InterestsScreen(
                      //       interest: Interest(interestDetail: ''),
                      //     )),
                      // const SizedBox(
                      //   height: gabH,
                      // ),
                      // buildListTileCvSection(context,
                      //     text: tr(LocaleKeys.activities),
                      //     icon: Icons.local_activity_outlined,
                      //     screenName: ActivitiesScreen()),
                      SizedBox(
                        height: gabH,
                      ),
                      buildListTileCvSection(
                        context,
                        text: 'Languages',
                        icon: Icons.translate,
                        screenName: LanguagesScreen(),
                        // progress:
                        //     progressComponentCv[ComponentCv.languages.name],
                      ),
                      SizedBox(
                        height: gabH,
                      ),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: gabW),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  // color: Color(0xffFFFAFA),
                                  color: AppColors.hint.withOpacity(.1),
                                  blurRadius: 8.0,
                                  spreadRadius: 2)
                            ]),
                        child: ListTile(
                          onTap: () {
                            _buildDialogCvFile(context);
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.file_download,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                width: gabW,
                              ),
                              Text(
                                'Uploade Cv',
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: gabH,
                      ),
                    ],
                  ),
                ),
                // DownSection(
                //     text1: 'Save',
                //     text2: 'Help',
                //     onTap1: () {
                //       if (true) {
                //         languageDialog(context);
                //       }
                //       // Get.to(() => ResumePreviewScreen(),
                //       //     transition: Transition.upToDown);
                //     },
                //     onTap2: () {
                //       List<String> helperList = cvReviewHelper.split('.');
                //       Constants.showModalBottomSheet(
                //           context,
                //           SafeArea(
                //             child: Container(
                //               color: Theme.of(context).cardColor,
                //               child: Column(
                //                 children: [
                //                   Expanded(
                //                     child: ListView.separated(
                //                       separatorBuilder: (_, __) => Divider(),
                //                       padding: EdgeInsets.all(20),
                //                       itemCount: helperList.length - 1,
                //                       itemBuilder: (_, index) => Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.start,
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.start,
                //                         children: [
                //                           Padding(
                //                             padding:
                //                                 const EdgeInsets.only(top: 6.0),
                //                             child: Icon(
                //                               Icons.circle,
                //                               size: 6.sp,
                //                             ),
                //                           ),
                //                           SizedBox(
                //                             width: 4.0,
                //                           ),
                //                           Flexible(
                //                               child: Text(helperList[index]))
                //                         ],
                //                       ),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ));
                //     })
              ],
            ),
            Visibility(
              // visible: bloc.BlocProvider.of<CvCubit>(context)
              //         .cv
              //         ?.personalInformation
              //         ?.cv ==
              //     null,
              child: Positioned(
                top: size.height / 7,
                right: 0,
                child: FloatingActionButton(
                  heroTag: UniqueKey(),
                  onPressed: () async {
                    _buildDialogCvFile(context);
                  },
                  child: Icon(Icons.upload_file_rounded),
                ),
              ),
            )
          ],
        ));
  }

  Widget buildListTileCvSection(BuildContext context,
      {required String text,
      IconData? icon,
      String? svgPath,
      Widget? screenName,
      double? progress}) {
    final size = MediaQuery.of(context).size;
    final gabH = size.width * 0.015;
    final gabW = size.width * 0.015;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                // color: Color(0xffFFFAFA),
                color: AppColors.hint.withOpacity(.1),
                blurRadius: 8.0,
                spreadRadius: 2)
          ]),
      child: ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (ctx) => screenName ?? Scaffold()));
          },
          leading: icon != null
              ? Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                )
              : SvgPicture.asset(
                  svgPath!,
                  color: Theme.of(context).primaryColor,
                  width: 24,
                  height: 24,
                ),
          title: Text(
            text,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // CircularProgressBar(
              //   show:
              //       bloc.BlocProvider.of<CvCubit>(context).showDetailsProgress,
              //   progress: progress,
              // ),
              SizedBox(
                width: gabH,
              ),
              Container(
                alignment: Alignment.center,
                height: 30,
                width: 30,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.1),
                    borderRadius: BorderRadius.circular(4)),
                child: SvgPicture.asset(
                  'SVGAssets.edit',
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          )),
    );
  }

  Widget _buildCvProgress(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final gabH = size.width * 0.015;
    final gabW = size.width * 0.015;
    // int progress = bloc.BlocProvider.of<CvCubit>(context).progress.floor();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: gabW),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                // color: Color(0xffFFFAFA),
                color: AppColors.hint.withOpacity(.1),
                blurRadius: 8.0,
                spreadRadius: 2)
          ]),
      child: ListTile(
        onTap: () {
          print('Helllo');
        },
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(.25),
          radius: 26,
          child: Text(
            '{progress}',
            style:
                TextStyle(fontSize: 26, color: Theme.of(context).primaryColor),
          ),
        ),
        title: Text('Resume Score'),
        subtitle: Padding(
          padding: EdgeInsets.only(top: gabH),
          child: Text(
            'View Detailed Instructions',
            style:
                TextStyle(fontSize: 12, color: Theme.of(context).primaryColor),
          ),
        ),
        // trailing: Container(
        //   padding: const EdgeInsets.all(AppPadding.p8),
        //   alignment: Alignment.center,
        //   width: ScreenUtil.defaultSize.width / 5,
        //   height: 30.h,
        //   decoration: BoxDecoration(
        //     color: Theme.of(context).primaryColor,
        //     borderRadius: BorderRadius.circular(4.r),
        //   ),
        //   child: Text(
        //     tr(LocaleKeys.view),
        //     style: getRegularStyle(color: AppColors.white
        //         //ToDo
        //         ),
        //   ),
        // ),
      ),
    );
  }

  _buildDialogCvFile(BuildContext context) {
    // cvInfoFile = null;
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              title: Text('Uploade CV'),
              content: StatefulBuilder(
                  builder: (_, setState1) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // if (cvInfoFile != null)
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                  // cvInfoFile?.name ??
                                  // bloc.BlocProvider.of<CvCubit>(context)
                                  //     .cv
                                  //     ?.personalInformation
                                  //     ?.cv ??
                                  ''),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              // visible: cvInfoFile != null,
                              child: Text(
                                'size: 100Kb  ',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                // if (bloc.BlocProvider.of<CvCubit>(context)
                                //         .cv
                                //         ?.personalInformation
                                //         ?.cv !=
                                //     null)
                                Expanded(
                                    child: TextButton.icon(
                                        style: TextButton.styleFrom(
                                            backgroundColor:
                                                AppColors.error.shade100),
                                        // onPressed: () {
                                        //   bloc.BlocProvider.of<CvCubit>(context)
                                        //       .deleteCv(context);
                                        // },
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.delete,
                                          color: AppColors.error,
                                        ),
                                        label: Text('Delete'))),
                                // if (bloc.BlocProvider.of<CvCubit>(context)
                                //         .cv
                                //         ?.personalInformation
                                //         ?.cv !=
                                //     null)
                                //    SizedBox(
                                //     width: 4,
                                //   ),
                                // if (bloc.BlocProvider.of<CvCubit>(context)
                                //         .cv
                                //         ?.personalInformation
                                //         ?.cv !=
                                //     null)
                                Expanded(
                                    child: TextButton.icon(
                                        style: TextButton.styleFrom(
                                            backgroundColor:
                                                AppColors.success.shade100),
                                        // onPressed: () {
                                        //   openPdf(
                                        //       path: storageUrl +
                                        //           bloc.BlocProvider.of<CvCubit>(
                                        //                   context)
                                        //               .cv!
                                        //               .personalInformation!
                                        //               .cv!);
                                        // },
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.download,
                                          color: AppColors.success,
                                        ),
                                        label: Text('Download'))),
                                // if (bloc.BlocProvider.of<CvCubit>(context)
                                //         .cv
                                //         ?.personalInformation
                                //         ?.cv !=
                                //     null)
                                //    SizedBox(
                                //     width: 4,
                                //   ),
                                Expanded(
                                    child: TextButton.icon(
                                        style: TextButton.styleFrom(
                                            backgroundColor: AppColors.primary
                                                .withOpacity(.1)),
                                        // onPressed: () async {
                                        //   var file =
                                        //       await FilePicker.platform.pickFiles(
                                        //     type: FileType.custom,
                                        //     allowedExtensions: ['pdf'],
                                        //   );
                                        //   if (file != null) {
                                        //     cvInfoFile = InfoFile(
                                        //       path: file.files.first.path,
                                        //       name: file.files.first.name,
                                        //       size: formatFileSize(
                                        //           file.files.first.size),
                                        //     );
                                        //     setState1(() {});
                                        //   }
                                        // },
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.file_present_sharp,
                                        ),
                                        label: Text('Pick'))),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Visibility(
                              // visible: cvInfoFile != null,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextButton.icon(
                                        style: TextButton.styleFrom(
                                            minimumSize:
                                                Size(double.infinity, 50),
                                            backgroundColor: AppColors.primary),
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) {
                                                return WillPopScope(
                                                  onWillPop: () {
                                                    return Future.value(true);
                                                    // return Future.value(false);
                                                  },
                                                  child: AlertDialog(
                                                    content: ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      leading:
                                                          CircularProgressIndicator(),
                                                      title: Text(
                                                          'tr( Parsing Cv)'),
                                                      trailing: Text('0 %'),
                                                    ),
                                                  ),
                                                );
                                              });
                                          Future.delayed(Duration(seconds: 5),
                                              () {
                                            Navigator.pop(context);
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (_) =>
                                            //             CreateParssingResumeScreen()));
                                          });
                                        },
                                        icon: Icon(
                                          Icons.change_circle_outlined,
                                          color: AppColors.white,
                                        ),
                                        label: Text(
                                          'tr(.parse)',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.white),
                                        )),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: TextButton.icon(
                                        style: TextButton.styleFrom(
                                            minimumSize:
                                                Size(double.infinity, 50),
                                            backgroundColor: AppColors.primary),
                                        onPressed: () async {
                                          // if (cvInfoFile != null)
                                          //   await bloc.BlocProvider.of<CvCubit>(
                                          //           context)
                                          //       .updateCv(context,
                                          //           cvInfoFile: cvInfoFile!);

                                          // else {}
                                        },
                                        icon: Icon(
                                          Icons.upload,
                                          color: AppColors.white,
                                        ),
                                        label: Text(
                                          'Save',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.white),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )));
        });
  }
}
