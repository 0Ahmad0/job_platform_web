import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/app_colors.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({
    super.key,
  });
  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  XFile? _image;
  Future _pickImage(ImageSource source, context) async {
    try {
      final image = await ImagePicker.platform.pickImage(source: source);
      if (image == null) return;
      XFile? img = XFile(image.path);
      Navigator.pop(context);
      img = await _cropImage(imageFile: img);
      setState(() {
        _image = img;
        // BlocProvider.of<UserCubit>(context).image = img;
      });
    } on PlatformException catch (e) {
      print('Error ' + e.toString());
      Navigator.of(context).pop();
    }
  }

  Future _deleteImage(context) async {
    Navigator.pop(context);
    setState(() {
      _image = null;
      // BlocProvider.of<UserCubit>(context).image = null;
      // BlocProvider.of<UserCubit>(context).photoProfileUrl = null;
    });
  }

  Future<XFile?> _cropImage({required XFile imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper.platform
        .cropImage(sourcePath: imageFile.path, uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: Theme.of(context).primaryColor,
          statusBarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Theme.of(context).primaryColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    ]);
    if (croppedImage == null) return null;
    return XFile(croppedImage.path);
  }

  _showPickerDialog(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final gabH = size.width * 0.015;
    final gabW = size.width * 0.015;
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Center(
                child: Container(
              padding: EdgeInsets.all(gabH),
              margin: EdgeInsets.all(gabH),
              width: double.infinity,
              height: size.height / 2,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Photo',
                  ),
                  Spacer(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => _pickImage(ImageSource.gallery, context),
                    leading: Icon(
                      Icons.image,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      'From Gallery',
                    ),
                  ),
                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => _pickImage(ImageSource.camera, context),
                    leading: Icon(
                      Icons.camera_alt,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      'From Camera',
                    ),
                  ),
                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => _deleteImage(context),
                    leading: Icon(
                      Icons.delete,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      'Delete Photo',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
          );
        });
  }

  @override
  void initState() {
    // BlocProvider.of<UserCubit>(context).photoProfileUrl =
    //     BlocProvider.of<UserCubit>(context).user!.photoProfileUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final gabH = size.width * 0.015;
    final gabW = size.width * 0.015;
    return Center(
      child: Stack(
        children: [
          //Constants.loading(context),

          Positioned(
            bottom: 0.0,
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.08),
              child: Container(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
                // child: ClipOval(
                //   child: _image == null
                //       ? BlocProvider.of<UserCubit>(context).photoProfileUrl !=
                //               null
                //           ? extendedImage(context,
                //               url: BlocProvider.of<UserCubit>(context)
                //                   .user!
                //                   .photoProfileUrl,
                //               // failUrl: getImageProfile(
                //               //     BlocProvider.of<UserCubit>(context)
                //               //         .user!
                //               //         .gender),
                //               emptyUrl: getImageProfile(
                //                   BlocProvider.of<UserCubit>(context)
                //                       .user!
                //                       .gender)
                //
                //               //'https://th.bing.com/th/id/R.bea813f14595bbae3b776b1cca7670be?rik=iLoZVZy1TDKAgQ&riu=http%3a%2f%2forig08.deviantart.net%2fdc08%2ff%2f2013%2f068%2f9%2f2%2fanais_cute_by_sonamy2905-d5xjknf.jpg&ehk=dWDWRnVfBf9RpyK0qZkDnIVplJUGhHwJ4Ll%2fEA%2bGS18%3d&risl=&pid=ImgRaw&r=0'
                //               )
                //           : Image.asset(
                //               getImageProfile(
                //                   BlocProvider.of<UserCubit>(context)
                //                       .user!
                //                       .gender),
                //               fit: BoxFit.fill,
                //             )
                //       : Image.file(
                //           File(
                //             _image!.path,
                //           ),
                //           fit: BoxFit.fill,
                //         ),
                // ),
              ),
            ),
          ),
          Transform.rotate(
            angle: 12.03,
            child: SvgPicture.asset(
              'SVGAssets.dashedBorder',
              width: 150,
              height: 150,
            ),
          ),
          Positioned(
            bottom: 10.0,
            left: 0.0,
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                _showPickerDialog(context);
              },
              child: Container(
                  padding: EdgeInsets.all(gabH),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        AppColors.primary,
                        AppColors.secondary,
                      ]),
                      shape: BoxShape.circle),
                  child: Icon(
                    Icons.camera_alt,
                    color: AppColors.white,
                  )),
            ),
          )
        ],
      ),
    );
  }
}

extendedImage(
  BuildContext context, {
  String? url,
  String? failUrl,
  String? emptyUrl,
}) {
  return url != null
      ? ExtendedImage.network(
          'storageUrl + (url ?? ' ')',
          fit: BoxFit.fill,
          cache: true,
          loadStateChanged: (ExtendedImageState state) {
            switch (state.extendedImageLoadState) {
              //     case LoadState.loading:
              //       return Image.asset(
              //         GifAssets.loading1,
              //         fit: BoxFit.fill,
              //       );
              //
              //     case LoadState.completed:
              //       return ExtendedRawImage(
              //           image: state.extendedImageInfo?.image,
              //           // width: ScreenUtil.instance.setWidth(600),
              //           // height: ScreenUtil.instance.setWidth(400),
              //         );
              //       break;
              case LoadState.loading:
                return Shimmer.fromColors(
                    baseColor: Theme.of(context).primaryColor.withOpacity(.30)!,
                    highlightColor:
                        Theme.of(context).primaryColor.withOpacity(.10),
                    // enabled: _enabled,
                    child: Container(
                      color: Colors.red,
                      width: 150,
                      height: 150,
                    ));
              // case LoadState.completed:
              //   return ImageDisplayWidget(
              //     imagePath: storageUrl + (url ?? ''),
              //     fit: BoxFit.fill,
              //   );
              case LoadState.failed:
                return GestureDetector(
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      SvgPicture.asset(
                        '',
                        // failUrl ?? InfoAssets.image_default2,
                        // GifAssets.loading1,
                        fit: BoxFit.fill,
                      ),

                      // Positioned(
                      //   bottom: 0.0,
                      //   left: 0.0,
                      //   right: 0.0,
                      //   child: Text(
                      //     "load image failed, click to reload",
                      //     textAlign: TextAlign.center,
                      //   ),
                      // )
                    ],
                  ),
                  onTap: () {
                    state.reLoadImage();
                  },
                );
              // default:
              //   return SizedBox.shrink();
              //       break;
            }
          },
        )
      : SvgPicture.asset(
          '',
          // emptyUrl ?? InfoAssets.image_default,
          fit: BoxFit.fill,
        );
}
