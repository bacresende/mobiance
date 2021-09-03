import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {

  static void rawSnackBar({ @required String text, @required Color cor, int duration = 2}){
    Get.rawSnackbar(
          messageText: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ),
              SizedBox(width: 15),
              Text(
                text,
                style: TextStyle(color: cor),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          duration: Duration(seconds: duration));
  }
}