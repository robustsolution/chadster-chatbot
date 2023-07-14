import 'package:get/get.dart';

import '../controllers/favorite_task_controller.dart';

class FavoriteTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoriteTaskController>(
      () => FavoriteTaskController(),
    );
  }
}
