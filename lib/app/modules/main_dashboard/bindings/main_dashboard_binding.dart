import 'package:get/get.dart';

import '../controllers/main_dashboard_controller.dart';

class MainDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainDashboardController>(
      () => MainDashboardController(),
    );
  }
}
