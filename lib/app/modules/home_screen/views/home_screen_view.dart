import 'package:aichatapp/app/constants/color_constant.dart';
import 'package:aichatapp/app/constants/sizeConstant.dart';
import 'package:aichatapp/app/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../services/listen_changes.dart';
import '../../../../utilities/storebutton.dart';
import '../../../constants/app_constant.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_screen_controller.dart';

class HomeScreenView extends GetWidget<HomeScreenController> {
  buildDailog() {
    return Get.dialog(AlertDialog(
      title: Text('testing'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            'Okay',
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: HomeScreenController(),
        builder: (HomeScreenController controller) {
          // print('sufyan sajid ${Auth().currentUser!.uid.toString()}');
          return Scaffold(
              body: controller.isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MySize.getHeight(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Spacing.height(50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "What can I help you with?",
                                style: TextStyle(
                                    fontSize: MySize.getHeight(18),
                                    fontWeight: FontWeight.w800),
                              ),
                              StoreButton(),
                            ],
                          ),
                          Spacing.height(0),
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: MySize.getWidth(16),
                                      mainAxisSpacing: MySize.getHeight(16),
                                      childAspectRatio:
                                          MySize.getHeight(1.547)),
                              itemCount: controller.categoryItemList.length,
                              itemBuilder: (context, index) {
                                return getContainer(
                                  image: controller
                                      .categoryItemList[index].imageUrl,
                                  title:
                                      controller.categoryItemList[index].title,
                                  index: index,
                                  cat: controller.categoryItemList[index],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ));
        });
  }

  Widget getContainer({
    required String image,
    required String title,
    required int index,
    required Category cat,
  }) {
    return InkWell(
      onTap: () {
        if (ChangesListener.to.aiQueries < MAX_FREE_AI_USER ||
            ChangesListener.to.isSubscribed()) { 
          Get.toNamed(Routes.TASKS_SCREEN, arguments: cat);
        } else {
          Get.toNamed(Routes.STORE_SCREEN, arguments: {
            'skip': false,
            'limitExceed': true,
          });
          // Get.snackbar('Limit Exceed', 'Purchase a premium package');
        }
      },
      child: Container(
        height: MySize.getHeight(106),
        width: MySize.getWidth(164),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: appTheme.borderGreyColor),
          borderRadius: BorderRadius.circular(
            MySize.getHeight(15),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: MySize.getWidth(16)),
              child: image.isEmpty
                  ? SvgPicture.asset(
                      '${imagePath}home_custom_icon.svg',
                      height: MySize.getHeight(30),
                      width: MySize.getWidth(30),
                    )
                  : SvgPicture.network(
                      image,
                      height: MySize.getHeight(30),
                      width: MySize.getWidth(30),
                    ),
            ),
            Spacing.height(12),
            Padding(
              padding: EdgeInsets.only(left: MySize.getWidth(16)),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: MySize.getHeight(16),
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
