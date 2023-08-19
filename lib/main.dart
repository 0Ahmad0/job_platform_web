import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:job_platform_web/src/app.dart';

import 'translations/codegen_loader.g.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await NotificationController.initializeLocalNotifications();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      path: 'assets/translations/',
      supportedLocales: [
        Locale("en"),
        Locale("ar"),
      ],
      fallbackLocale: Locale('en'),
      assetLoader: CodegenLoader(),
      // child: MyApp(),
      child: JopPlatformWeb(),
    ),
  );
}
