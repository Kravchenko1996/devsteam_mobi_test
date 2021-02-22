import 'package:devsteam_mobi_test/widgets/ClientForm.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ClientWidget extends StatelessWidget {
  final TextEditingController clientName;
  final TextEditingController clientEmail;

  const ClientWidget({
    Key key,
    this.clientName,
    this.clientEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: ClientForm(),
              );
            });
      },
      child: Container(
        child: Row(
          children: [
            Icon(
              MdiIcons.account,
              color: Colors.grey,
              size: 30,
            ),
            Text(
              'Client',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
