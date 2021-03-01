import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/widgets/Discount/DiscountForm.dart';
import 'package:flutter/material.dart';

class DiscountWidget extends StatelessWidget {
  final GlobalKey discountFormKey;
  final TextEditingController invoiceDiscount;
  final VoidCallback onSave;
  final double discount;
  final Invoice invoice;
  final double difference;

  const DiscountWidget({
    Key key,
    this.discountFormKey,
    this.invoiceDiscount,
    this.onSave,
    this.discount,
    this.invoice,
    this.difference,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: DiscountForm(
                  discountFormKey: discountFormKey,
                  invoiceDiscount: invoiceDiscount,
                  onSave: onSave,
                ),
              );
            });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Discount ($discount%)',
          ),
          Text(
            difference.toStringAsFixed(2),
          ),
        ],
      ),
    );
  }
}
