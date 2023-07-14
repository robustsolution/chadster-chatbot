import 'package:get/get.dart';
import 'package:tenjin_sdk/tenjin_sdk.dart';

class Tenjin extends GetxController {
  void connectSdk() {
    TenjinSDK.instance.connect();
  }

  void addEventByName({required String eventName}) {
    TenjinSDK.instance.eventWithName(eventName);
  }

  void recordTransaction({
    required String prodId,
    required String currencyCode,
    required double unit,
    required int quantity,
  }) {
    TenjinSDK.instance.transaction(
        productId: prodId,
        currencyCode: currencyCode,
        unitPrice: unit,
        quantity: quantity);
  }
}
