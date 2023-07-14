import 'package:get/get.dart';

import '../controllers/ai_response_controller.dart';

class AiResponseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiResponseController>(
      () => AiResponseController(),
    );
  }
}
