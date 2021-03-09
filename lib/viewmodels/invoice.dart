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

  List<Item> _itemsOfInvoice = [];

  List<Item> get itemsOfInvoice => _itemsOfInvoice;

  set setItemsOfInvoice(List<Item> value) {
    _itemsOfInvoice = value;
  }

  double _total = 0;

  double get total => _total;

  set setTotal(double value) {
    _total = value;
  }

  DateTime _date = DateTime.now();

  DateTime get date => _date;

  set setDate(DateTime value) {
    _date = value;
  }

  Future<Invoice> saveInvoice(
    Invoice invoice,
    int clientId,
    double discount,
    double total,
    int date,
  ) async {
    Invoice res = await DBProvider.db
        .upsertInvoice(invoice, clientId, discount, total, date);
    getAllInvoices();
    _total = total;
    notifyListeners();
    return res;
  }

  Future<void> getAllInvoices() async {
    final response = await DBProvider.db.getAllInvoices();
    _invoices = response;
    notifyListeners();
  }

  void saveDiscount(double discount) {
    _discount = discount;
    updateDifference();
    countTotal(_itemsOfInvoice);
    notifyListeners();
  }

  void getInvoiceById(int invoiceId) async {
    Invoice res = await DBProvider.db.getInvoiceById(invoiceId);
    _discount = res.discount;
    notifyListeners();
  }

  void updateDifference() {
    if (_discount != null) {
      _difference = (_subTotal * _discount ?? 0) / 100;
    } else {
      _difference = 0;
    }
    notifyListeners();
  }

  void countSubtotal(List<Item> itemsOfInvoice) {
    if (itemsOfInvoice != null) {
      // start new count each time the invoice has been opened
      _subTotal = 0;
      itemsOfInvoice.forEach((Item element) {
        _subTotal += element.amount;
      });
      updateDifference();
      notifyListeners();
    }
  }

  void countTotal(List<Item> itemsOfInvoice) {
    if (itemsOfInvoice != null) {
      // start new count each time the invoice has been opened
      _total = 0;
      itemsOfInvoice.forEach((Item element) {
        _total += element.amount;
      });
      _total -= _difference;
      notifyListeners();
    }
  }

  void getAllItemsByInvoiceId(int invoiceId) async {
    List<Item> res = await DBProvider.db.getAllItemsByInvoiceId(invoiceId);
    if (res != null) {
      _itemsOfInvoice = res;
      countSubtotal(_itemsOfInvoice);
      countTotal(_itemsOfInvoice);
    }
    notifyListeners();
  }

  void selectDate(DateTime selectedDate) async {
    _date = selectedDate;
    notifyListeners();
  }
}
