import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// class WorkExperience {
//   String companyName;
//   String jobTitle;
//   DateTime startDate;
//   DateTime? endDate;
//   bool currentlyWorkHere;
//   String description;
//
//   WorkExperience(
//       {required this.companyName,
//       required this.jobTitle,
//       required this.startDate,
//       this.endDate,
//       this.currentlyWorkHere = false,
//       required this.description});
// }

List<WorkExperience> workExperience = [];

class WorkExperienceScreen extends StatelessWidget {
  WorkExperienceScreen({Key? key}) : super(key: key);
  WorkExperiences? workExperiences;
  init(BuildContext context) {
    workExperiences =
        bloc.BlocProvider.of<CvCubit>(context).cv!.workExperiences;
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => (DataConfiguration
                        .configurationCv[KeysConfigurationCv.countAllow.name]
                    [ComponentCv.workExperiences.name] >=
                workExperiences!.listWorkExperience.length)
            ? Get.to(
                () => FillWorkExperienceScreen(
                      workExperience: WorkExperience(
                          companyName: '',
                          startDate: '',
                          description: '',
                          endDate: ''),
                    ),
                transition: Transition.upToDown)
            : Constants.showErrorDialog(
                context: context,
                message: tr(LocaleKeys.sorry_count_items_limited) +
                    ' ' +
                    '${DataConfiguration.configurationCv[KeysConfigurationCv.countAllow.name][ComponentCv.workExperiences.name]}'),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(tr(LocaleKeys.work_experience)),
      ),
      body: bloc.BlocBuilder<CvCubit, CvState>(
        builder: (context, state) {
          if (state == CvState.loading()) return LoadingDataBaseView();
          if (state.runtimeType == CvState.failure(null).runtimeType)
            return ErrorView();
          if (bloc.BlocProvider.of<CvCubit>(context).cv == null)
            //TODO @hariri add widget wait
            return ErrorView();
          else if (bloc.BlocProvider.of<CvCubit>(context)
                  .cv
                  ?.workExperiences
                  ?.listWorkExperience
                  .length ==
              0)
            //TODO @hariri add widget empty data
            return EmptyDataView();
          else {
            init(context);
            return buildListWorkExperiences(context);
          }
        },
      ),
    );
  }

  buildListWorkExperiences(BuildContext context) => ListView.builder(
        itemCount: workExperiences?.listWorkExperience.length,
        itemBuilder: (_, index) {
          return DismissibleItem(
            confirmDismiss: (confirmDismiss) async {
              deleteDialog(context, btnOk: () async {
                await bloc.BlocProvider.of<CvCubit>(context)
                    .deleteWorkExperience(context,
                        workExperience:
                            workExperiences!.listWorkExperience[index],
                        index: index);
              });
            },
            child: GestureDetector(
              onTap: () {
                Get.to(() => FillWorkExperienceScreen(
                      index: index,
                      workExperience: WorkExperience(
                          id: workExperiences!.listWorkExperience[index].id,
                          companyName: workExperiences!
                              .listWorkExperience[index].companyName,
                          //jobTitle: workExperience[index].jobTitle,
                          startDate: workExperiences!
                              .listWorkExperience[index].startDate,
                          endDate: workExperiences!
                              .listWorkExperience[index].endDate,
                          description: workExperiences!
                              .listWorkExperience[index].description,
                          subDomain: workExperiences!
                              .listWorkExperience[index].subDomain),
                    ));
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
                      title: Text(workExperiences!
                          .listWorkExperience[index].companyName),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: AppPadding.p10),
                        child: Text(
                            '${workExperiences!.listWorkExperience[index].subDomain!.name}'),
                      ),
                    )),
                    Column(
                      children: [
                        Text(
                          '${workExperiences!.listWorkExperience[index].startDate}',
                          style: getRegularStyle(),
                        ),
                        const SizedBox(
                          height: AppSize.s4,
                        ),
                        Text(
                          workExperiences!.listWorkExperience[index].endDate ??
                              '',
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

class FillWorkExperienceScreen extends StatelessWidget {
  FillWorkExperienceScreen({
    Key? key,
    required WorkExperience workExperience,
    this.index = 0,
  })  : _workExperience = workExperience,
        super(key: key);
  WorkExperience _workExperience;
  final int index;
  final companyNameController = TextEditingController();
  final jobTitleController = TextEditingController();
  final startDateController = TextEditingController();
  var endDateController = TextEditingController();
  var descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  SubDomain? selectedItem;
  bool currentlyWorkHere = false;

  @override
  Widget build(BuildContext context) {
    companyNameController.text = _workExperience.companyName;
    //jobTitleController.text = _workExperience.jobTitle;
    selectedItem = _workExperience.subDomain;
    startDateController.text = _workExperience.startDate.toString();
    endDateController = TextEditingController(
        text: _workExperience.endDate ?? tr(LocaleKeys.currently_work_here));
    descriptionController =
        TextEditingController(text: _workExperience.description);
    currentlyWorkHere =
        _workExperience.endDate == null && _workExperience.id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleKeys.work_experience)),
        actions: [
          Visibility(
            visible: _workExperience.id != null,
            child: IconButton(
                onPressed: () async {
                  deleteDialog(context, btnOk: () async {
                    await bloc.BlocProvider.of<CvCubit>(context)
                        .deleteWorkExperience(context,
                            workExperience: _workExperience, index: index);
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
                    controller: companyNameController,
                    hintText: tr(LocaleKeys.companyName),
                  ),
                  const SizedBox(
                    height: AppSize.s10,
                  ),
                  DropDownSearchSubDomain(
                    selectedItem: selectedItem,
                    onChange: (value) {
                      selectedItem = value;
                    },
                  ),
                  // CustomTextFiled(
                  //   controller: jobTitleController,
                  //   hintText: tr(LocaleKeys.job_title),
                  // ),
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
                    _workExperience = WorkExperience(
                        id: _workExperience.id,
                        startDate: startDateController.text,
                        companyName: companyNameController.text,
                        endDate:
                            currentlyWorkHere ? null : endDateController.text,
                        description: descriptionController.text,
                        subDomain: selectedItem);
                    (_workExperience.id == null)
                        ? await bloc.BlocProvider.of<CvCubit>(context)
                            .addWorkExperience(context,
                                workExperience: _workExperience)
                        : await bloc.BlocProvider.of<CvCubit>(context)
                            .updateWorkExperience(context,
                                workExperience: _workExperience, index: index);

                    // workExperience.add(WorkExperience(
                    //     companyName: companyNameController.text,
                    //     //jobTitle: jobTitleController.text,
                    //     endDate: endDateController.text == tr(LocaleKeys.currently_work_here)
                    //         ?null
                    //         // :DateTime.parse(endDateController.text),
                    //          :endDateController.text,
                    //     startDate: startDateController.text,
                    //     currentlyWorkHere: currentlyWorkHere,
                    //     description: descriptionController.text,
                    //     subDomain: _workExperience.subDomain
                    // ));
                    //\\ Get.back();
                  }
                },
                onTap2: () {
                  List<String> helperList = cvWorkExperience.split('.');
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        child: Icon(
                                          Icons.circle,
                                          size: 6.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4.0,
                                      ),
                                      Flexible(child: Text(helperList[index]))
                                    ],
                                  ),
                                ),
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
