import 'package:get/get.dart';

import '../controller/webview_controller.dart';

class WebViewScreenBining extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebController>(
      () => WebController(),
    );
  }
}
