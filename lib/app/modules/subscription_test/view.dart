// // Copyright 2013 The Flutter Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.

// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_android/billing_client_wrappers.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
// import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

// import '../../routes/app_pages.dart';
// import 'consumable_store.dart';

// // Auto-consume must be true on iOS.
// // To try without auto-consume on another platform, change `true` to `false` here.
// final bool _kAutoConsume = Platform.isIOS || true;

// const String _kConsumableId = 'consumable';
// // const String _kUpgradeId = 'upgrade';
// const String _kSilverSubscriptionId = 'ai.chadster.mobile.1week';
// const String _kGoldSubscriptionId = 'ai.chadster.mobile.1year';
// const List<String> _kProductIds = [_kSilverSubscriptionId, _kGoldSubscriptionId];

// class StoreScreenView extends StatefulWidget {
//   const StoreScreenView({super.key});

//   @override
//   State<StoreScreenView> createState() => _StoreScreenViewState();
// }

// class _StoreScreenViewState extends State<StoreScreenView> {
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//   List<String> _notFoundIds = <String>[];
//   List<ProductDetails> _products = <ProductDetails>[];
//   List<PurchaseDetails> _purchases = <PurchaseDetails>[];
//   List<String> _consumables = <String>[];
//   bool _isAvailable = false;
//   bool _purchasePending = false;
//   bool _loading = true;
//   String? _queryProductError;

//   @override
//   void initState() {
//     final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
//     _subscription = purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
//       _listenToPurchaseUpdated(purchaseDetailsList);
//     }, onDone: () {
//       _subscription.cancel();
//     }, onError: (Object error) {
//       // handle error here.
//     });
//     initStoreInfo();
//     super.initState();
//   }

//   Future<void> initStoreInfo() async {
//     final bool isAvailable = await _inAppPurchase.isAvailable();
//     if (!isAvailable) {
//       setState(() {
//         _isAvailable = isAvailable;
//         _products = <ProductDetails>[];
//         _purchases = <PurchaseDetails>[];
//         _notFoundIds = <String>[];
//         _consumables = <String>[];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }

//     if (Platform.isIOS) {
//       final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
//     }

//     final ProductDetailsResponse productDetailResponse = await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
//     if (productDetailResponse.error != null) {
//       setState(() {
//         _queryProductError = productDetailResponse.error!.message;
//         _isAvailable = isAvailable;
//         _products = productDetailResponse.productDetails;
//         _purchases = <PurchaseDetails>[];
//         _notFoundIds = productDetailResponse.notFoundIDs;
//         _consumables = <String>[];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }

//     if (productDetailResponse.productDetails.isEmpty) {
//       setState(() {
//         _queryProductError = null;
//         _isAvailable = isAvailable;
//         _products = productDetailResponse.productDetails;
//         _purchases = <PurchaseDetails>[];
//         _notFoundIds = productDetailResponse.notFoundIDs;
//         _consumables = <String>[];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }

//     final List<String> consumables = await ConsumableStore.load();
//     setState(() {
//       _isAvailable = isAvailable;
//       _products = productDetailResponse.productDetails;
//       _notFoundIds = productDetailResponse.notFoundIDs;
//       _consumables = consumables;
//       _purchasePending = false;
//       _loading = false;
//     });
//   }

//   @override
//   void dispose() {
//     if (Platform.isIOS) {
//       final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       iosPlatformAddition.setDelegate(null);
//     }
//     _subscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> stack = <Widget>[];
//     if (_queryProductError == null) {
//       stack.add(
//         ListView(
//           children: <Widget>[
//             // _buildConnectionCheckTile(),
//             _buildProductList(),
//             // _buildConsumableBox(),
//             _buildRestoreButton(),
//           ],
//         ),
//       );
//     } else {
//       stack.add(Center(
//         child: Text(_queryProductError!),
//       ));
//     }
//     if (_purchasePending) {
//       stack.add(
//         Stack(
//           children: const <Widget>[
//             Opacity(
//               opacity: 0.3,
//               child: ModalBarrier(dismissible: false, color: Colors.grey),
//             ),
//             Center(
//               child: CircularProgressIndicator(),
//             ),
//           ],
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
//         elevation: 0,
//         leading: isSkipable
//             ? IconButton(
//                 icon: const Icon(
//                   Icons.arrow_back,
//                   color: Color.fromRGBO(41, 45, 50, 1),
//                 ),
//                 onPressed: () {
//                   Get.back();
//                 },
//               )
//             : Container(),
//         centerTitle: true,
//         title: const Text('Subscription',
//             textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Color.fromRGBO(28, 28, 28, 1))),
//       ),
//       body: Stack(
//         children: stack,
//       ),
//     );
//   }

//   Card _buildConnectionCheckTile() {
//     if (_loading) {
//       return const Card(child: ListTile(title: Text('Trying to connect...')));
//     }
//     final Widget storeHeader = ListTile(
//       leading: Icon(_isAvailable ? Icons.check : Icons.block, color: _isAvailable ? Colors.green : ThemeData.light().colorScheme.error),
//       title: Text('The store is ${_isAvailable ? 'available' : 'unavailable'}.'),
//     );
//     final List<Widget> children = <Widget>[storeHeader];

