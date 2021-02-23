import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/widgets/ClientWidget.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NewInvoiceScreen extends StatefulWidget {
  @override
  _NewInvoiceScreenState createState() => _NewInvoiceScreenState();
}

class _NewInvoiceScreenState extends State<NewInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _invoiceNameController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientEmailController = TextEditingController();
  Client newClient = Client();
  Invoice newInvoice = Invoice();

  void _saveClient() async {
    newClient = Client(
      name: _clientNameController.text,
      email: _clientEmailController.text,
    );
    await DBProvider.db.upsertClient(newClient);
    await DBProvider.db.getAllClients();
    setState(() {
      Navigator.of(context).pop();
    });
    // if (_formKey.currentState.validate()) {
    //   print(1);
    //   newClient = Client(
    //     name: _clientNameController.text,
    //     email: _clientEmailController.text,
    //   );
    //   await DBProvider.db.upsertClient(newClient);
    //   await DBProvider.db.getAllClients();
    //   setState(() {
    //     Navigator.of(context).pop();
    //   });
    // }
  }

  void _saveInvoice() async {
    if (_formKey.currentState.validate()) {
      newInvoice = Invoice(
        name: _invoiceNameController.text,
        clientId: newClient.id,
      );
      await DBProvider.db.upsertInvoice(newInvoice);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(MdiIcons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: TextFormField(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
