import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscountForm extends StatelessWidget {
  final GlobalKey<FormState> discountFormKey;
  final TextEditingController invoiceDiscount;
  final TextEditingController invoiceDifference;

  const DiscountForm({
    Key key,
    this.discountFormKey,
    this.invoiceDiscount,
    this.invoiceDifference,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext invoiceContext,
        InvoiceView invoiceView,
        Widget child,
      ) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 15,
                top: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 15,
              ),
              child: Form(
                key: discountFormKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Discount'),
                        RaisedButton(
                          child: Text('Save'),
                          onPressed: () {
                            context.read<InvoiceView>().saveDiscount(
                                  double.parse(
                                    invoiceDiscount.text,
                                  ),
                                );
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Text(
                          'Percentage',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        prefixIconConstraints: BoxConstraints(minHeight: 10),
                        border: InputBorder.none,
                        hintText: '0.00',
                        suffix: Text('%'),
                      ),
                      textAlign: TextAlign.end,
                      controller: invoiceDiscount,
                      keyboardType: TextInputType.number,
                      onTap: () => _selectAllText(invoiceDiscount),
                      onChanged: (_) => {
                        invoiceDifference.text = (invoiceView.subTotal *
                                double.parse(invoiceDiscount.text) /
                                100)
                            .toString()
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Text(
                          'Fixed amount',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        prefixIconConstraints: BoxConstraints(minHeight: 10),
                        border: InputBorder.none,
                        hintText: '0.00',
                      ),
                      textAlign: TextAlign.end,
                      controller: invoiceDifference,
                      keyboardType: TextInputType.number,
                      onTap: () => _selectAllText(invoiceDifference),
                      onChanged: (_) => {
                        invoiceDiscount.text =
                            (double.parse(invoiceDifference.text) *
                                    100 /
                                    invoiceView.subTotal)
                                .toString()
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _selectAllText(TextEditingController controller) {
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.value.text.length,
    );
  }
}
