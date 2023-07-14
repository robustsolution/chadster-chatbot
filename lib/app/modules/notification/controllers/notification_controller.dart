// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
// import 'package:aichatapp/app/routes/app_pages.dart';
// import 'package:permission_handler/permission_handler.dart';

class NotificationController extends GetxController {
  @override
  void onInit() {
    doInit();

    super.onInit();
  }

  Future<void> doInit() async {
    // var perms = Permission.notification;
    // if (await perms.isGranted) {
    //   Get.toNamed(Routes.TRAIL);
    // }
    // ;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
