import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/widgets/ClientWidget.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NewInvoiceScreen extends StatefulWidget {
  final int clientId;
  final Invoice invoice;

  const NewInvoiceScreen({
    Key key,
    this.clientId,
    this.invoice,
  }) : super(key: key);

  @override
  _NewInvoiceScreenState createState() => _NewInvoiceScreenState();
}

class _NewInvoiceScreenState extends State<NewInvoiceScreen> {
  final _invoiceFormKey = GlobalKey<FormState>();
  final _clientFormKey = GlobalKey<FormState>();

  final TextEditingController _invoiceNameController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientEmailController = TextEditingController();
  Client newClient = Client();
  Invoice newInvoice = Invoice();

  void _saveClient() async {
    if (_clientFormKey.currentState.validate()) {
      newClient = Client(
        name: _clientNameController.text,
        email: _clientEmailController.text,
      );
      await DBProvider.db.upsertClient(newClient, widget.clientId);
      await DBProvider.db.getAllClients();
      setState(() {
        Navigator.of(context).pop();
      });
    }
  }

  void _saveInvoice() async {
    if (_invoiceFormKey.currentState.validate()) {
      newInvoice = Invoice(
        name: _invoiceNameController.text,
        clientId: widget.clientId != null ? widget.clientId : newClient.id,
      );
      await DBProvider.db.upsertInvoice(newInvoice, widget.invoice);
    }
  }

  void _removeClientFromInvoice() async {
    // if (_invoiceFormKey.currentState.validate()) {
    //   newInvoice = Invoice(
    //     name: _invoiceNameController.text,
    //     clientId: null,
    //   );
    //   print(newInvoice.name);
    //   await DBProvider.db.removeClientFromInvoice(newInvoice, widget.invoice);
    //   Navigator.of(context).pop();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(MdiIcons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Form(
          key: _invoiceFormKey,
          child: widget.invoice == null
              ? TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter invoice name',
                  ),
                  controller: _invoiceNameController,
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Enter something please!';
                    }
                    return null;
                  },
                )
              : TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter invoice name',
                  ),
                  // if 'widget.invoice == null' would be here
                  // it will conflict with ..text-method
                  controller: _invoiceNameController
                    ..text = widget.invoice.name,
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Enter something please!';
                    }
                    return null;
                  },
                ),
        ),
        actions: [
          MaterialButton(
            onPressed: () async {
              _saveInvoice();
            },
            child: Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClientWidget(
              clientName: _clientNameController,
              clientEmail: _clientEmailController,
              onSave: _saveClient,
              onRemove: _removeClientFromInvoice,
              clientFormKey: _clientFormKey,
              clientId: widget.clientId,
            ),
          ],
        ),
      ),
    );
  }
}
