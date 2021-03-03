import 'package:devsteam_mobi_test/models/Payment.dart';
import 'package:devsteam_mobi_test/widgets/FABWidget.dart';
import 'package:devsteam_mobi_test/widgets/Payment/PaymentModal.dart';
import 'package:devsteam_mobi_test/widgets/Payment/PaymentWidget.dart';
import 'package:flutter/material.dart';

class PaymentsScreen extends StatelessWidget {
  final double total;
  final GlobalKey paymentFormKey;
  final TextEditingController paymentMethod;
  final TextEditingController paymentAmount;
  final VoidCallback onSave;
  final TextEditingController invoiceBalanceDue;
  final List<Payment> paymentsList;

  const PaymentsScreen({
    Key key,
    this.total,
    this.paymentFormKey,
    this.paymentMethod,
    this.paymentAmount,
    this.onSave,
    this.invoiceBalanceDue,
    this.paymentsList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Payments',
        ),
      ),
      floatingActionButton: FABWidget(
        isModal: true,
        label: 'Add payment',
        route: PaymentModal(
          paymentFormKey: paymentFormKey,
          paymentMethod: paymentMethod,
          paymentAmount: paymentAmount,
          onSave: onSave,
          total: total,
          createMode: true,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Invoice total',
                ),
                Text(
                  '$total',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Balance due',
                ),
                Text(
                  invoiceBalanceDue.text,
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: paymentsList != null ? paymentsList.length : 0,
              itemBuilder: (BuildContext context, int index) {
                return PaymentWidget(
                  paymentFormKey: paymentFormKey,
                  paymentMethod: paymentMethod,
                  paymentAmount: paymentAmount,
                  onSave: onSave,
                  total: total,
                  invoiceBalanceDue: invoiceBalanceDue,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
