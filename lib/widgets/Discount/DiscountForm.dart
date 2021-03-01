import 'package:flutter/material.dart';

class DiscountForm extends StatelessWidget {
  final GlobalKey discountFormKey;
  final TextEditingController invoiceDiscount;
  final VoidCallback onSave;

  const DiscountForm({
    Key key,
    this.discountFormKey,
    this.invoiceDiscount,
    this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
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
                  onSave();
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Percentage'),
              Container(
                width: 50,
                child: TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                  ),
                  controller: invoiceDiscount,
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Enter something please!';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
