import 'package:get/get.dart';

import '../controllers/trail_controller.dart';

class TrailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrailController>(
      () => TrailController(),
    );
  }
}
