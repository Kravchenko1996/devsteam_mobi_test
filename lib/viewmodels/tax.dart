import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Tax.dart';
import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:flutter/material.dart';

class TaxView with ChangeNotifier {
  Tax _tax;

  Tax get tax => _tax;

  set setTax(Tax value) {
    _tax = value;
  }

  List<String> taxTypes = [
    'On total',
    'Per item',
    'None',
  ];

  List<Tax> _taxesOfInvoice = [];

  List<Tax> get taxesOfInvoice => _taxesOfInvoice;

  set setTaxesOfInvoice(List<Tax> value) => _taxesOfInvoice = value;

  double _taxDifference = 0;

  double get taxDifference => _taxDifference;

  set setTaxDifference(double value) => _taxDifference = value;

  bool _included = false;

  bool get included => _included;

  set setIncluded(bool value) => _included = value;

  void saveTax(
    Tax tax,
    int invoiceId, [
    InvoiceView invoiceView,
  ]) async {
    var res = await DBProvider.db.upsertTax(
      tax,
      invoiceId,
    );
    _tax = res;
    updateTaxDifference(invoiceView);
    notifyListeners();
  }

  void getTaxByInvoiceId(
    int invoiceId,
    InvoiceView invoiceView,
  ) async {
    Tax res = await DBProvider.db.getTaxByInvoiceId(invoiceId);
    if (res != null) {
      _tax = res;
      updateTaxDifference(invoiceView);
      notifyListeners();
    }
  }

  void updateTaxDifference(InvoiceView invoiceView) async {
    print(invoiceView.subTotal);
    print(_tax.amount);
    if (_included) {
      _taxDifference = invoiceView.subTotal -
          (invoiceView.subTotal * 100) / (100 + _tax.amount ?? 0);
    } else {
      _taxDifference = (invoiceView.subTotal * _tax.amount ?? 0) / 100;
    }
  }
}
