// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

// import 'package:aichatapp/app/constants/app_constant.dart';
// import 'package:aichatapp/app/constants/color_constant.dart';
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
import 'package:aichatapp/app/routes/app_pages.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../services/listen_changes.dart';

// Auto-consume must be true on iOS.
// To try without auto-consume on another platform, change `true` to `false` here.
final bool _kAutoConsume = Platform.isIOS || true;

const String _kConsumableId = 'consumable';
// const String _kUpgradeId = 'upgrade';
const String _kSilverSubscriptionId = 'ai.chadster.mobile.3daytrial1year';
const String _kGoldSubscriptionId = 'non';

const List<String> _kProductIds = [_kSilverSubscriptionId];

class TrailView extends StatefulWidget {
  const TrailView({super.key});

  @override
  State<TrailView> createState() => _TrailViewState();
}

class _TrailViewState extends State<TrailView> {
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

  bool routed = false;

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
    // bool isSkipable = false;
    print(FirebaseAuth.instance.currentUser?.uid);

    final List<Widget> stack = <Widget>[];
    if (_queryProductError == null) {
      stack.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () async {
                          final SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          var _count = pref.getBool('isFirst') ?? true;

                          if (_count) {
                            Get.offAndToNamed(Routes.AI_CREDIT);
                            pref.setBool('isFirst', false);
                          } else {
                            Get.offAndToNamed(Routes.MAIN_DASHBOARD);
                          }
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ),
                  Text(
                    'Try Chadster Free',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 152, 0, 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Limited Offer',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Color.fromRGBO(28, 28, 28, 1)),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  _buildRow('Unlimited Searches'),
                  _buildRow('Access to all categories and tasks'),
                  _buildRow('Access to all AI Engines'),
                  _buildRow('in-depth answers'),
                  _buildRow('Quicker response'),
                ],
              ),
            ),
            // const Spacer(),
            SizedBox(
              height: 20.h,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 50.h, left: 20.w, right: 20.w),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Text(
                      'Try 3 Days for Free',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24.sp,
                          color: Color.fromRGBO(28, 28, 28, 1)),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(
                      'Then \$ 59.99/year',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 20.sp,
                          color: Color.fromRGBO(28, 28, 28, 1)),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    _buildProductList(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.WEBVIEW, arguments: {
                              'title': 'Terms & conditions',
                              'url': 'https://www.trendicator.io//legal/tos/',
                            });
                          },
                          child: const Text(
                            "Terms & Conditions",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color.fromRGBO(71, 160, 130, 1),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.WEBVIEW, arguments: {
                              'title': 'Privacy Policy',
                              'url':
                                  'https://www.trendicator.io/legal/privacy/',
                            });
                          },
                          child: const Text(
                            "Privacy",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color.fromRGBO(71, 160, 130, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 20.h),
                      child: Text(
                        'No obligation to continue, just cancel before Trial Ends',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16.sp,
                          color: Color.fromRGBO(28, 28, 28, 1),
                        ),
                      ),
                    ),
                  ],
                ),
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
      backgroundColor: const Color.fromRGBO(71, 160, 130, 1),
      body: Obx(() {
        var listener = ChangesListener.to;
        final isSub = listener.isSubscribed();

        final isInit = listener.subscriptionInitiated.value;

        if (!isInit) {
          return Center(
            child: ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Please wait...'),
            ),
          );
        }
        if (isSub && isInit) {
          Future.delayed(
            Duration.zero,
            () {
              if (!routed) {
                Get.toNamed(Routes.MAIN_DASHBOARD);
              }
              routed = true;
            },
          );

          return Center(
            child: ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Redirecting...'),
            ),
          );
        }

        return Stack(
          children: stack,
        );
      }),
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

    productList.addAll(_sortedProducts.map(
      (ProductDetails productDetails) {
        final buildContainer2 = InkWell(
          onTap: () {
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
          child: Container(
            height: 40.h,
            // width: getProportionateScreenWidth(270),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color.fromRGBO(28, 28, 28, 1),
            ),
            alignment: Alignment.center,
            child: const Text(
              "Continue",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        );

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
            await deliverProduct(purchaseDetails);
            Get.toNamed(Routes.MAIN_DASHBOARD);
            _subscription.cancel();
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

Widget _buildRow(String text) {
  return Padding(
    padding: EdgeInsets.only(bottom: 16.0.h),
    child: Row(
      children: [
        Icon(
          Icons.check_circle_outline,
          color: Colors.white,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Colors.white,
          ),
        )
      ],
    ),
  );
}
