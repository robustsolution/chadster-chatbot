import 'dart:async';

import 'package:aichatapp/app/modules/chat/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get/get.dart';

class QueryBubble extends StatelessWidget {
  final String message;

  const QueryBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: .9.sw,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AnswerBubble extends StatefulWidget {
  final String message;

  const AnswerBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<AnswerBubble> createState() => _AnswerBubbleState();
}

class _AnswerBubbleState extends State<AnswerBubble> {
  Timer? timer;

  final chatController = Get.put(ChatController());

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print("object");
      chatController.scrollController.animateTo(
        chatController.scrollController.position.maxScrollExtent + 20,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(71, 160, 130, 1),
              borderRadius: BorderRadius.circular(12)),
          width: .9.sw,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      widget.message,
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      speed: const Duration(milliseconds: 30),
                    ),
                  ],
                  totalRepeatCount: 1,
                  // pause: const Duration(milliseconds: 1000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                  onFinished: () {
                    timer!.cancel();
                    chatController.isAiTyping.value = false;
                    chatController.scrollController.animateTo(
                      chatController.scrollController.position.maxScrollExtent,
                      duration: Duration(microseconds: 5),
                      curve: Curves.fastOutSlowIn,
                    );
                  })
            ],
          ),
        ),
      ],
    );
  }
}
