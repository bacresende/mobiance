import 'package:flutter/material.dart';

class CardLancamento extends StatelessWidget {
  List<Widget> widgets;

  CardLancamento({@required this.widgets});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        top: 10,
        bottom: 40,
      ),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: this.widgets
            ),
          ),
        ),
      ),
    );
  }
}
