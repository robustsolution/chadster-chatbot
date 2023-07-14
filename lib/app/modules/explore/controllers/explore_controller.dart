import 'package:aichatapp/app/models/category.dart';
import 'package:aichatapp/app/models/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ExploreController extends GetxController {
  List<Category> tabTitles = [];
  Rx<List<Task>> taskItemList = Rx([]);
  Rx<List<Map<String, List<Task>>>> allTask = Rx([]);
  var isTaskLoading = false.obs;
  var iscatLoading = false.obs;
  var isLoading = false.obs;

  final Rx<Category?> selectedTab = Rx(null);

  List<Category> categories = [];

  final taskController = Get.put(Tasks());

  ontabUpdate(Category? cat) {
    if (cat != null) {
      getTaskList(docId: cat.docId);
      selectedTab.value = cat;
    } else {
      selectedTab.value = cat;
      taskItemList.value = [];
    }
  }

  @override
  void onInit() async {
    getHomeCategoryList();
    getAllTask();

    taskController.fetchFavoriteTaskIds(
        userId: FirebaseAuth.instance.currentUser!.uid);
    super.onInit();
  }

  getHomeCategoryList() async {
    iscatLoading.value = true;
    update();
    List<Category> cats = await Categories().fetchAndSetCats();
    for (int i = 0; i < cats.length; i++) {
      tabTitles.add(cats[i]);
    }
    iscatLoading.value = false;
  }

  getTaskList({required String docId}) async {
    isLoading.value = true;
    update();
    List<Task> tasks = await Tasks().fetchAndSetTasks(catDocId: docId);
    // for (int i = 0; i < tasks.length; i++) {
    //   taskItemList.value.add(tasks[i]);
    // }
    taskItemList.value = tasks;
    isLoading.value = false;
    update();
  }

  getAllTask() async {
    isLoading.value = true;
    update();
    List<Category> cats = await Categories().fetchAndSetCats();
    categories = cats;
    for (int i = 0; i < cats.length; i++) {
      List<Task> tasks =
          await Tasks().fetchAndSetTasks(catDocId: cats[i].docId);
      allTask.value.add({cats[i].title: tasks});
    }

    isLoading.value = false;
    update();
  }

  Category getCatbyName(String name) {
    return categories.firstWhere(
        (element) => element.title.toLowerCase() == name.toLowerCase());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
