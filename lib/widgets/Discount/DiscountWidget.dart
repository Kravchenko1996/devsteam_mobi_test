import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:devsteam_mobi_test/widgets/Discount/DiscountForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscountWidget extends StatelessWidget {
  final GlobalKey discountFormKey;
  final TextEditingController invoiceDiscount;
  final TextEditingController invoiceDifference;

  // final VoidCallback onSave;
  final double discount;
  // final Invoice invoice;
  final double difference;
  final double subTotal;

  const DiscountWidget({
    Key key,
    this.discountFormKey,
    this.invoiceDiscount,
    this.invoiceDifference,
    // this.onSave,
    this.discount,
    // this.invoice,
    this.difference,
    this.subTotal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext invoiceContext,
        InvoiceView invoiceView,
        Widget child,
      ) {
        double discount = invoiceView.discount ?? 0;
        return MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                context: context,
                builder: (BuildContext context) {
                  return DiscountForm(
                    discountFormKey: discountFormKey,
                    invoiceDiscount: invoiceDiscount,
                    invoiceDifference: invoiceDifference,
                    // onSave: onSave,
                    subTotal: subTotal,
                  );
                });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // 'Discount (${discount.toStringAsFixed(2)}%)',
                'Discount ($discount%)',
              ),
              Text(
                // difference.toStringAsFixed(2),
                invoiceView.difference.toStringAsFixed(2),
                // (subTotal == 0
                //         ? (invoiceView.subTotal * discount) /
                //             100
                //         : (subTotal * discount) / 100)
                //     .toString(),
              ),
            ],
          ),
        );
      },
    );
  }
}
