import 'package:get/get.dart';

import '../controllers/store_screen_controller.dart';

class StoreScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoreScreenController>(
      () => StoreScreenController(),
    );
  }
}
