import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../drawer_controller.dart';

class LeadingDrawer extends StatelessWidget {

  final CustomDrawerController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return IconButton(
        icon: Icon(
          Icons.short_text,
          size: 30,
        ),
        onPressed: () => _controller.openDrawer(context),
        tooltip: _controller.toolipDrawer(context),
      );
    });
  }
}
