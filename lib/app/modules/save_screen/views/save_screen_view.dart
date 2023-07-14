import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/save_screen_controller.dart';

class SaveScreenView extends GetView<SaveScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Save Screen View is coming soon',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
