import 'package:flutter/material.dart';

class FormHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSave;

  const FormHeader({
    Key key,
    this.title,
    this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        RaisedButton(
          child: Text('Save'),
          onPressed: () {
            onSave();
          },
        ),
      ],
    );
  }
}
