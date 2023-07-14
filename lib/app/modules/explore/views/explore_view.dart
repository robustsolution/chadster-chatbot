import 'dart:developer';

import 'package:aichatapp/app/constants/color_constant.dart';
import 'package:aichatapp/app/models/category.dart';
import 'package:aichatapp/app/models/task.dart';
import 'package:aichatapp/app/modules/explore/views/eplore_task_widget.dart';
import 'package:aichatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../services/listen_changes.dart';
import '../../../constants/app_constant.dart';
import '../controllers/explore_controller.dart';

class ExploreView extends GetView<ExploreController> {
  const ExploreView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ExploreController(),
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Text(
                'Explore',
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
                      'Favorites',
                    ),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Obx(
                      () => controller.iscatLoading.value
                          ? SizedBox()
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Obx(
                                    () => Bounce(
                                      duration: Duration(milliseconds: 300),
                                      onPressed: () {
                                        controller.ontabUpdate(null);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h, horizontal: 16.w),
                                        margin: EdgeInsets.only(right: 12.w),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(24.r),
                                          color: controller.selectedTab.value ==
                                                  null
                                              ? appTheme.primaryTheme
                                              : appTheme.greyColor,
                                        ),
                                        child: Text(
                                          'All',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                controller.selectedTab.value ==
                                                        null
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ...controller.tabTitles
                                      .map(
                                        (e) => TabItem(cat: e),
                                      )
                                      .toList()
                                ],
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    Obx(
                      () => controller.isLoading.value
                          ? Expanded(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : controller.selectedTab.value == null
                              ? Expanded(
                                  child: ListView.builder(
                                    itemCount: controller.allTask.value.length,
                                    itemBuilder: (context, index) {
                                      final map =
                                          controller.allTask.value[index];
                                      final List tasks = map[map.keys.first]!;
                                      final Category cat = controller
                                          .getCatbyName(map.keys.first);

                                      log('themssk:${cat.title}');
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            map.keys.first,
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: tasks.length,
                                            itemBuilder: (context, index) {
                                              final Task task = tasks[index];
                                              log(task.imageUrl);
                                              return ExploreTaskWidget(
                                                icon: task.imageUrl,
                                                onPressed: () {
                                                  if (ChangesListener
                                                              .to.aiQueries <
                                                          MAX_FREE_AI_USER ||
                                                      ChangesListener.to
                                                          .isSubscribed()) {
                                                    Get.toNamed(
                                                        Routes.EXPLORE_DETAIL,
                                                        arguments: {
                                                          'task': task,
                                                          'cat': cat,
                                                        });
                                                  } else {
                                                    Get.toNamed(
                                                        Routes.STORE_SCREEN,
                                                        arguments: {
                                                          'skip': false,
                                                          'limitExceed': true,
                                                        });
                                                    Get.snackbar('Limit Exceed',
                                                        'Purchase a premium package');
                                                  }
                                                },
                                                title: task.title,
                                                desc: task.desc ?? '',
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              : Expanded(
                                  child: ListView.builder(
                                    itemCount:
                                        controller.taskItemList.value.length,
                                    itemBuilder: (context, index) {
                                      final task =
                                          controller.taskItemList.value[index];
                                      log(task.imageUrl);
                                      return ExploreTaskWidget(
                                        icon: task.imageUrl,
                                        onPressed: () {
                                          if (ChangesListener.to.aiQueries <
                                                  MAX_FREE_AI_USER ||
                                              ChangesListener.to
                                                  .isSubscribed()) {
                                            Get.toNamed(Routes.EXPLORE_DETAIL,
                                                arguments: {
                                                  'task': task,
                                                  'cat': controller
                                                      .selectedTab.value,
                                                });
                                          } else {
                                            Get.toNamed(Routes.STORE_SCREEN,
                                                arguments: {
                                                  'skip': false,
                                                  'limitExceed': true,
                                                });
                                            // Get.snackbar('Limit Exceed', 'Purchase a premium package');
                                          }
                                        },
                                        title: task.title,
                                        desc: task.desc ?? '',
                                      );
                                    },
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class TabItem extends GetView<ExploreController> {
  final Category cat;

  const TabItem({required this.cat, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Bounce(
        duration: Duration(milliseconds: 300),
        onPressed: () {
          controller.ontabUpdate(cat);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          margin: EdgeInsets.only(right: 12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            color: controller.selectedTab.value != null &&
                    controller.selectedTab.value!.id == cat.id
                ? appTheme.primaryTheme
                : appTheme.greyColor,
          ),
          child: Text(
            cat.title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: controller.selectedTab.value != null &&
                      controller.selectedTab.value!.id == cat.id
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
