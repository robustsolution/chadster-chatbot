import 'dart:async';

import 'package:aichatapp/services/tenjin.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../app/modules/main_dashboard/controllers/main_dashboard_controller.dart';

class InAppPurchaseListener extends GetxService {
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  bool isProccessed = false;

  static InAppPurchaseListener to = Get.find();

  @override
  void onInit() {
    final InAppPurchase _inAppPurchase = InAppPurchase.instance;
    final tengin = Get.put(Tenjin());
    final appflyer = Get.put(MainDashboardController());
    _subscription = _inAppPurchase.purchaseStream.listen((List<PurchaseDetails> purchaseDetailsList) async {
      for (var details in purchaseDetailsList) {
        // final productInfo = kSubscriptionIds.map((e) => {}).toList();

        print(details.status);
        print(details.transactionDate);

        if (details.status == PurchaseStatus.restored || details.status == PurchaseStatus.purchased) {
          // DateTime.fromMillisecondsSinceEpoch(details.transactionDate!);
          print("purchaseID");
          print(details.purchaseID);
          print("verificationData");
          print(details.verificationData.source);
          print(details.verificationData.localVerificationData);
          print(details.verificationData.serverVerificationData);

          // if (!isProccessed) return;
          if (FirebaseAuth.instance.currentUser == null) return;
          // var duration = _getDuration(details.productID);

          final uid = FirebaseAuth.instance.currentUser?.uid ?? "";

          HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('verifyPurchase', options: HttpsCallableOptions());
          callable.call(<String, dynamic>{
            'source': details.verificationData.source,
            'verificationData': details.verificationData.serverVerificationData,
            'productId': details.productID,
            'userId': uid,
          }).then((value) {
            if (value == true) {
              //-----tenjin transaction log------
              tengin.recordTransaction(
                prodId: details.productID,
                currencyCode: 'currencyCode',
                unit: 0,
                quantity: 0,
              );

              //-----appslflyer transaction entry------
              appflyer.appsflyerSdk!.useReceiptValidationSandbox(true);
              appflyer.appsflyerSdk!.validateAndLogInAppIosPurchase(
                details.productID,
                'price',
                'currency',
                'transactionId',
                {"fs": "fs"},
              );
            }
          });

          // var doc = FirebaseFirestore.instance.collection('users').doc(uid);

          // final res = await doc.get();

          // if (!res.exists) return;

          // var response = res.data() as Map<String, dynamic>;

          // final _subcriptionDate = (response['subscription'] as Timestamp).toDate();

          // if (_subcriptionDate.isBefore(DateTime.now())) {
          //   await doc.update({"subscription": DateTime.now().add(duration)});
          // } else {
          //   await doc.update({"subscription": _subcriptionDate.add(duration)});
          // }

          // isProccessed = false;

          print("purchaseID");
          print(details.purchaseID);
          print("verificationData");
          print(details.verificationData.source);
          print(details.verificationData.localVerificationData);
          print(details.verificationData.serverVerificationData);
        }
      }
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });

    super.onInit();
  }

  Duration _getDuration(String id) {
    if (id == "ai.chadster.mobile.1year") {
      return Duration(days: 365);
    }
    if (id == "ai.chadster.mobile.1week") {
      return Duration(days: 7);
    }

    return Duration(days: 7);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
