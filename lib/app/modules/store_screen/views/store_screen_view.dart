// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:aichatapp/app/constants/app_constant.dart';
import 'package:aichatapp/app/constants/color_constant.dart';
import 'package:aichatapp/services/in_app_purchase_listener.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:duration/duration.dart';

import '../../../../services/listen_changes.dart';
import '../../../routes/app_pages.dart';

// Auto-consume must be true on iOS.
// To try without auto-consume on another platform, change `true` to `false` here.
final bool _kAutoConsume = Platform.isIOS || true;

const String _kConsumableId = 'consumable';
// const String _kUpgradeId = 'upgrade';
const String _kSilverSubscriptionId = 'ai.chadster.mobile.1week';
const String _kGoldSubscriptionId = 'ai.chadster.mobile.1year';
const List<String> _kProductIds = kSubscriptionIds;

class StoreScreenView extends StatefulWidget {
  const StoreScreenView({super.key});

  @override
  State<StoreScreenView> createState() => _StoreScreenViewState();
}

class _StoreScreenViewState extends State<StoreScreenView> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  // List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
    initStoreInfo();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        // _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        // _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        // _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    // final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      // _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSkipable = false;
    print(FirebaseAuth.instance.currentUser?.uid);
    isSkipable = Get.arguments == null ? false : Get.arguments['skip'];
    // isLimit = Get.arguments == null ? false : Get.arguments['limitExceed'];

    // height(context) => MediaQuery.of(context).size.height / 100;

    final List<Widget> stack = <Widget>[];
    if (_queryProductError == null) {
      stack.add(
        ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Obx(() {
              var date = ChangesListener.to.subcriptionDate;

              bool isSubscribed = date.value.isAfter(DateTime.now());

              if (!isSubscribed) {
                return SizedBox.shrink();
              }

              var diff = date.value.difference(DateTime.now());
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "You are already subscribed",
                        style: TextStyle(
                          color: appTheme.primaryTheme,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text("Subscription Ends in: " +
                          printDuration(
                            diff,
                            tersity: DurationTersity.day,
                          )),
                    ],
                  ),
                ),
              );
            }),
            if (isSkipable)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.MAIN_DASHBOARD);
                    },
                    child: const Text(
                      'skip',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color.fromRGBO(28, 28, 28, 1)),
                    ),
                  ),
                ],
              ),

            Obx(() {
              var date = ChangesListener.to.subcriptionDate;
              bool isSubscribed = date.value.isAfter(DateTime.now());
              bool isLimit = (ChangesListener.to.aiQueries < MAX_FREE_AI_USER ||
                  isSubscribed);
              if (isLimit) return SizedBox();
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  '*You Reached your limit of Free AI uses',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              );
            }),

            _buildProductList(),
            // _buildRestoreButton(),
            if (!_loading)
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: BaseTheme().primaryTheme,
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Note: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Payment will be charged to your credit card through your iTunes account at confirmation of purchase. Subscription renews automatically unless canceled at least 24 hours prior to the end of the subscription period. There is no increase in price when renewing. Any unused portion of a free trial period, if offered, will be forfeited.Subscriptions can be managed and auto-renewal turned off in Account Settings in iTunes after purchase. Once purchased, refunds will not be provided for any unused portion of the term.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.6), fontSize: 13),
                    ),
                  ],
                ),
              )
          ],
        ),
      );
    } else {
      stack.add(Center(
        child: Text(_queryProductError!),
      ));
    }
    if (_purchasePending) {
      stack.add(
        Stack(
          children: const <Widget>[
            Opacity(
              opacity: 0.3,
              child: ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
        elevation: 0,
        // leading: !isSkipable
        //     ? IconButton(
        //         icon: const Icon(
        //           Icons.arrow_back,
        //           color: Color.fromRGBO(41, 45, 50, 1),
        //         ),
        //         onPressed: () {
        //           Get.back();
        //         },
        //       )
        //     : Container(),
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Subscription',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Color.fromRGBO(28, 28, 28, 1))),
      ),
      body: Stack(
        children: stack,
      ),
    );
  }

  Widget _buildProductList() {
    if (_loading) {
      return ListTile(
          leading: CircularProgressIndicator(), title: Text('Please wait...'));
    }
    if (!_isAvailable) {
      return const SizedBox();
    }
    final List<Widget> productList = <Widget>[];
    if (_notFoundIds.isNotEmpty) {
      productList.add(ListTile(
          title: Text('[${_notFoundIds.join(", ")}] not found',
              style: TextStyle(color: ThemeData.light().colorScheme.error)),
          subtitle: const Text(
              'This app needs special configuration to run. Please see example/README.md for instructions.')));
    }
    final Map<String, PurchaseDetails> purchases =
        Map<String, PurchaseDetails>.fromEntries(
            _purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));

    List<ProductDetails> _sortedProducts = List.from(_products);
    _sortedProducts.sort((a, b) => (b.rawPrice - a.rawPrice).toInt());

    productList.addAll(_sortedProducts.map(
      (ProductDetails productDetails) {
        height(context) => MediaQuery.of(context).size.height / 100;

        var buildContainer2 = buildContainer(
          text1: productDetails.title,
          price: productDetails.price,
          text2: '/' + productDetails.description.split("for ").last,
          height: height(context) * 5,
          isPopular: productDetails.title.toLowerCase().contains("year"),
          ontap: () {
            if (ChangesListener.to.isSubscribed()) {
              Get.snackbar('Error', 'Already subscribed.');
              return;
            }

            InAppPurchaseListener.to.isProccessed = true;

            late PurchaseParam purchaseParam;

            if (Platform.isAndroid) {
              final GooglePlayPurchaseDetails? oldSubscription =
                  _getOldSubscription(productDetails, purchases);

              purchaseParam = GooglePlayPurchaseParam(
                  productDetails: productDetails,
                  changeSubscriptionParam: (oldSubscription != null)
                      ? ChangeSubscriptionParam(
                          oldPurchaseDetails: oldSubscription,
                          prorationMode:
                              ProrationMode.immediateWithTimeProration,
                        )
                      : null);
            } else {
              purchaseParam = PurchaseParam(
                productDetails: productDetails,
              );
            }

            if (productDetails.id == _kConsumableId) {
              _inAppPurchase.buyConsumable(
                  purchaseParam: purchaseParam, autoConsume: _kAutoConsume);
            } else {
              _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
            }
          },
        );

        if (productDetails.title.toLowerCase().contains("year")) {
          return ClipRRect(
            child: Banner(
              message: 'Best deal',
              color: Color.fromRGBO(255, 152, 0, 1),
              location: BannerLocation.topEnd,
              child: buildContainer2,
            ),
          );
        }

        return buildContainer2;
      },
    ));

    return Column(
      children: productList,
    );
  }

  Widget buildContainer({
    required String text1,
    required String price,
    required String text2,
    required double height,
    bool isPopular = false,
    required Function()? ontap,
  }) {
    return GestureDetector(
      onTap: () {
        // controller.selectedIndex.value = index;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                width: 1,
                color: isPopular
                    ? const Color.fromRGBO(71, 160, 130, 1)
                    : Color.fromRGBO(242, 242, 242, 1))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text1,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Color.fromRGBO(71, 160, 130, 1),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: price,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                    color: Color.fromRGBO(28, 28, 28, 1),
                  ),
                ),
                TextSpan(
                  text: text2,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color.fromRGBO(81, 81, 81, 1),
                  ),
                ),
              ]),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/image/bolt.svg',
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Unlimited Chats",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Color.fromRGBO(28, 28, 28, 1),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/image/bolt.svg',
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Most Advance GPT-3",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Color.fromRGBO(28, 28, 28, 1),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              // borderRadius: BorderRadius.circular(12),
              onTap: ontap,
              // splashColor: const Color.fromRGBO(71, 160, 130, 1).withOpacity(0.5),
              child: Container(
                height: height,
                // width: getProportionateScreenWidth(270),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color.fromRGBO(71, 160, 130, 1), width: 1),
                  color: isPopular
                      ? const Color.fromRGBO(71, 160, 130, 1)
                      : Colors.transparent,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: !isPopular
                        ? const Color.fromRGBO(71, 160, 130, 1)
                        : Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> consume(String id) async {}

  void showPendingUI() {
    Get.snackbar('Proccessing.', 'Please wait...');
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == _kConsumableId) {
      // await ConsumableStore.save(purchaseDetails.purchaseID!);
      // final List<String> consumables = await ConsumableStore.load();
      setState(() {
        _purchasePending = false;
        // _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  void handleError(IAPError error) {
    Get.snackbar('Error.', 'failed...');
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {}

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                _inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    if (Platform.isAndroid) {
      final InAppPurchaseAndroidPlatformAddition androidAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final BillingResultWrapper priceChangeConfirmationResult =
          await androidAddition.launchPriceChangeConfirmationFlow(
        sku: 'purchaseId',
      );
      if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Price change accepted'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            priceChangeConfirmationResult.debugMessage ??
                'Price change failed with code ${priceChangeConfirmationResult.responseCode}',
          ),
        ));
      }
    }
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  GooglePlayPurchaseDetails? _getOldSubscription(
      ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    GooglePlayPurchaseDetails? oldSubscription;
    if (productDetails.id == _kSilverSubscriptionId &&
        purchases[_kGoldSubscriptionId] != null) {
      oldSubscription =
          purchases[_kGoldSubscriptionId]! as GooglePlayPurchaseDetails;
    } else if (productDetails.id == _kGoldSubscriptionId &&
        purchases[_kSilverSubscriptionId] != null) {
      oldSubscription =
          purchases[_kSilverSubscriptionId]! as GooglePlayPurchaseDetails;
    }
    return oldSubscription;
  }
}

/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
