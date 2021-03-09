import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:devsteam_mobi_test/widgets/Discount/DiscountForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscountWidget extends StatefulWidget {
  @override
  _DiscountWidgetState createState() => _DiscountWidgetState();
}

class _DiscountWidgetState extends State<DiscountWidget> {
  final _discountFormKey = GlobalKey<FormState>();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _differenceController = TextEditingController();
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
            _discountController.text = invoiceView.discount != null
                ? invoiceView.discount.toString()
                : '0';
            _discountController.text = invoiceView.difference != null
                ? invoiceView.difference.toString()
                : '0';
            showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              context: context,
              builder: (BuildContext context) {
                return DiscountForm(
                  discountFormKey: _discountFormKey,
                  invoiceDiscount: _discountController,
                  invoiceDifference: _differenceController,
                );
              },
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discount ($discount%)',
              ),
              Text(
                invoiceView.difference.toStringAsFixed(2),
              ),
            ],
          ),
        );
      },
    );
  }
}
