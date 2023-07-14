import 'dart:developer';

import 'package:aichatapp/app/models/category.dart';
import 'package:aichatapp/app/models/task.dart';
import 'package:get/get.dart';

class FavoriteTaskController extends GetxController {
  final count = 0.obs;
  final taskController = Get.put(Tasks());
  final catController = Get.put(Categories());

  List<Task> favTasks = [];
  var isLoading = false.obs;
  @override
  void onInit() {
    // getTasks();
    favTasks = taskController.favTasks;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  Future<Category> getCatById(String catId) async {
    print(catId);
    log(catController.categories.length.toString());
    List<Category> cats = await catController.fetchAndSetCats();
    return cats.firstWhere((element) =>
        element.docId.trim().toLowerCase() == catId.trim().toLowerCase());
  }
}
