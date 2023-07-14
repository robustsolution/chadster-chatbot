import 'dart:developer';

import 'package:aichatapp/app/models/auth.dart';
import 'package:aichatapp/app/models/category.dart';
import 'package:aichatapp/app/models/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class TasksScreenController extends GetxController {
  List<Task> taskItemList = [];
  var isLoading = false;
  late Category cat;
  final queryController = Get.put(Auth());

// setCatId({required String id}){
//   catDocId=id;
//   update();
// }
  @override
  void onInit() {
    queryController.incrementAiQueryOnTaskView(
        user: FirebaseAuth.instance.currentUser!);
    cat = Get.arguments;

    getTaskList(docId: cat.docId);
    super.onInit();
  }

  // changestaus(){
  //   isLoading=!isLoading;
  // }

  getTaskList({required String docId}) async {
    isLoading = true;
    update();
    List<Task> tasks = await Tasks().fetchAndSetTasks(catDocId: docId);
    print('bdhfbdasjfbsdjbvsjfbsdjbfdjbadfdh${tasks.length}');
    for (int i = 0; i < tasks.length; i++) {
      taskItemList.add(tasks[i]);
    }

    log('sufyansajid${taskItemList.length.toString()}');
    isLoading = false;
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
