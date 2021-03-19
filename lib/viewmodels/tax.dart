import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Item.dart';
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
    if (tax.type != 'None') {
      var res = await DBProvider.db.upsertTax(
        tax,
        invoiceId,
      );
      _tax = res;
      updateTaxDifference(invoiceView);
    } else {
      _tax = null;
    }
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
    }
    notifyListeners();
  }

  void getTaxByItemId(
    int itemId, [
    InvoiceView invoiceView,
  ]) async {
    Tax res = await DBProvider.db.getTaxByItemId(itemId);
    if (res != null) {
      _tax = res;
      // updateTaxDifference(invoiceView);
    }
    notifyListeners();
  }

  void updateTaxDifference(InvoiceView invoiceView) async {
    if (invoiceView != null && invoiceView.subTotal != null) {
      List<Item> taxableItems = [];
      invoiceView.itemsOfInvoice.forEach(
        (Item item) {
          if (item.taxable == 1) {
            taxableItems.add(item);
          }
        },
      );
      double taxableItemsAmount = 0;
      taxableItems.forEach(
          (Item item) {
            taxableItemsAmount += item.amount;
          }
      );
      double taxAmount = _tax != null ? _tax.amount : 0;
      if (_included) {
        _taxDifference = taxableItemsAmount -
            (taxableItemsAmount * 100) / (100 + taxAmount);
        invoiceView.countTotal(invoiceView.itemsOfInvoice);
      } else {
        _taxDifference = (taxableItemsAmount * taxAmount) / 100;
        updateTotalWithTax(invoiceView);
      }
    }
  }

  void updateTotalWithTax(InvoiceView invoiceView) async {
    invoiceView.countTotal(invoiceView.itemsOfInvoice);
    invoiceView.setTotal = invoiceView.total + _taxDifference;
  }
}
