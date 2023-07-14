import 'package:get/get.dart';

class Message {
  String id;
  String role;
  String content;
  String? name;

  Message({
    required this.id,
    required this.role,
    required this.content,
  });
}

class Chats extends GetxController {
  Future<void> startChat({required String userId, required String}) async {}
}
