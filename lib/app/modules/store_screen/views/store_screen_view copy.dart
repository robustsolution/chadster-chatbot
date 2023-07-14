// import 'package:aichatapp/app/routes/app_pages.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// import 'package:get/get.dart';

// import '../controllers/store_screen_controller.dart';

// class StoreScreenView extends GetView<StoreScreenController> {
//   final controller = Get.put(StoreScreenController());

//   @override
//   Widget build(BuildContext context) {
//     bool isSkipable = false;
//     isSkipable = Get.arguments == null ? false : true;
//     height(context) => MediaQuery.of(context).size.height / 100;
//     // width(context) => MediaQuery.of(context).size.width / 100;
//     return Obx(() {
//       return Scaffold(
//           backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
//           appBar: AppBar(
//             backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
//             elevation: 0,
//             leading: isSkipable
//                 ? IconButton(
//                     icon: const Icon(
//                       Icons.arrow_back,
//                       color: Color.fromRGBO(41, 45, 50, 1),
//                     ),
//                     onPressed: () {
//                       Get.back();
//                     },
//                   )
//                 : Container(),
//             centerTitle: true,
//             title: const Text('Subscription',
//                 textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Color.fromRGBO(28, 28, 28, 1))),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 isSkipable
//                     ? TextButton(
//                         onPressed: () {
//                           Get.toNamed(Routes.MAIN_DASHBOARD);
//                         },
//                         child: const Text(
//                           'skip',
//                           style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Color.fromRGBO(28, 28, 28, 1)),
//                         ),
//                       )
//                     : Container(
//                         height: height(context) * 8,
//                       ),
//                 ClipRRect(
//                   child: Banner(
//                     message: 'Best deal',
//                     color: Color.fromRGBO(255, 152, 0, 1),
//                     location: BannerLocation.topEnd,
//                     child: buildContainer(
//                       text1: '1 year',
//                       price: '99.99',
//                       text2: '/year',
//                       height: height(context) * 5,
//                       index: 0,
//                       ontap: () {
//                         Get.toNamed(Routes.SUBSCRIPTION_TEST);
//                         // controller.requestPurchase(controller.productLists[1]);
//                       },
//                     ),
//                   ),
//                 ),
//                 buildContainer(
//                   text1: '1 week',
//                   price: '4.99',
//                   text2: '/week',
//                   height: height(context) * 5,
//                   index: 1,
//                   ontap: () {
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//     });
//   }

//   Widget buildContainer({
//     required String text1,
//     required String price,
//     required String text2,
//     required double height,
//     required int index,
//     required Function()? ontap,
//   }) {
//     return GestureDetector(
//       onTap: () {
//         // controller.selectedIndex.value = index;
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 24),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         width: double.infinity,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//                 width: 1, color: controller.selectedIndex.value == index ? const Color.fromRGBO(71, 160, 130, 1) : Color.fromRGBO(242, 242, 242, 1))),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               text1,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 20,
//                 color: Color.fromRGBO(71, 160, 130, 1),
//               ),
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             RichText(
//               text: TextSpan(children: [
//                 TextSpan(
//                   text: "\$$price",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 32,
//                     color: Color.fromRGBO(28, 28, 28, 1),
//                   ),
//                 ),
//                 TextSpan(
//                   text: text2,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 18,
//                     color: Color.fromRGBO(81, 81, 81, 1),
//                   ),
//                 ),
//               ]),
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             Row(
//               children: [
//                 SvgPicture.asset(
//                   'assets/image/bolt.svg',
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 const Text(
//                   "Unlimited Chats",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 12,
//                     color: Color.fromRGBO(28, 28, 28, 1),
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             Row(
//               children: [
//                 SvgPicture.asset(
//                   'assets/image/bolt.svg',
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 const Text(
//                   "Most Advance GPT-3",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 12,
//                     color: Color.fromRGBO(28, 28, 28, 1),
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             InkWell(
//               borderRadius: BorderRadius.circular(12),
//               onTap: ontap,
//               splashColor: const Color.fromRGBO(71, 160, 130, 1).withOpacity(0.5),
//               child: Container(
//                 height: height,
//                 // width: getProportionateScreenWidth(270),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: const Color.fromRGBO(71, 160, 130, 1), width: 1),
//                   color: controller.selectedIndex.value == index ? const Color.fromRGBO(71, 160, 130, 1) : Colors.transparent,
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   "Continue",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     color: controller.selectedIndex.value != index ? const Color.fromRGBO(71, 160, 130, 1) : Colors.white,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
