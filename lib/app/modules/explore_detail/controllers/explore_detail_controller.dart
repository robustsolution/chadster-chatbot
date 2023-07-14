import 'dart:developer';

import 'package:aichatapp/app/models/auth.dart';
import 'package:aichatapp/app/models/category.dart';
import 'package:aichatapp/app/models/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/ai.dart';

class ExploreDetailController extends GetxController {
  final InputController = TextEditingController();
  final queryController = Get.put(Auth());

  Map<String, TextEditingController> toneControllers = {};

  final taskController = Get.put(Tasks());
  final totalCount = 1.obs;

  var isgenerating = false.obs;
  var isFavorite = false.obs;

  String toneText = '';

  setText(value) {
    toneText = value;
    update();
  }

  Task? task;
  Category? cat;
  @override
  void onInit() async {
    super.onInit();
    queryController.incrementAiQueryOnTaskView(
        user: FirebaseAuth.instance.currentUser!);
    var data = Get.arguments as Map<String, dynamic>;
    cat = data['cat'] as Category;
    task = data['task'] as Task;

    print('123 id : ${task!.docId}');
    // InputController.text = task!.powerPromptPlaceholder!.isEmpty
    //     ? task!.prompt.replaceAll('\${input}', '')
    //     : task!.powerPromptPlaceholder!.replaceAll('\${input}', '');
    // toneController.text = task!.prompt_extension!.isEmpty
    //     ? ''
    //     : task!.prompt_extension![0].replaceAll('\$(input)', '');

    if (taskController.favoriteTasksIds.contains(task!.docId)) {
      isFavorite.value = true;
    } else {
      isFavorite.value = false;
    }
    // final temp = await FirebaseFirestore.instance
    //     .collection('userPromptFavs')
    //     .doc(docId)
    //     .get();
    // if (!temp.data()!.isEmpty) {
    //   isFavorite.value = true;
    // }

    if (task!.prompt_extension!.isNotEmpty) {
      task!.prompt_extension!.forEach((element) {
        toneControllers.putIfAbsent(element, () => TextEditingController());
      });

      toneText = task!.prompt_extension!.first.split('\$').first;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<String> askAi({required String input}) async {
    isgenerating.value = true;
    update();
    String extenstions = '';
    task!.prompt_extension!.forEach((element) {
      final controllerText = toneControllers[element]!.text.trim();
      if (controllerText.isNotEmpty) {
        extenstions +=
            " ${element.replaceFirst('\$(input)', '')} ${controllerText}";
      }
    });

    String prompt = task!.powerPrompt.isNotEmpty
        ? task!.powerPrompt.replaceFirst('\${input}', '\$(input)')
        : task!.prompt.replaceFirst('\${input}', '\$(input)');

    String aiResponse = await AskAI().askAiforResponse(
      cat: Get.arguments['cat'],
      input: input,
      task: Get.arguments['task'],
      userId: FirebaseAuth.instance.currentUser!.uid,
      prompt: prompt + extenstions,
    );
    // await AskAI().setQueryCount(userId: FirebaseAuth.instance.currentUser!.uid);
    // aiController.userQueries.value = await aiController.getQueryCount(
    //     userId: FirebaseAuth.instance.currentUser!.uid);

    isgenerating.value = false;
    update();
    return aiResponse;
  }

  favoriteTask() async {
    log('star');
    isFavorite.value = !isFavorite.value;
    log(isFavorite.value.toString());
    final docId = task!.docId;
    if (!isFavorite.value) {
      taskController.favTasks.removeWhere(
        (element) => element.docId == task!.docId,
      );
      taskController.favoriteTasksIds.removeWhere(
        (element) => element == task!.docId,
      );
      print('delete');
      await FirebaseFirestore.instance
          .collection('userPromptFavs')
          .doc(docId)
          .delete();
    } else {
      print('addd :${task!.title}');
      taskController.favTasks.add(task!);
      taskController.favoriteTasksIds.add(task!.docId);

      await FirebaseFirestore.instance
          .collection('userPromptFavs')
          .doc(docId)
          .set({
        'userID': FirebaseAuth.instance.currentUser!.uid,
        'taskID': task!.docId,
        'dateCreated': DateTime.now(),
      });
    }
  }
}
