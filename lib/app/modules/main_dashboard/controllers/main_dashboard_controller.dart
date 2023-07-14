import 'dart:developer';

import 'package:aichatapp/app/constants/app_constant.dart';
import 'package:aichatapp/app/models/auth.dart';
import 'package:aichatapp/app/modules/chat/views/chat_view.dart';
import 'package:aichatapp/app/modules/explore/views/explore_view.dart';
import 'package:aichatapp/app/modules/home_screen/views/home_screen_view.dart';
import 'package:aichatapp/services/listen_changes.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenjin_sdk/tenjin_sdk.dart';

import '../../../../utilities/review_widget.dart';
import '../../../models/ai.dart';
import '../../../models/category.dart';
import '../../save_screen/views/save_screen_view.dart';
import '../../setting_screen/views/setting_screen_view.dart';
import '../../store_screen/views/store_screen_view.dart';

class MainDashboardController extends GetxController {
  PageController pageController = PageController();
  int selectedIndex = 0;
  List<Category> categoryItemList = [];
  var isLoading = false;
  int counter = 0;
  final aiController = Get.put(AskAI());
  final auth = Get.put(Auth());
  AppsflyerSdk? appsflyerSdk;
  @override
  void onInit() async {
    //---------appsflyer integration--------------
    final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: '8ENkrZdTXMbgZuTttx7fAB',
        appId: '1665164822',
        showDebug: true,
        timeToWaitForATTUserAuthorization: 15);
    appsflyerSdk = AppsflyerSdk(options);
    appsflyerSdk?.onAppOpenAttribution((res) {
      log("onAppOpenAttribution res: " + res.toString());
    });

    appsflyerSdk!.onInstallConversionData((res) {
      log("onInstallConversionData res: " + res.toString());
    });
    appsflyerSdk!.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );

    // appsflyerSdk!.logEvent('Login', {
    //   "Name": "Sufyan",
    //   "Time": 12,
    // });

    //-----------tenjin integration-------------------
    TenjinSDK.instance.init(apiKey: tenjinApiKey);
    TenjinSDK.instance.optIn();
    TenjinSDK.instance.registerAppForAdNetworkAttribution();
    TenjinSDK.instance.eventWithName('Sufyan Testing 123');

//------------------- messengin------------------
    var messaging = FirebaseMessaging.instance;
    final changelistener = ChangesListener.to;
    if (changelistener.isSubscribed()) {
      messaging.subscribeToTopic('activeSubs');
      messaging.unsubscribeFromTopic('inActiveSubs');
    } else {
      messaging.subscribeToTopic('inActiveSubs');
      messaging.unsubscribeFromTopic('activeSubs');
    }

    setCounter();
    // aiController.userQueries.value = await aiController.getQueryCount(
    //     userId: FirebaseAuth.instance.currentUser!.uid);
    // await auth.setFirstVisit();
    super.onInit();
  }

  void setTabIndex({required int index}) {
    selectedIndex = index;
    update();
  }

  void setCounter() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var _count = pref.getInt('counter') ?? 0;

    _count++;

    counter = _count;
    update();
    log('counter: $counter');
    if (counter >= 5) {
      log('asking for review');
      showRatingDialog(
          title: 'Chadster',
          message: 'Tap a star to rate it on the App Store',
          appStoreId: '1665164822');
      // await AppReview().showReviewPrompt();
      _count = 0;
    }
    pref.setInt('counter', _count);
  }

  List<Widget> tabs = [
    HomeScreenView(),
    ExploreView(),
    StoreScreenView(),
    SaveScreenView(),
    ChatView(),
    SettingScreenView()
  ];
  // changestaus(){
  //   isLoading=!isLoading;
  // }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
