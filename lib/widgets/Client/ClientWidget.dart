import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/client.dart';
import 'package:devsteam_mobi_test/widgets/Client/ClientForm.dart';
import 'package:devsteam_mobi_test/widgets/Client/ContactsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ClientWidget extends StatefulWidget {
  final Invoice invoice;

  const ClientWidget({
    Key key,
    this.invoice,
  }) : super(key: key);

  @override
  _ClientWidgetState createState() => _ClientWidgetState();
}

class _ClientWidgetState extends State<ClientWidget> {
  final _clientFormKey = GlobalKey<FormState>();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientEmailController = TextEditingController();

  String _getClientById() {
    if (widget.invoice != null && widget.invoice.clientId != null) {
      context.read<ClientView>().getClientById(widget.invoice.clientId);
      return context.read<ClientView>().getClient != null
          ? context.read<ClientView>().getClient.name
          : '';
    }
    return null;
  }

  void initState() {
    super.initState();
    _initForm();
  }

  void _initForm() {
    if (context.read<ClientView>().getClient != null) {
      _clientNameController.text = context.read<ClientView>().getClient.name;
      _clientEmailController.text = context.read<ClientView>().getClient.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientView>(
      builder: (
        BuildContext clientContext,
        ClientView clientView,
        Widget child,
      ) {
        return MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            final PermissionStatus permissionStatus = await _getPermission();
            if (permissionStatus == PermissionStatus.granted) {
              if (_clientNameController.text.isEmpty &&
                  _getClientById() == null) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactsScreen(
                      clientName: _clientNameController,
                      clientEmail: _clientEmailController,
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
                        clientFormKey: _clientFormKey,
                        clientName: _clientNameController,
                        clientEmail: _clientEmailController,
                        invoice: widget.invoice,
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
                  _clientNameController.text.isEmpty
                      ? 'Client'
                      : _clientNameController.text,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
