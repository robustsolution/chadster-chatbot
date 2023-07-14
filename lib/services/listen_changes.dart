// Package imports:
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class ChangesListener extends GetxService {
  Rx<User?> _firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);
  // Rx<User> _firebaseUpdates = Rx<User>();

  int _aiQueries = 0;
  Rx<DateTime> _subcriptionDate = Rx(DateTime(2000));

  var _subscriptions = <StreamSubscription>[];

  static ChangesListener to = Get.find();

  bool justLoggedIn = false;

  Rx<bool> subscriptionInitiated = false.obs;

  User? get user => _firebaseUser.value;
  int get aiQueries => _aiQueries;
  Rx<DateTime> get subcriptionDate => _subcriptionDate;

  bool isSubscribed() {
    return _subcriptionDate.value.isAfter(DateTime.now());
  }

  @override
  void onClose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    super.onClose();
  }

  @override
  void onInit() {
    _badge();

    _firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        _subcriptionDate.value = DateTime(2000);

        for (final sub in _subscriptions) {
          sub.cancel();
        }
      } else {
        print("userid " + user.uid);

        // _subcriptionDate.value = (response['subscription'] as Timestamp).toDate();

        final _subscription = FirebaseFirestore.instance
            .collection('purchases')
            .where("userId", isEqualTo: user.uid)
            .where("status", isEqualTo: "ACTIVE")
            .orderBy("expiryDate", descending: true)
            .snapshots()
            .listen(
          (res) {
            subscriptionInitiated.value = true;

            if (res.size != 0) {
              final dosRes = res.docs.first;
              _subcriptionDate.value =
                  (dosRes['expiryDate'] as Timestamp).toDate();
            }
          },
        )..onError((e) {
            print('error ' + e.toString());
          });

        final _subscription2 = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .listen(
          (res) {
            if (res.exists) {
              var response = res.data() as Map<String, dynamic>;
              if (response.containsKey("ai_queries")) {
                _aiQueries = response['ai_queries'] ?? 0;
              }
            }
          },
        )..onError((e) {
            print('error ' + e.toString());
          });

        _subscriptions.add(_subscription);
        _subscriptions.add(_subscription2);
      }
    });

    // _firebaseUpdates.bindStream(FirebaseAuth.instance.userChanges());
    super.onInit();
  }

  Future<void> _badge() async {
    final support = await FlutterAppBadger.isAppBadgeSupported();

    if (support) {
      FlutterAppBadger.removeBadge();
    }
  }
}
