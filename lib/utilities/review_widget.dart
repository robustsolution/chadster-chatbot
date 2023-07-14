import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:rating_dialog/rating_dialog.dart';

void showRatingDialog({
  required String title,
  required String message,
  // required String imageUrl,
  String? commentHint,
  String? appStoreId,
  String? microsoftStoreId,
}) {
  // actual store listing review & rating
  void _rateAndReviewApp() async {
    // refer to: https://pub.dev/packages/in_app_review
    final _inAppReview = InAppReview.instance;

    if (await _inAppReview.isAvailable()) {
      print('request actual review from store');
      _inAppReview.requestReview();
    } else {
      print('open actual store listing');
    
      _inAppReview.openStoreListing(
        appStoreId: appStoreId,
        microsoftStoreId: microsoftStoreId,
      );
    }
  }

  final _dialog = RatingDialog(
    initialRating: 5.0,
    // your app's name?
    title: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    // encourage your user to leave a high rating?
    message: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 15),
    ),
    // your app's logo?
    // image: const FlutterLogo(size: 100),
    submitButtonText: 'Submit',
    commentHint: commentHint ?? '',
    onCancelled: () => print('cancelled'),
    onSubmitted: (response) {
      print('rating: ${response.rating}, comment: ${response.comment}');

    
      if (response.rating < 3.0) {
        // send their comments to your email or anywhere you wish
        // ask the user to contact you instead of leaving a bad review
      } else {
        _rateAndReviewApp();
      }
    },
  );

  Get.dialog(_dialog);
}
