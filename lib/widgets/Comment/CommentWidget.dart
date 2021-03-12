import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CommentWidget extends StatelessWidget {
  final GlobalKey commentFormKey;
  final TextEditingController comment;

  const CommentWidget({
    Key key,
    this.commentFormKey,
    this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      child: Form(
        key: commentFormKey,
        child: TextFormField(
          autofocus: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Add notes',
            prefixIcon: Icon(
                MdiIcons.text
            ),
          ),
          controller: comment,
        ),
      ),
    );
  }
}
