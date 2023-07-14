import 'package:aichatapp/app/modules/chat/views/widgets/messageBubble.dart';
import 'package:aichatapp/app/modules/chat/views/widgets/typingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ChatController(),
        builder: (ChatController controller) {
          // print('sufyan sajid ${Auth().currentUser!.uid.toString()}');
          return Scaffold(
            backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
              elevation: 0,
              title: const Text('ChatBot',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: Color.fromRGBO(28, 28, 28, 1))),
            ),
            body: SizedBox(
              height: 1.sh,
              width: 1.sw,
              child: Stack(
                children: [
                  Obx(
                    () => Padding(
                        padding: EdgeInsets.only(bottom: 70.h),
                        child: SingleChildScrollView(
                          controller: controller.scrollController,
                          child: Column(
                            children: [
                              ...controller.messages.map((element) {
                                if (element.role == 'user')
                                  return QueryBubble(message: element.content);
                                if (element.role == 'assistant')
                                  return AnswerBubble(message: element.content);
                                return SizedBox.shrink();
                              }).toList(),
                              SizedBox(
                                width: 1.sw,
                                child: TypingIndicator(
                                  showIndicator:
                                      controller.isSomeoneTyping.value,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  // Obx(
                  //   () => Padding(
                  //     padding: EdgeInsets.only(bottom: 70.h),
                  //     child: ListView.builder(
                  //       controller: controller.scrollController,
                  //         itemCount: controller.messages.length,
                  //         itemBuilder: (context, index) {
                  //           return Column(
                  //             children: [
                  //               if (controller.messages[index].orignator ==
                  //                   Originator.sender)
                  //                 QueryBubble(
                  //                     message: controller.messages[index].message),
                  //               if (controller.messages[index].orignator ==
                  //                   Originator.receiver)
                  //                 AnswerBubble(
                  //                     message: controller.messages[index].message),
                  //               if(index ==  controller.messages.length -1)
                  //               SizedBox(
                  //                 width: 1.sw,
                  //                 child: TypingIndicator(
                  //                   showIndicator: controller.isSomeoneTyping.value,
                  //                 ),
                  //               ),
                  //             ],
                  //           );
                  //         }),
                  //   ),
                  // ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                        height: 80.h,
                        width: 1.sw,
                        padding: EdgeInsets.fromLTRB(10, 0, 5, 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.textController,
                                textAlign: TextAlign.justify,
                                readOnly: controller.isAiTyping.value,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15.w, vertical: 0),
                                  fillColor:
                                      const Color.fromRGBO(247, 248, 250, 1),
                                  filled: true,
                                  hintStyle: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  hintText: 'Enter a prompt to start a chat',
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(71, 160, 130, 1),
                                        width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(243, 244, 248, 1),
                                        width: 1),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: controller.isSomeoneTyping.value ||
                                        controller.isAiTyping.value
                                    ? null
                                    : () {
                                        controller.onSend();
                                        FocusScopeNode currentFocus =
                                            FocusScope.of(context);
                                        if (!currentFocus.hasPrimaryFocus &&
                                            currentFocus.focusedChild != null) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        }
                                      },
                                icon: Icon(
                                  Icons.send,
                                  color: controller.isSomeoneTyping.value ||
                                          controller.isAiTyping.value
                                      ? Colors.grey
                                      : Color.fromRGBO(71, 160, 130, 1),
                                ))
                          ],
                        )),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
