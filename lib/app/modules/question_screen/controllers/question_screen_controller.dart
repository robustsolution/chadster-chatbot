import 'package:aichatapp/app/models/category.dart';
import 'package:aichatapp/app/models/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../models/ai.dart';

class QuestionScreenController extends GetxController {
  bool isWaitng = false;
  Task? task;
  Category? category;

  final count = 0.obs;
  List<String> listString = [
    "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. ",
    "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. ",
    " Velit officia consequat duis enim velit mollit. ",
  ];
  final aiController = Get.put(AskAI());
  @override
  void onInit() {
    task = Get.arguments['task'] as Task;
    category = Get.arguments['category'] as Category;
    super.onInit();
  }

  setLoader({required bool value}) {
    isWaitng = value;
    update();
  }

  Future<String> askAi({required String input}) async {
    isWaitng = true;
    update();
    String aiResponse = await AskAI().askAiforResponse(
      cat: Get.arguments['category'],
      input: input,
      task: Get.arguments['task'],
      userId: FirebaseAuth.instance.currentUser!.uid,
    );
    // await AskAI().setQueryCount(userId: FirebaseAuth.instance.currentUser!.uid);
    // aiController.userQueries.value = await aiController.getQueryCount(
    //     userId: FirebaseAuth.instance.currentUser!.uid);

    isWaitng = false;
    update();
    return aiResponse;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
