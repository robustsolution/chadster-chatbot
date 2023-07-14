import 'dart:developer';

import 'package:aichatapp/app/constants/color_constant.dart';
import 'package:aichatapp/app/models/category.dart';
import 'package:aichatapp/app/modules/explore/views/eplore_task_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../services/listen_changes.dart';
import '../../../constants/app_constant.dart';
import '../../../routes/app_pages.dart';
import '../controllers/favorite_task_controller.dart';

class FavoriteTaskView extends GetView<FavoriteTaskController> {
  const FavoriteTaskView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: FavoriteTaskController(),
        builder: (FavoriteTaskController controller) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: Colors.black),
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              automaticallyImplyLeading: false,
              title: Text(
                'Explore Favorites',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: appTheme.textBlackColor,
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: TextButton.icon(
                    onPressed: () {
                      Get.toNamed(Routes.FAVORITE_TASK);
                    },
                    icon: Icon(
                      Icons.star_rounded,
                      color: Colors.yellow,
                    ),
                    label: Text(
                      'Favorite',
                    ),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: controller.favTasks.isEmpty
                  ? Center(
                      child: Text('Nothing added to favorites yet'),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          ...controller.favTasks.map(
                            (task) => ExploreTaskWidget(
                                icon: task.imageUrl,
                                title: task.title,
                                desc: task.desc!,
                                onPressed: () async {
                                  Category cat =
                                      await controller.getCatById(task.catId);
                                  log('title: ${cat.title}');
                                  if (ChangesListener.to.aiQueries <
                                          MAX_FREE_AI_USER ||
                                      ChangesListener.to.isSubscribed()) {
                                    Get.toNamed(Routes.EXPLORE_DETAIL,
                                        arguments: {
                                          'task': task,
                                          'cat': cat,
                                        });
                                  } else {
                                    Get.toNamed(Routes.STORE_SCREEN,
                                        arguments: {
                                          'skip': false,
                                          'limitExceed': true,
                                        });
                                    // Get.snackbar('Limit Exceed', 'Purchase a premium package');
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
            ),
          );
        });
  }
}
