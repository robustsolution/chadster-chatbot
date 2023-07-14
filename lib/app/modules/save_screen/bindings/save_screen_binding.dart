import 'package:get/get.dart';

import '../controllers/save_screen_controller.dart';

class SaveScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaveScreenController>(
      () => SaveScreenController(),
    );
  }
}
