import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FABWidget extends StatelessWidget {
  final String label;
  final Widget route;

  const FABWidget({
    Key key,
    this.label,
    this.route
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => route,
          ),
        );
      },
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      icon: Icon(
        MdiIcons.plus,
        color: Colors.white,
      ),
    );
  }
}
