import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/modulos/home/home_controller.dart';

class BackCard extends StatelessWidget {
  BackCard({
    Key key,
    @required this.index,
  }) : super(key: key);
  final HomeController controller = Get.find();
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: !controller.isFirst
                          ? () {
                              //controller.indexGlobal++;
                            }
                          : null,
                    ),
                    InkWell(
                      onTap: () {
                        print('teste');
                      },
                      child: Text(
                        '',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: !controller.isLast
                          ? () {
                              //controller.indexGlobal--;
                            }
                          : null,
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '',
                    style: TextStyle(fontSize: 32),
                  )
                ],
              )),
            ],
          ),
        ),
      ],
    );
  }
}
