import 'package:devsteam_mobi_test/models/Payment.dart';
import 'package:devsteam_mobi_test/widgets/Payment/PaymentsScreen.dart';
import 'package:flutter/material.dart';

class PaidWidget extends StatelessWidget {
  final double total;
  final GlobalKey paymentFormKey;
  final TextEditingController paymentMethod;
  final TextEditingController paymentAmount;
  final TextEditingController invoiceBalanceDue;
  final VoidCallback onSave;
  final List<Payment> paymentsList;

  const PaidWidget({
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
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentsScreen(
              total: total,
              paymentFormKey: paymentFormKey,
              paymentMethod: paymentMethod,
              paymentAmount: paymentAmount,
              onSave: onSave,
              invoiceBalanceDue: invoiceBalanceDue,
              paymentsList: paymentsList,
            ),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Paid',
          ),
          Text(
            paymentAmount.text.isNotEmpty ? paymentAmount.text : '0',
          ),
        ],
      ),
    );
  }
}
