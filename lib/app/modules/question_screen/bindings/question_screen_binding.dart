import 'package:get/get.dart';

import '../controllers/question_screen_controller.dart';

class QuestionScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuestionScreenController>(
      () => QuestionScreenController(),
    );
  }
}
