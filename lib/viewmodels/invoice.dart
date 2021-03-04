import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:flutter/material.dart';

class InvoiceView with ChangeNotifier {

  // List<Invoice> get invoices => _invoices;

  void saveInvoice(
    Invoice invoice,
    int clientId,
  ) async {
    await DBProvider.db.upsertInvoice(
      invoice,
      clientId,
      null,
      null,
      null,
    );
    // getAllInvoices();
  }

// Future<void> getAllInvoices() async {
//   final response = await DBProvider.db.getAllInvoices();
//   _invoices = response;
//   notifyListeners();
// }
}
