import 'package:get/get.dart';

import '../controllers/explore_detail_controller.dart';

class ExploreDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExploreDetailController>(
      () => ExploreDetailController(),
    );
  }
}