//     if (!_isAvailable) {
//       children.addAll(<Widget>[
//         const Divider(),
//         ListTile(
//           title: Text('Not connected', style: TextStyle(color: ThemeData.light().colorScheme.error)),
//           subtitle: const Text(
//               'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
//         ),
//       ]);
//     }
//     return Card(child: Column(children: children));
//   }

//   Card _buildProductList() {
//     if (_loading) {
//       return const Card(child: ListTile(leading: CircularProgressIndicator(), title: Text('Fetching products...')));
//     }
//     if (!_isAvailable) {
//       return const Card();
//     }
//     const ListTile productHeader = ListTile(title: Text('Products for Sale'));
//     final List<Widget> productList = <Widget>[];
//     if (_notFoundIds.isNotEmpty) {
//       productList.add(ListTile(
//           title: Text('[${_notFoundIds.join(", ")}] not found', style: TextStyle(color: ThemeData.light().colorScheme.error)),
//           subtitle: const Text('This app needs special configuration to run. Please see example/README.md for instructions.')));
//     }

//     // This loading previous purchases code is just a demo. Please do not use this as it is.
//     // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
//     // We recommend that you use your own server to verify the purchase data.
//     final Map<String, PurchaseDetails> purchases = Map<String, PurchaseDetails>.fromEntries(_purchases.map((PurchaseDetails purchase) {
//       if (purchase.pendingCompletePurchase) {
//         _inAppPurchase.completePurchase(purchase);
//       }
//       return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
//     }));
//     productList.addAll(_products.map(
//       (ProductDetails productDetails) {
//         final PurchaseDetails? previousPurchase = purchases[productDetails.id];





//         return buildContainer(
//           text1: productDetails.title,
//           price: " ${productDetails.currencySymbol} ${productDetails.price}",
//           text2: '',
//           height: height(context) * 5,
//           ontap: () {
//             Get.toNamed(Routes.SUBSCRIPTION_TEST);
//             // controller.requestPurchase(controller.productLists[1]);
//           },
//         );

//         return ListTile(
//           title: Text(
//             productDetails.title,
//           ),
//           subtitle: Text(
//             productDetails.description,
//           ),
//           trailing: previousPurchase != null
//               ? IconButton(onPressed: () => confirmPriceChange(context), icon: const Icon(Icons.upgrade))
//               : TextButton(
//                   style: TextButton.styleFrom(
//                     backgroundColor: Colors.green[800],
//                     // ignore: deprecated_member_use
//                     primary: Colors.white,
//                   ),
//                   onPressed: () {
//                     late PurchaseParam purchaseParam;

//                     if (Platform.isAndroid) {
//                       // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
//                       // verify the latest status of you your subscription by using server side receipt validation
//                       // and update the UI accordingly. The subscription purchase status shown
//                       // inside the app may not be accurate.
//                       final GooglePlayPurchaseDetails? oldSubscription = _getOldSubscription(productDetails, purchases);

//                       purchaseParam = GooglePlayPurchaseParam(
//                           productDetails: productDetails,
//                           changeSubscriptionParam: (oldSubscription != null)
//                               ? ChangeSubscriptionParam(
//                                   oldPurchaseDetails: oldSubscription,
//                                   prorationMode: ProrationMode.immediateWithTimeProration,
//                                 )
//                               : null);
//                     } else {
//                       purchaseParam = PurchaseParam(
//                         productDetails: productDetails,
//                       );
//                     }

//                     if (productDetails.id == _kConsumableId) {
//                       _inAppPurchase.buyConsumable(purchaseParam: purchaseParam, autoConsume: _kAutoConsume);
//                     } else {
//                       _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
//                     }
//                   },
//                   child: Text(productDetails.price),
//                 ),
//         );
//       },
//     ));

//     return Card(child: Column(children: <Widget>[productHeader, const Divider()] + productList));
//   }

//   Widget buildContainer({
//     required String text1,
//     required String price,
//     required String text2,
//     required double height,
//     bool isPopular = false,
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
//             border: Border.all(width: 1, color: isPopular ? const Color.fromRGBO(71, 160, 130, 1) : Color.fromRGBO(242, 242, 242, 1))),
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
//                   color: isPopular ? const Color.fromRGBO(71, 160, 130, 1) : Colors.transparent,
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   "Continue",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     color: isPopular ? const Color.fromRGBO(71, 160, 130, 1) : Colors.white,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );

