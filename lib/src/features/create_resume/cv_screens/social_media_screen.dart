import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_platform/src/core/utils/app_colors.dart';
import 'package:job_platform/src/core/utils/assets_manager.dart';
import 'package:job_platform/src/core/utils/constants.dart';
import 'package:job_platform/src/core/utils/styles_manager.dart';
import 'package:job_platform/src/core/utils/values_manager.dart';
import 'package:job_platform/src/job_platform/data/models/models.dart';
import 'package:job_platform/src/job_platform/presentation/widgets/custom_text_filed.dart';
import 'package:job_platform/src/job_platform/presentation/widgets/down_section.dart';
import '../../../../cubits/cv_cubit/cv_cubit.dart';
import '../../../widgets/widgets_Informative/empty_data_view.dart';
import '../../../widgets/widgets_Informative/error_view.dart';
import '../../../widgets/widgets_Informative/loading_data_view.dart';
import '/translations/locale_keys.g.dart';

class SocialMediaScreen extends StatelessWidget {
  SocialMediaScreen({Key? key}) : super(key: key);
  var linkedinController = TextEditingController();
  var githubController = TextEditingController();
  var gitlabController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Links? links;
  init(BuildContext context) {
    links = BlocProvider.of<CvCubit>(context).cv!.links;
    linkedinController =
        TextEditingController(text: links!.mapLinks[NameLink.linkedin.name]);
    githubController =
        TextEditingController(text: links!.mapLinks[NameLink.github.name]);
    gitlabController =
        TextEditingController(text: links!.mapLinks[NameLink.gitlab.name]);
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleKeys.social_media)),
      ),
      body: BlocBuilder<CvCubit, CvState>(
        builder: (context, state) {
          if (state == CvState.loading()) return LoadingDataBaseView();
          if (state.runtimeType == CvState.failure(null).runtimeType)
            return ErrorView();
          if (BlocProvider.of<CvCubit>(context).cv == null)
            //TODO @hariri add widget wait
            return ErrorView();
          else if (BlocProvider.of<CvCubit>(context)
                  .cv
                  ?.links
                  ?.mapLinks
                  .length ==
              0)
            //TODO @hariri add widget empty data
            return EmptyDataView();
          else {
            init(context);
            return _buildSocialMedia(context);
          }
        },
      ),
    );
  }

  Widget _buildSocialMedia(BuildContext context) => Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppPadding.p16),
                children: [
                  //TODO @hariri exp
                  //you have allow to text: null
                  ///********************************
                  SocialMediaTextFormFiled(
                    controller: linkedinController,
                    icon: SVGAssets.linkedin,
                    validator: (value) =>
                        SocialMediaValidator.linkedinValidator(value),
                  ),

                  ///********************************
                  SocialMediaTextFormFiled(
                    controller: githubController,
                    icon: SVGAssets.github,
                    validator: (value) =>
                        SocialMediaValidator.githubValidator(value),
                  ),

                  ///********************************
                  SocialMediaTextFormFiled(
                    controller: gitlabController,
                    icon: SVGAssets.getlab,
                    validator: (value) =>
                        SocialMediaValidator.githubValidator(value),
                  ),

                  ///********************************
                  // SocialMediaTextFormFiled(
                  //   icon: SVGAssets.stackoverflow,
                  //   validator: (value) =>
                  //       SocialMediaValidator.stackoverflowValidator(value),
                  // ),
                  ///********************************
                  // SocialMediaTextFormFiled(
                  //   icon: SVGAssets.facebook,
                  //   validator: (value) =>
                  //       SocialMediaValidator.facebookValidator(value),
                  // ),
                  ///********************************
                  // SocialMediaTextFormFiled(
                  //   icon: SVGAssets.telegram,
                  //   validator: (value) =>
                  //       SocialMediaValidator.telegramValidator(value),
                  // ),
                  ///********************************
                  // SocialMediaTextFormFiled(
                  //   icon: SVGAssets.medium,
                  //   validator: (value) =>
                  //       SocialMediaValidator.mediumValidator(value),
                  // ),
                  ///********************************
                  // SocialMediaTextFormFiled(
                  //   icon: SVGAssets.reddit,
                  //   validator: (value) =>
                  //       SocialMediaValidator.redditValidator(value),
                  // ),
                  ///********************************
                  // SocialMediaTextFormFiled(
                  //   icon: SVGAssets.twitter,
                  //   validator: (value) =>
                  //       SocialMediaValidator.twitterValidator(value),
                  // ),
                  ///********************************
                  // SocialMediaTextFormFiled(
                  //   icon: SVGAssets.instagram,
                  //   validator: (value) =>
                  //       SocialMediaValidator.instagramValidator(value),
                  // ),
                  ///********************************
                  // SocialMediaTextFormFiled(
                  //   icon: SVGAssets.youtube,
                  //   validator: (value) =>
                  //       SocialMediaValidator.youtubeValidator(value),
                  // ),
                ],
              ),
            ),
          ),
          DownSection(
              text1: tr(LocaleKeys.save),
              text2: tr(LocaleKeys.help),
              onTap1: () async {
                //TODO @mriwed formkey
                await BlocProvider.of<CvCubit>(context).updateLinks(context,
                    links: Links(mapLinks: {
                      NameLink.linkedin.name: linkedinController.text,
                      NameLink.github.name: githubController.text,
                      NameLink.gitlab.name: gitlabController.text
                    }));
                // if (_formKey.currentState!.validate()) {}
              },
              onTap2: () {
                Constants.showModalBottomSheet(
                    context,
                    Container(
                      color: Theme.of(context).cardColor,
                    ));
              })
        ],
      );
}

