import 'dart:convert';
import 'dart:developer';

import 'package:aichatapp/app/constants/app_constant.dart';
import 'package:aichatapp/app/models/ai.dart';
import 'package:aichatapp/app/models/auth.dart';
import 'package:aichatapp/app/models/message.dart';
import 'package:aichatapp/app/routes/app_pages.dart';
import 'package:aichatapp/services/listen_changes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var isSomeoneTyping = false.obs;
  var isAiTyping = false.obs;
  final textController = TextEditingController();
  final scrollController = ScrollController();
  var messages = <AiMessage>[].obs;

  String? userChatHistoryId;
  final aiController = Get.put(AskAI());
  final queryController = Get.put(Auth());

  @override
  void onInit() {
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

  onSend() async {
    if (textController.text.isEmpty) {
      Get.snackbar(
        'Oops',
        'Empty prompt',
        messageText: Text(
          'Empty prompt',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red.withOpacity(.5),
      );
      return;
    }
    //user message
    if (ChangesListener.to.aiQueries < MAX_FREE_AI_USER ||
        ChangesListener.to.isSubscribed()) {
      queryController.incrementAiQueryOnTaskView(
          user: FirebaseAuth.instance.currentUser!);
      isSomeoneTyping.value = true;
      isAiTyping.value = true;
      String? response;

      if (messages.isEmpty) {
        messages.add(
          AiMessage(
            role: 'system',
            content: 'You are a helpful and polite assistant.',
            name: 'Chadster',
          ),
        );
        messages
            .add(AiMessage(role: 'user', content: textController.text.trim()));

        // call to endpoint
        response = await aiController.getChatCompletionFromOpenAI(
          userId: FirebaseAuth.instance.currentUser!.uid,
          input: textController.text,
        );

        isSomeoneTyping.value = false;
        textController.clear();
        print(111111111111111);
      } else {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 400.h,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );

        log(messages.length.toString());
        messages
            .add(AiMessage(role: 'user', content: textController.text.trim()));
        List<Map<String, dynamic>> jsonMessages = [];
        messages.forEach((msg) {
          jsonMessages.add({
            'role': msg.role,
            'content': msg.content,
            if (msg.name != null) 'name': msg.name,
          });
        });
        log(jsonMessages.toString());
        // Stringcall to endpoint
        response = await aiController.getChatCompletionFromOpenAI(
          userId: FirebaseAuth.instance.currentUser!.uid,
          input: textController.text,
          userChatHistoryId: userChatHistoryId,
          messages: json.encode(jsonMessages),
        );
        isSomeoneTyping.value = false;
        textController.clear();
      }
      log(response);
      final responseJson = json.decode(response) as Map<String, dynamic>;
      userChatHistoryId = responseJson['userChatHistoryId'];
      log('id: $userChatHistoryId');

      //ai response message
      final temp = AiMessage(
          role: responseJson['reply']['role'] == 'user' ? 'user' : 'assistant',
          content: responseJson['reply']['content']);
      messages.add(temp);

      print(response);
    } else {
      Get.toNamed(Routes.STORE_SCREEN, arguments: {
        'skip': false,
        'limitExceed': true,
      });
      Get.snackbar('Limit Exceed', 'Purchase a premium package');
    }
  }
}
