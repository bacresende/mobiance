import 'package:flutter/material.dart';

class ElegantDropdown extends StatelessWidget {
  final Color cor;
  final dynamic value;
  final String hint;
  final List<DropdownMenuItem<String>> items;
  final void Function(String) onChanged;

  ElegantDropdown(
      {@required this.cor,
      @required this.value,
      @required this.hint,
      @required this.items,
      @required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: Colors.grey, style: BorderStyle.solid, width: 0.80),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              style: TextStyle(color: Colors.black, fontSize: 18),
              iconEnabledColor: this.cor,
              value: this.value,
              hint: Text(
                this.hint,
                style: TextStyle(color: this.cor, fontSize: 18),
              ),
              items: this.items,
              onChanged: this.onChanged,
            ),
          ),
        ));
  }
}
