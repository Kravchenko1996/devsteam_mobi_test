import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:flutter/material.dart';

class InvoiceNameWidget extends StatelessWidget {
  final Invoice invoice;
  final TextEditingController invoiceName;

  const InvoiceNameWidget({
    Key key,
    this.invoice,
    this.invoiceName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return invoice == null
        ? TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter invoice name',
            ),
            autofocus: false,
            controller: invoiceName,
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
            // ToDo rework invoiceName
            // if 'widget.invoice == null' would be here
            // it will conflict with ..text-method
            controller: invoiceName..text = invoice.name,
            validator: (val) {
              if (val.isEmpty) {
                return 'Enter something please!';
              }
              return null;
            },
          );
  }
}
