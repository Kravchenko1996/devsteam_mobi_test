import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/widgets/Client/ClientForm.dart';
import 'package:devsteam_mobi_test/widgets/Client/ContactsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

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
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () async {
        // showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return AlertDialog(
        //         content: ClientForm(
        //           clientFormKey: widget.clientFormKey,
        //           clientName: widget.clientName,
        //           clientEmail: widget.clientEmail,
        //           onSave: widget.onSave,
        //           onRemove: widget.onRemove,
        //           onChoose: widget.onChoose,
        //         ),
        //       );
        //     });
        final PermissionStatus permissionStatus = await _getPermission();
        if (permissionStatus == PermissionStatus.granted) {
          if (widget.clientName.text.isEmpty) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactsScreen(
                  onChoose: widget.onChoose,
                ),
              ),
            );
          } else {
            showModalBottomSheet(
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                context: context,
                builder: (BuildContext context) {
                  return ClientForm(
                    clientFormKey: widget.clientFormKey,
                    clientName: widget.clientName,
                    clientEmail: widget.clientEmail,
                    onSave: widget.onSave,
                    onRemove: widget.onRemove,
                    onChoose: widget.onChoose,
                  );
                });
          }
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text('Permissions error'),
              content: Text(
                'Please enable contacts access '
                'permission in system settings',
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        }
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
              widget.clientName.text.isEmpty
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

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }
}