//     // Card _buildConsumableBox() {
//     //   if (_loading) {
//     //     return const Card(child: ListTile(leading: CircularProgressIndicator(), title: Text('Fetching consumables...')));
//     //   }
//     //   if (!_isAvailable || _notFoundIds.contains(_kConsumableId)) {
//     //     return const Card();
//     //   }
//     //   const ListTile consumableHeader = ListTile(title: Text('Purchased consumables'));
//     //   final List<Widget> tokens = _consumables.map((String id) {
//     //     return GridTile(
//     //       child: IconButton(
//     //         icon: const Icon(
//     //           Icons.stars,
//     //           size: 42.0,
//     //           color: Colors.orange,
//     //         ),
//     //         splashColor: Colors.yellowAccent,
//     //         onPressed: () => consume(id),
//     //       ),
//     //     );
//     //   }).toList();
//     //   return Card(
//     //       child: Column(children: <Widget>[
//     //     consumableHeader,
//     //     const Divider(),
//     //     GridView.count(
//     //       crossAxisCount: 5,
//     //       shrinkWrap: true,
//     //       padding: const EdgeInsets.all(16.0),
//     //       children: tokens,
//     //     )
//     //   ]));
//   }

//   Widget _buildRestoreButton() {
//     if (_loading) {
//       return Container();
//     }

//     return Padding(
//       padding: const EdgeInsets.all(4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           TextButton(
//             style: TextButton.styleFrom(
//               backgroundColor: Theme.of(context).primaryColor,
//               // ignore: deprecated_member_use
//               primary: Colors.white,
//             ),
//             onPressed: () => _inAppPurchase.restorePurchases(),
//             child: const Text('Restore purchases'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> consume(String id) async {
//     await ConsumableStore.consume(id);
//     final List<String> consumables = await ConsumableStore.load();
//     setState(() {
//       _consumables = consumables;
//     });
//   }

//   void showPendingUI() {
//     setState(() {
//       _purchasePending = true;
//     });
//   }

//   Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
//     // IMPORTANT!! Always verify purchase details before delivering the product.
//     if (purchaseDetails.productID == _kConsumableId) {
//       await ConsumableStore.save(purchaseDetails.purchaseID!);
//       final List<String> consumables = await ConsumableStore.load();
//       setState(() {
//         _purchasePending = false;
//         _consumables = consumables;
//       });
//     } else {
//       setState(() {
//         _purchases.add(purchaseDetails);
//         _purchasePending = false;
//       });
//     }
//   }

//   void handleError(IAPError error) {
//     setState(() {
//       _purchasePending = false;
//     });
//   }

//   Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
//     // IMPORTANT!! Always verify a purchase before delivering the product.
//     // For the purpose of an example, we directly return true.
//     return Future<bool>.value(true);
//   }

//   void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
//     // handle invalid purchase here if  _verifyPurchase` failed.
//   }

//   Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
//     for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         showPendingUI();
//       } else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           handleError(purchaseDetails.error!);
//         } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
//           final bool valid = await _verifyPurchase(purchaseDetails);
//           if (valid) {
//             deliverProduct(purchaseDetails);
//           } else {
//             _handleInvalidPurchase(purchaseDetails);
//             return;
//           }
//         }
//         if (Platform.isAndroid) {
//           if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
//             final InAppPurchaseAndroidPlatformAddition androidAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
//             await androidAddition.consumePurchase(purchaseDetails);
//           }
//         }
//         if (purchaseDetails.pendingCompletePurchase) {
//           await _inAppPurchase.completePurchase(purchaseDetails);
//         }
//       }
//     }
//   }

//   Future<void> confirmPriceChange(BuildContext context) async {
//     if (Platform.isAndroid) {
//       final InAppPurchaseAndroidPlatformAddition androidAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
//       final BillingResultWrapper priceChangeConfirmationResult = await androidAddition.launchPriceChangeConfirmationFlow(
//         sku: 'purchaseId',
//       );
//       if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Price change accepted'),
//         ));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(
//             priceChangeConfirmationResult.debugMessage ?? 'Price change failed with code ${priceChangeConfirmationResult.responseCode}',
//           ),
//         ));
//       }
//     }
//     if (Platform.isIOS) {
//       final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
//           _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
//     }
//   }

//   GooglePlayPurchaseDetails? _getOldSubscription(ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
//     // This is just to demonstrate a subscription upgrade or downgrade.
//     // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
//     // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
//     // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
//     // Please remember to replace the logic of finding the old subscription Id as per your app.
//     // The old subscription is only required on Android since Apple handles this internally
//     // by using the subscription group feature in iTunesConnect.
//     GooglePlayPurchaseDetails? oldSubscription;
//     if (productDetails.id == _kSilverSubscriptionId && purchases[_kGoldSubscriptionId] != null) {
//       oldSubscription = purchases[_kGoldSubscriptionId]! as GooglePlayPurchaseDetails;
//     } else if (productDetails.id == _kGoldSubscriptionId && purchases[_kSilverSubscriptionId] != null) {
//       oldSubscription = purchases[_kSilverSubscriptionId]! as GooglePlayPurchaseDetails;
//     }
//     return oldSubscription;
//   }
// }

// /// Example implementation of the
// /// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
// ///
// /// The payment queue delegate can be implementated to provide information
// /// needed to complete transactions.
// class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
//   @override
//   bool shouldContinueTransaction(SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
//     return true;
//   }

//   @override
//   bool shouldShowPriceConsent() {
//     return false;
//   }
// }
