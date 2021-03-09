import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DatePickerWidget extends StatefulWidget {
  final Invoice invoice;

  const DatePickerWidget({
    Key key,
    this.invoice,
  }) : super(key: key);

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  @override
  Widget build(BuildContext context) {
    print(context.read<InvoiceView>().date);
    return MaterialButton(
      onPressed: () => _selectDate(context),
      child: Text(
        DateFormat('E, MMM d, y').format(context.read<InvoiceView>().date),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: context.read<InvoiceView>().date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != context.read<InvoiceView>().date) {
      setState(() {
        context.read<InvoiceView>().selectDate(picked);
      });
    }
  }
}
