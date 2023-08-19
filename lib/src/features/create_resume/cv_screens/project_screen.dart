import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:job_platform/src/job_platform/data/datasource/configuration/data_configuration.dart';
import '../../../../cubits/cv_cubit/cv_cubit.dart';
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

// class Projects {
//   String projectName;
//   String title;
//   DateTime startDate;
//   DateTime? endDate;
//   String? link;
//   bool currentlyWorkHere;
//   String description;
//
//   Projects(
//       {required this.projectName,
//         required this.title,
//         required this.startDate,
//         this.link,
//         this.endDate,
//         this.currentlyWorkHere = false,
//         required this.description});
// }

Projects? projects;

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({Key? key}) : super(key: key);
  init(BuildContext context) {
    projects = bloc.BlocProvider.of<CvCubit>(context).cv!.projects;
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => (DataConfiguration
                        .configurationCv[KeysConfigurationCv.countAllow.name]
                    [ComponentCv.projects.name] >=
                projects!.listProject.length)
            ? Get.to(
                () => FillProjectsScreen(
                      project: Project(
                          subDomain: null,
                          endDate: '',
                          startDate: '',
                          projectName: '',
                          projectTitle: '',
                          link: ''),
                    ),
                transition: Transition.upToDown)
            : Constants.showErrorDialog(
                context: context,
                message: tr(LocaleKeys.sorry_count_items_limited) +
                    ' ' +
                    '${DataConfiguration.configurationCv[KeysConfigurationCv.countAllow.name][ComponentCv.projects.name]}'),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(tr(LocaleKeys.projects)),
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
                  ?.projects
                  ?.listProject
                  .length ==
              0)
            //TODO @hariri add widget empty data
            return EmptyDataView();
          else {
            init(context);
            return buildListProject(context);
          }
        },
      ),
    );
  }

  buildListProject(BuildContext context) => ListView.builder(
        itemCount: projects!.listProject.length,
        itemBuilder: (_, index) {
          return DismissibleItem(
            confirmDismiss: (confirmDismiss) async {
              deleteDialog(context,
                  btnOk: () async =>
                      await bloc.BlocProvider.of<CvCubit>(context)
                          .deleteProject(context,
                              project: projects!.listProject[index],
                              index: index));
            },
            child: GestureDetector(
              onTap: () {
                Get.to(() => FillProjectsScreen(
                      project: projects!.listProject[index],
                      index: index,
                    ));
              },
              child: Container(
                margin: const EdgeInsets.all(AppMargin.m4),
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
                      title: Text(projects!.listProject[index].projectName),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: AppPadding.p10),
                        child: Text(projects!.listProject[index].projectTitle),
                      ),
                    )),
                    Column(
                      children: [
                        Text(
                          '${projects!.listProject[index].startDate}',
                          style: getRegularStyle(),
                        ),
                        const SizedBox(
                          height: AppSize.s4,
                        ),
                        Text(
                          projects!.listProject[index].endDate ?? '',
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

class FillProjectsScreen extends StatelessWidget {
  FillProjectsScreen({
    Key? key,
    required Project project,
    this.index = 0,
  })  : _project = project,
        super(key: key);
  final int index;
  Project _project;
  final projectNameController = TextEditingController();
  final projectTitleController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  var descriptionController = TextEditingController();
  final linkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool currentlyWorkHere = false;

  @override
  Widget build(BuildContext context) {
    projectNameController.text = _project.projectName;
    projectTitleController.text = _project.projectTitle;
    startDateController.text = _project.startDate;
    endDateController.text =
        _project.endDate ?? tr(LocaleKeys.currently_work_here);
    descriptionController = TextEditingController(text: _project.description);
    linkController.text = _project.link ?? '';
    currentlyWorkHere = _project.endDate == null && _project.id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleKeys.projects)),
        actions: [
          Visibility(
            visible: _project.id != null,
            child: IconButton(
                onPressed: () async {
                  deleteDialog(context, btnOk: () async {
                    await bloc.BlocProvider.of<CvCubit>(context).deleteProject(
                        context,
                        project: _project,
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
                    controller: projectNameController,
                    hintText: tr(LocaleKeys.project_name),
                  ),
                  const SizedBox(
                    height: AppSize.s10,
                  ),
                  CustomTextFiled(
                    controller: projectTitleController,
                    hintText: tr(LocaleKeys.project_title),
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
                          onTap: currentlyWorkHere
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
                          tr(LocaleKeys.currently_work_here),
                          style: getRegularStyle(),
                        ),
                        value: currentlyWorkHere,
                        onChanged: (value) => setState1(() {
                              currentlyWorkHere = value!;
                              if (currentlyWorkHere)
                                endDateController.text =
                                    tr(LocaleKeys.currently_work_here);
                              else
                                endDateController.clear();
                            }));
                  }),
                  const SizedBox(
                    height: AppSize.s10,
                  ),
                  CustomTextFiled(
                    validator: (value) => null,
                    controller: linkController,
                    hintText: tr(LocaleKeys.project_link),
                  ),
                  const SizedBox(
                    height: AppSize.s10,
                  ),
                  CustomTextFiled(
                    validator: (value) => null,
                    controller: descriptionController,
                    hintText: tr(LocaleKeys.description),
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
                    if (linkController.text.isURL ||
                        linkController.text.trim().isEmpty) {
                      _project = Project(
                          id: _project.id,
                          startDate: startDateController.text,
                          endDate:
                              currentlyWorkHere ? null : endDateController.text,
                          projectName: projectNameController.text,
                          projectTitle: projectTitleController.text,
                          description: descriptionController.text,
                          link: linkController.text);

                      (_project.id == null)
                          ? await bloc.BlocProvider.of<CvCubit>(context)
                              .addProject(context, project: _project)
                          : await bloc.BlocProvider.of<CvCubit>(context)
                              .updateProject(context,
                                  project: _project, index: index);
                    } else {
                      Get.snackbar('title', 'link not correct');
                    }
                  }
                },
                onTap2: () {
                  Constants.showModalBottomSheet(
                      context,
                      Container(
                        color: Theme.of(context).cardColor,
                      ));
                });
          })
        ],
      ),
    );
  }
}
