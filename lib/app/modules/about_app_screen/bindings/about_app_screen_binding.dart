import 'package:get/get.dart';

import '../controllers/about_app_screen_controller.dart';

class AboutAppScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutAppScreenController>(
      () => AboutAppScreenController(),
    );
  }
}
