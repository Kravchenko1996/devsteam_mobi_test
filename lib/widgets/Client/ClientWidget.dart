import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/widgets/Client/ClientForm.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ClientWidget extends StatefulWidget {
  final GlobalKey clientFormKey;
  final TextEditingController clientName;
  final TextEditingController clientEmail;
  final VoidCallback onSave;
  final VoidCallback onRemove;
  final int clientId;
  final void Function(Client) onChoose;

  const ClientWidget({
    Key key,
    this.clientFormKey,
    this.clientName,
    this.clientEmail,
    this.onSave,
    this.clientId,
    this.onRemove,
    this.onChoose,
  }) : super(key: key);

  @override
  _ClientWidgetState createState() => _ClientWidgetState();
}

class _ClientWidgetState extends State<ClientWidget> {
  Client _client;

  @override
  void initState() {
    super.initState();
    _getClientById(widget.clientId);
  }

  void _getClientById(int clientId) async {
    if (widget.clientId != null) {
      _client = await DBProvider.db.getClientById(clientId);
      setState(() {
        widget.clientName.text = _client.name;
        widget.clientEmail.text = _client.email;
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
                  client: _client,
                  onChoose: widget.onChoose,
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
              widget.clientName.text.isEmpty && _client == null
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
