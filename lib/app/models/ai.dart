import 'dart:developer';

import 'package:aichatapp/app/models/category.dart';

import 'package:aichatapp/app/models/task.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

class AskAI extends GetxController {
  // RxInt userQueries = 0.obs;
// getTextCompletionFromOpenAI
  Future<String> askAiforResponse({
    required Category cat,
    required String input,
    required Task task,
    required String userId,
    String prompt = '',
  }) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'getTextCompletionFromOpenAI',
        options: HttpsCallableOptions());

    final resp = await callable.call(<String, dynamic>{
      'userId': userId,
      'categoryId': cat.docId,
      'categoryName': cat.title,
      'taskId': task.docId,
      if (prompt.isNotEmpty)
        'prompt': prompt
      else
        'prompt': task.prompt.replaceFirst('\${input}', '\$(input)'),
      'input': input,
    });
    log(task.prompt.replaceFirst('\${input}', '\$(input)') + prompt);
    log("sufyan result: ${resp.data.toString()}");
    return resp.data.toString();
  }

  Future<String> getChatCompletionFromOpenAI({
    required String userId,
    required String input,
    String? userChatHistoryId,
    String? messages,
  }) async {
    // HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
    //     'getChatCompletionFromOpenAI',
    //     options: HttpsCallableOptions());
    final url = Uri.parse(
        'https://us-central1-chatgpt-2e83e.cloudfunctions.net/requestChatCompletionFromOpenAI');
    Map<String, dynamic> body = {};
    if (userChatHistoryId == null && messages == null) {
      body = <String, dynamic>{
        'userId': userId,
        'input': input,
      };
    }
    //  else if (userChatHistoryId == null) {
    //   body = <String, dynamic>{
    //     'userId': userId,
    //     'input': input,
    //     'messages': messages
    //   };
    // }
    // else if (messages == null) {
    //   body = <String, dynamic>{
    //     'userId': userId,
    //     'input': input,
    //     'userChatHistoryId': userChatHistoryId,
    //   };
    // }
    else {
      body = <String, dynamic>{
        'userId': userId,
        'input': input,
        'userChatHistoryId': userChatHistoryId,
        'messages': messages
      };
    }

    // final resp = await callable.call(body);
    final res = await http.post(url, body: body);
    log('requestBody;$body');
    // log("Shehroz result: ${resp.data.toString()}");
    return res.body;
  }

  //---------------user query info----------------

  //-----------------------set queries count----------------

  // Future<void> setQueryCount({required String userId}) async {
  //   // CollectionReference users = FirebaseFirestore.instance.collection('users');

  //   // users.doc(userId).update({
  //   //   'ai_queries': FieldValue.increment(1),
  //   // });
  // }

  // Future<int> getQueryCount({required String userId}) async {
  //   log('userId: ${userId}');
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');
  //   DocumentSnapshot doc = await users.doc(userId).get();
  //   var response = doc.data() as Map<String, dynamic>;
  //   log('themssk: ${response['ai_queries']}');
  //   return response['ai_queries'];
  // }
}
