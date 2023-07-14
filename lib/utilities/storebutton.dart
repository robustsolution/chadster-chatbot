import 'package:aichatapp/app/constants/sizeConstant.dart';
import 'package:aichatapp/services/listen_changes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/routes/app_pages.dart';

class StoreButton extends StatelessWidget {
  const StoreButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // height(context) => MediaQuery.of(context).size.height / 100;
    // width(context) => MediaQuery.of(context).size.width / 100;

    final isSub = ChangesListener.to.isSubscribed();

    if (isSub) {
      return SizedBox(
        height: MySize.getHeight(35),
      );
    }

    return InkWell(
      onTap: () {
        Get.toNamed(Routes.STORE_SCREEN, arguments: {
          'skip': false,
          'limitExceed': false,
        });
      },
      child: Container(
        height: MySize.getHeight(35),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
            color: Color.fromRGBO(71, 160, 130, 1),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Text(
              'Premium',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Image.asset(
              'assets/image/Vector.png',
              fit: BoxFit.cover,
              // width: 20,
              // height: 20,
              // height: 50,
              // width: 50,
            ),
          ],
        ),
      ),
    );
  }
}