class SocialMediaTextFormFiled extends StatelessWidget {
  const SocialMediaTextFormFiled(
      {Key? key,
      required this.icon,
      required this.validator,
      required this.controller})
      : super(key: key);
  final String icon;
  final String? Function(String?)? validator;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
              hintText: tr(LocaleKeys.link),
              prefixIcon: Padding(
                padding: EdgeInsets.all(10.sp),
                child: SvgPicture.asset(
                  icon,
                  width: 30.sp,
                  height: 30.sp,
                ),
              )),
        ),
        const SizedBox(
          height: AppSize.s10,
        ),
      ],
    );
  }
}

class SocialMediaValidator {
  static RegExp linkedinRegExp = RegExp(
      r'(?:https?:)?\/\/(?:[\w]+\.)?linkedin\.com\/in\/(?<permalink>[\w\-\_À-ÿ%]+)\/?');
  static RegExp githubRegExp = RegExp(
      r'(?:https?:)?\/\/(?:www\.)?github\.com\/(?<login>[A-z0-9_-]+)\/(?<repo>[A-z0-9_-]+)\/?');
  static RegExp stackoverflowRegExp = RegExp(
      r'(?:https?:)?\/\/(?:www\.)?stackoverflow\.com\/users\/(?<id>[0-9]+)\/(?<username>[A-z0-9-_.]+)\/?');
  static RegExp facebookRegExp = RegExp(
      r'(?:https?:)?\/\/(?:www\.)facebook.com/(?:profile.php\?id=)?(?<id>[0-9]+)');
  static RegExp telegramRegExp = RegExp(
      r'(?:https?:)?\/\/(?:t(?:elegram)?\.me|telegram\.org)\/(?<username>[a-z0-9\_]{5,32})\/?');
  static RegExp mediumRegExp =
      RegExp(r'(?:https?:)?\/\/medium\.com\/@(?<username>[A-z0-9]+)(?:\?.*)?');
  static RegExp redditRegExp = RegExp(
      r'(?:https?:)?\/\/(?:[a-z]+\.)?reddit\.com\/(?:u(?:ser)?)\/(?<username>[A-z0-9\-\_]*)\/?');
  static RegExp twitterRegExp = RegExp(
      r'(?:https?:)?\/\/(?:[A-z]+\.)?twitter\.com\/@?(?!home|share|privacy|tos)(?<username>[A-z0-9_]+)\/?');
  static RegExp instagramRegExp = RegExp(
      r'(?:https?:)?\/\/(?:www\.)?(?:instagram\.com|instagr\.am)\/(?<username>[A-Za-z0-9_](?:(?:[A-Za-z0-9_]|(?:\.(?!\.))){0,28}(?:[A-Za-z0-9_]))?)');
  static RegExp youtubeRegExp = RegExp(
      r'^(?:https?:)?\/\/(?:[A-z]+\.)?youtube.com\/channel\/(?<id>[A-z0-9-\_]+)\/?$');

  ///@LinkedIn Validator
  static String? linkedinValidator(String? value) {
    if (!linkedinRegExp.hasMatch(value!)) {
      return tr(LocaleKeys.link_is_not_correct);
    }

    return null;
  }

  ///@Github Validator
  static String? githubValidator(String? value) {
    if (!githubRegExp.hasMatch(value!)) {
      return tr(LocaleKeys.link_is_not_correct);
    }

    return null;
  }

  ///@StackOverFlow Validator
  static String? stackoverflowValidator(String? value) {
    if (!stackoverflowRegExp.hasMatch(value!)) {
      return tr(LocaleKeys.link_is_not_correct);
    }

    return null;
  }

  ///@Facebook Validator
  static String? facebookValidator(String? value) {
    if (!facebookRegExp.hasMatch(value!)) {
      return tr(LocaleKeys.link_is_not_correct);
    }

    return null;
  }

  ///@Telegram Validator
  static String? telegramValidator(String? value) {
    if (!telegramRegExp.hasMatch(value!)) {
      return tr(LocaleKeys.link_is_not_correct);
    }

    return null;
  }

  ///@Medium Validator
  static String? mediumValidator(String? value) {
    if (!mediumRegExp.hasMatch(value!)) {
      return tr(LocaleKeys.link_is_not_correct);
    }

    return null;
  }

  ///@Reddit Validator
  static String? redditValidator(String? value) {
    if (!redditRegExp.hasMatch(value!)) {
      return tr(LocaleKeys.link_is_not_correct);
    }

    return null;
  }

  ///@Twitter Validator
  static String? twitterValidator(String? value) {
    if (!twitterRegExp.hasMatch(value!)) {
      return tr(LocaleKeys.link_is_not_correct);
    }

    return null;
  }

  ///@Instagram Validator
  static String? instagramValidator(String? value) {
    if (!instagramRegExp.hasMatch(value!)) {
      return tr(LocaleKeys.link_is_not_correct);
    }

    return null;
  }

  ///@Youtube Validator
  static String? youtubeValidator(String? value) {
    if (!youtubeRegExp.hasMatch(value!)) {
      return tr(LocaleKeys.link_is_not_correct);
    }

    return null;
  }
}
