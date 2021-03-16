import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DatePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
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
      context.read<InvoiceView>().selectDate(picked);
    }
  }
}
