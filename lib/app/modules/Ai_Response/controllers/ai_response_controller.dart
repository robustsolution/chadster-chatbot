// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/category.dart';
import '../../../models/task.dart';

// import '../../../models/category.dart';
// import '../../../models/task.dart';

class AiResponseController extends GetxController {
  Task? task;
  Category? category;
  late String input;
  late String response;
  final responseController = TextEditingController();

  @override
  void onInit() {
    task = Get.arguments['task'] as Task;
    category = Get.arguments['category'] as Category;
    input = Get.arguments['input'];
    response = Get.arguments['response'];
    responseController.text = response;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
