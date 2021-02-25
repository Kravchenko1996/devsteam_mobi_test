import 'package:flutter/material.dart';

class ItemForm extends StatelessWidget {
  final GlobalKey itemFormKey;
  final TextEditingController itemTitle;
  final TextEditingController itemPrice;
  final TextEditingController itemQuantity;
  final VoidCallback onSave;

  const ItemForm({
    Key key,
    this.itemFormKey,
    this.itemTitle,
    this.itemPrice,
    this.itemQuantity,
    this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: itemFormKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Item'),
              RaisedButton(
                child: Text('Save'),
                onPressed: () {
                  onSave();
                },
              ),
            ],
          ),
          Container(
            child: TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter item title',
              ),
              controller: itemTitle,
              validator: (val) {
                if (val.isEmpty) {
                  return 'Enter something please!';
                }
                return null;
              },
            ),
          ),
          Container(
            child: TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter item price',
              ),
              controller: itemPrice,
              keyboardType: TextInputType.number,
              validator: (val) {
                if (val.isEmpty) {
                  return 'Enter something please!';
                }
                return null;
              },
            ),
          ),
          Container(
            child: TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter item quantity',
              ),
              controller: itemQuantity,
              keyboardType: TextInputType.number,
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
    );
  }
}
