import 'package:flutter/material.dart';

class ItemForm extends StatelessWidget {
  final GlobalKey itemFormKey;
  final TextEditingController itemTitle;
  final TextEditingController itemPrice;
  final TextEditingController itemQuantity;
  final TextEditingController itemAmount;

  const ItemForm({
    Key key,
    this.itemFormKey,
    this.itemTitle,
    this.itemPrice,
    this.itemQuantity,
    this.itemAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: itemFormKey,
      child: Column(
        children: [
          Container(
            child: TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Item title',
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
          Divider(),
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Text(
                'Unit price',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              prefixIconConstraints: BoxConstraints(minHeight: 10),
              border: InputBorder.none,
              hintText: '0.00',
            ),
            textAlign: TextAlign.end,
            controller: itemPrice,
            keyboardType: TextInputType.number,
            onChanged: (_) => _countAmount(),
            onTap: () => _selectAllText(itemPrice),
          ),
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Text(
                'Quantity',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              prefixIconConstraints: BoxConstraints(minHeight: 10),
              border: InputBorder.none,
              hintText: '0',
            ),
            textAlign: TextAlign.end,
            controller: itemQuantity,
            keyboardType: TextInputType.number,
            onChanged: (_) => _countAmount(),
            onTap: () => _selectAllText(itemQuantity),
          ),
          TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              prefixIcon: Text(
                'Amount',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              prefixIconConstraints: BoxConstraints(minHeight: 10),
              border: InputBorder.none,
              hintText: itemAmount.text.isNotEmpty ? itemAmount.text : '0',
            ),
            textAlign: TextAlign.end,
            controller: itemAmount,
          ),
        ],
      ),
    );
  }

  void _selectAllText(TextEditingController controller) {
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.value.text.length,
    );
  }

  void _countAmount() {
    double price = double.parse(itemPrice.text);
    double quantity = double.parse(itemQuantity.text);
    double amount = (price * quantity);
    itemAmount.text = amount.toString();
  }
}
