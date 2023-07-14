import 'package:get/get.dart';

import '../controllers/tasks_screen_controller.dart';

class TasksScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TasksScreenController>(
      () => TasksScreenController(),
    );
  }
}
