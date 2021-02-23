import 'package:devsteam_mobi_test/widgets/ClientForm.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ClientWidget extends StatelessWidget {
  final TextEditingController clientName;
  final TextEditingController clientEmail;
  final VoidCallback onSave;

  const ClientWidget({
    Key key,
    this.clientName,
    this.clientEmail,
    this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: ClientForm(
                  clientName: clientName,
                  clientEmail: clientEmail,
                  onSave: onSave,
                ),
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
              clientName.text.isEmpty ? 'Client' : clientName.text,
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
