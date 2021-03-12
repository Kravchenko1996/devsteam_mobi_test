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

  set setSubTotal(double value) => _subTotal = value;

  double _discount;

  double get discount => _discount;

  set setDiscount(double value) => _discount = value;

  double _difference = 0;

  double get difference => _difference;

  set setDifference(double value) => _difference = value;

  List<Item> _itemsOfInvoice = [];

  List<Item> get itemsOfInvoice => _itemsOfInvoice;

  set setItemsOfInvoice(List<Item> value) => _itemsOfInvoice = value;

  double _total = 0;

  double get total => _total;

  set setTotal(double value) => _total = value;

  DateTime _date = DateTime.now();

  DateTime get date => _date;

  set setDate(DateTime value) => _date = value;

  List<String> dueOptions = [
    'Due on receipt',
    'Due next day',
    'Due in 7 days',
    'Due in 30 days',
    'Custom date',
  ];

  String _dueOption;

  String get dueOption => _dueOption;

  set setDueOption(String value) => _dueOption = value;

  String _dueDate;

  String get dueDate => _dueDate;

  set setDueDate(String value) => _dueDate = value;

  String _signature;

  String get signature => _signature;

  set setSignature(String value) => _signature = value;

  void setSignatureImage(String value) {
    _signature = value;
    notifyListeners();
  }

  Future<Invoice> saveInvoice(
    Invoice invoice,
    int clientId,
    double discount,
    double total,
    int date,
    String dueDate,
    String dueOption,
    String signature,
    String comment,
  ) async {
    Invoice res = await DBProvider.db.upsertInvoice(
      invoice,
      clientId,
      discount,
      total,
      date,
      dueDate,
      dueOption,
      signature,
      comment,
    );
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
    _date = DateTime.fromMillisecondsSinceEpoch(res.date);
    _dueDate = res.dueDate;
    _dueOption = res.dueOption;
    _signature = res.signature;
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

  void selectDueOption(
    String selectedDueOption,
    BuildContext context,
  ) async {
    DateTime today = DateTime.now();
    DateTime _tmpDate;
    if (selectedDueOption == 'Due on receipt') {
      _dueDate = 'Due on receipt';
    } else if (selectedDueOption == 'Due next day') {
      _tmpDate = today.add(
        Duration(days: 1),
      );
    } else if (selectedDueOption == 'Due in 7 days') {
      _tmpDate = today.add(
        Duration(days: 7),
      );
    } else if (selectedDueOption == 'Due in 30 days') {
      _tmpDate = today.add(
        Duration(days: 30),
      );
    }
    if (_tmpDate != null) {
      _dueDate = _tmpDate.toIso8601String();
    }
    _dueOption = selectedDueOption;
    notifyListeners();
  }

  void setDueDateByDatePicker(DateTime pickedDate) {
    _dueDate = pickedDate.toIso8601String();
    notifyListeners();
  }
}
