import 'package:aichatapp/app/modules/webview/controller/webview_controller.dart';
import 'package:aichatapp/utilities/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends GetWidget<WebController> {
  const WebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: WebController(),
        builder: (WebController controller) {
          return Scaffold(
            appBar: buildAppBar(
                title: Get.arguments['title'], trailing: Container()),
            body: WebViewWidget(controller: controller.controller!),
          );
        });
  }
}
