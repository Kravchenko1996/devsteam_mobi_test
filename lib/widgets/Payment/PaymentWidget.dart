import 'package:devsteam_mobi_test/widgets/Payment/PaymentModal.dart';
import 'package:flutter/material.dart';

class PaymentWidget extends StatelessWidget {
  final double total;
  final GlobalKey paymentFormKey;
  final TextEditingController paymentMethod;
  final TextEditingController paymentAmount;
  final VoidCallback onSave;
  final TextEditingController invoiceBalanceDue;

  const PaymentWidget({
    Key key,
    this.total,
    this.paymentFormKey,
    this.paymentMethod,
    this.paymentAmount,
    this.onSave,
    this.invoiceBalanceDue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            context: context,
            builder: (BuildContext context) {
              return PaymentModal(
                paymentFormKey: paymentFormKey,
                paymentMethod: paymentMethod,
                paymentAmount: paymentAmount,
                onSave: onSave,
                total: total,
                createMode: false,
              );
            });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            paymentMethod.text,
          ),
          Text(
            '${paymentAmount.text.isNotEmpty ? total - double.parse(invoiceBalanceDue.text) : '0'}',
          ),
        ],
      ),
    );
  }
}
