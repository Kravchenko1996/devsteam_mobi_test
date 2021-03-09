import 'package:devsteam_mobi_test/viewmodels/payment.dart';
import 'package:devsteam_mobi_test/widgets/Payment/PaymentsScreen.dart';
import 'package:devsteam_mobi_test/widgets/RowWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaidWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext paymentContext,
        PaymentView paymentView,
        Widget child,
      ) {
        return MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentsScreen(),
              ),
            );
          },
          child: buildRow(
            'Paid',
            paymentView.paymentsSum.toString(),
          ),
        );
      },
    );
  }
}
