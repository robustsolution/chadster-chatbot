import 'package:get/get.dart';

class SettingScreenController extends GetxController {
  bool isDeleting = false;
  @override
  void onInit() {
    super.onInit();
  }

  setDelete({required bool value}) {
    isDeleting = value;
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
