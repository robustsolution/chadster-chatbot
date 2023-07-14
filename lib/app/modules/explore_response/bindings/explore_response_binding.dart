import 'package:get/get.dart';

import '../controllers/explore_response_controller.dart';

class ExploreResponseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExploreResponseController>(
      () => ExploreResponseController(),
    );
  }
}
