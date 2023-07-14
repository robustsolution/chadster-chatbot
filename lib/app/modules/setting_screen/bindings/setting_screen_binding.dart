import 'package:get/get.dart';

import '../controllers/setting_screen_controller.dart';

class SettingScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingScreenController>(
      () => SettingScreenController(),
    );
  }
}
