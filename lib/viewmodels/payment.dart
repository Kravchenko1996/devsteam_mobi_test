import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Payment.dart';
import 'package:flutter/material.dart';

class PaymentView with ChangeNotifier {
  Payment _payment;

  Payment get payment => _payment;

  List<String> paymentMethods = [
    'Bank account',
    'Check',
    'PayPal',
    'Cash',
    'Card',
    'Stripe',
    'Other',
  ];

  List<Payment> _paymentsOfInvoice = [];

  List<Payment> get paymentsOfInvoice => _paymentsOfInvoice;

  set setPaymentsOfInvoice(List<Payment> value) {
    _paymentsOfInvoice = value;
  }

  double _paymentsSum = 0;

  double get paymentsSum => _paymentsSum;

  set setPaymentsSum(double value) {
    _paymentsSum = value;
  }

  double _balanceDue;

  double get balanceDue => _balanceDue;

  set setBalanceDue(double value) {
    _balanceDue = value;
  }

  TextEditingController _paymentMethodController = TextEditingController();
  TextEditingController _paymentAmountController = TextEditingController();
  TextEditingController get paymentMethod => _paymentMethodController;
  TextEditingController get paymentAmount => _paymentAmountController;

  void savePayment(
    Payment payment,
    int invoiceId,
  ) async {
    var res = await DBProvider.db.upsertPayment(
      payment,
      invoiceId,
    );
    _payment = res;
    notifyListeners();
  }

  void deletePayment(int paymentId) async {
    await DBProvider.db.deletePayment(paymentId);
    notifyListeners();
  }

  void getAllPaymentsByInvoiceId(int invoiceId) async {
    List<Payment> res =
        await DBProvider.db.getAllPaymentsByInvoiceId(invoiceId);
    if (res != null) {
      _paymentsOfInvoice = res;
      countPaymentsSum(_paymentsOfInvoice);
    }
    notifyListeners();
  }

  void selectPaymentFromList(Payment selectedPayment) {
    _payment = selectedPayment;
    notifyListeners();
  }

  void countPaymentsSum(List<Payment> paymentsOfInvoice) {
    _paymentsSum = 0;
    if (paymentsOfInvoice.length == 0) {
      _paymentsSum = 0;
    }
    paymentsOfInvoice.forEach((Payment payment) {
      _paymentsSum += payment.amount;
    });
  }

  void countBalanceDue(double total) {
    countPaymentsSum(_paymentsOfInvoice);
    _balanceDue = total - _paymentsSum;
  }
}
