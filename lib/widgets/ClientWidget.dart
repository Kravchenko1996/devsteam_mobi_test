import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/widgets/ClientForm.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ClientWidget extends StatefulWidget {
  final TextEditingController clientName;
  final TextEditingController clientEmail;
  final VoidCallback onSave;
  final VoidCallback onRemove;
  final GlobalKey clientFormKey;
  final int clientId;

  const ClientWidget({
    Key key,
    this.clientName,
    this.clientEmail,
    this.onSave,
    this.clientFormKey,
    this.clientId,
    this.onRemove,
  }) : super(key: key);

  @override
  _ClientWidgetState createState() => _ClientWidgetState();
}

class _ClientWidgetState extends State<ClientWidget> {
  Client client;

  @override
  void initState() {
    super.initState();
    _getClientById(widget.clientId);
  }

  void _getClientById(int clientId) async {
    if (widget.clientId != null) {
      client = await DBProvider.db.getClientById(clientId);
      setState(() {
        widget.clientName.text = client.name;
        widget.clientEmail.text = client.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: ClientForm(
                  clientName: widget.clientName,
                  clientEmail: widget.clientEmail,
                  onSave: widget.onSave,
                  onRemove: widget.onRemove,
                  clientFormKey: widget.clientFormKey,
                  client: client,
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
              widget.clientName.text.isEmpty && client == null
                  ? 'Client'
                  : widget.clientName.text,
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
