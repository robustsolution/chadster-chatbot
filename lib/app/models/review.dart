import 'dart:developer';

import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';

class AppReview extends GetxController {
  Future<void> getAppReview() async {
    final InAppReview inAppReview = InAppReview.instance;

    inAppReview.openStoreListing(appStoreId: '1665164822');
  }

  Future<void> showReviewPrompt() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      log('is available');
      inAppReview.requestReview();
    }
  }
}
