import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ClientForm extends StatelessWidget {
  final TextEditingController clientName;
  final TextEditingController clientEmail;

  const ClientForm({
    Key key,
    this.clientName,
    this.clientEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: FormBuilderTextField(
            autofocus: true,
            name: 'clientName',
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter client name',
            ),
            controller: clientName,
          ),
        ),
        Container(
          child: FormBuilderTextField(
            autofocus: true,
            name: 'clientEmail',
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter client email',
            ),
            controller: clientEmail,
          ),
        ),
        RaisedButton(
            child: Text('Save'),
            onPressed: () async {
              // await DBProvider.db.newInvoice(newInvoice)
            }),
      ],
    );
  }
}
