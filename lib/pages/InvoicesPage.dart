import 'package:devsteam_mobi_test/widgets/FABWidget.dart';
import 'package:devsteam_mobi_test/widgets/NewInvoiceScreen.dart';
import 'package:flutter/material.dart';

class InvoicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FABWidget(
        label: 'Create invoice',
        route: NewInvoiceScreen(),
      ),
      body: Container(
        child: Center(
          child: Text(
            'Invoices',
          ),
        ),
      ),
    );
  }
}
