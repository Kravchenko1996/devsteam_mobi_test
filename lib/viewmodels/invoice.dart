import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/models/Item.dart';
import 'package:flutter/material.dart';

class InvoiceView with ChangeNotifier {
  Invoice _invoice;

  Invoice get invoice => _invoice;
  List<Invoice> _invoices;

  List<Invoice> get invoices => _invoices;

  double _subTotal = 0;
  double get subTotal => _subTotal;
  set setSubTotal(double value) {
    _subTotal = value;
  }

  double _discount;
  double get discount => _discount;
  set setDiscount(double value) {
    _discount = value;
  }

  double _difference = 0;
  double get difference => _difference;
  set setDifference(double value) {
    _difference = value;
  }
  Future<Invoice> saveInvoice(
    Invoice invoice,
    int clientId,
  ) async {
    Invoice res = await DBProvider.db.upsertInvoice(
      invoice,
      clientId,
      null,
      null,
      null,
    );
    getAllInvoices();
    return res;
  }

  void countSubtotal(List<Item> itemsOfInvoice) {
    print(itemsOfInvoice);
    if (itemsOfInvoice != null) {
      itemsOfInvoice.forEach((Item element) {
        _subTotal += element.amount;
      });
      updateDifference();
      notifyListeners();
    }
  }

  Future<void> getAllInvoices() async {
    final response = await DBProvider.db.getAllInvoices();
    _invoices = response;
    notifyListeners();
  }

  void saveDiscount(double discount) {
    _discount = discount;
    updateDifference();
    notifyListeners();
  }

  void updateDifference() {
    _difference = (_subTotal * _discount) / 100;
    print('----');
    print(_subTotal);
    print(_discount);
    print(_difference);
    notifyListeners();
  }
}
