import 'package:aichatapp/app/models/ai.dart';
import 'package:aichatapp/app/models/category.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  List<Category> categoryItemList = [];
  var isLoading = false;
  final aiController = Get.put(AskAI());

  @override
  void onInit() async {
    print(222212457889856522);
    getHomeCategoryList();
    super.onInit();
  }

  getHomeCategoryList() async {
    isLoading = true;
    update();
    List<Category> cats = await Categories().fetchAndSetCats();
    for (int i = 0; i < cats.length; i++) {
      categoryItemList.add(cats[i]);
    }

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
