import 'package:flutter/material.dart';

class TaxWidget extends StatefulWidget {
  @override
  _TaxWidgetState createState() => _TaxWidgetState();
}

class _TaxWidgetState extends State<TaxWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          context: context,
          builder: (BuildContext context) {
            return null;
          },
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Tax'),
        ],
      ),
    );
  }
}
