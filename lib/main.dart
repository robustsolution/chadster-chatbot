// import 'dart:io';

import 'package:aichatapp/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'app/constants/app_module.dart';
import 'app/constants/color_constant.dart';
import 'app/routes/app_pages.dart';
import 'services/in_app_purchase_listener.dart';
import 'services/listen_changes.dart';

final getIt = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setUp();
  await Get.putAsync<ChangesListener>(() async => ChangesListener());
  await Get.putAsync<InAppPurchaseListener>(
      () async => InAppPurchaseListener());

  runApp(
    ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              canvasColor: appTheme.backgroundColor,
            ),
            title: "Application",
            initialRoute:
                // Routes.EXPLORE_RESPONSE,
                FirebaseAuth.instance.currentUser == null
                    ? Routes.LOGIN_SCREEN
                    : Routes.TRAIL,
            getPages: AppPages.routes,
          );
        }),
  );
}
