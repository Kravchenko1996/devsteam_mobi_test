import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/tax.dart';
import 'package:devsteam_mobi_test/widgets/RowWidget.dart';
import 'package:devsteam_mobi_test/widgets/Tax/TaxForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaxWidget extends StatefulWidget {
  final Invoice invoice;

  const TaxWidget({
    Key key,
    this.invoice,
  }) : super(key: key);

  @override
  _TaxWidgetState createState() => _TaxWidgetState();
}

class _TaxWidgetState extends State<TaxWidget> {
  final GlobalKey<FormState> _taxFormKey = GlobalKey<FormState>();
  final TextEditingController _taxNameController = TextEditingController();
  final TextEditingController _taxTypeController = TextEditingController();
  final TextEditingController _taxAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (
      BuildContext taxContext,
      TaxView taxView,
      Widget child,
    ) {
      return MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          _taxNameController.text =
              taxView.tax != null ? taxView.tax.name : null;
          _taxTypeController.text =
              taxView.tax != null ? taxView.tax.type : null;
          _taxAmountController.text =
              taxView.tax != null ? taxView.tax.amount.toString() : null;
          showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            context: context,
            builder: (BuildContext context) {
              return TaxForm(
                taxFormKey: _taxFormKey,
                taxName: _taxNameController,
                taxType: _taxTypeController,
                taxAmount: _taxAmountController,
                invoice: widget.invoice,
              );
            },
          );
        },
        child: buildRow(
          taxView.tax != null ? 'Tax (${taxView.tax.amount}%)' : '0',
          taxView.tax != null ? taxView.taxDifference.toStringAsFixed(2) : '0',
        ),
      );
    });
  }
}
