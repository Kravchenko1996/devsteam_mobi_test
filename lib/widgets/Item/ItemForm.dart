import 'package:flutter/material.dart';

class ItemForm extends StatefulWidget {
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
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.itemFormKey,
      child: Column(
        children: [
          Container(
            child: TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Item title',
              ),
              controller: widget.itemTitle,
              validator: (val) {
                if (val.isEmpty) {
                  return 'Enter something please!';
                }
                return null;
              },
            ),
          ),
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
            controller: widget.itemPrice,
            keyboardType: TextInputType.number,
            onChanged: (_) => _countAmount(),
            onTap: () => _selectAllText(widget.itemPrice),
          ),
          TextFormField(
            autofocus: true,
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
            controller: widget.itemQuantity,
            keyboardType: TextInputType.number,
            onChanged: (_) => _countAmount(),
            onTap: () => _selectAllText(widget.itemQuantity),
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
              hintText:
                  '${widget.itemAmount.text.isNotEmpty ? widget.itemAmount.text : '0'}',
            ),
            textAlign: TextAlign.end,
            controller: widget.itemAmount,
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
    double price = double.parse(widget.itemPrice.text);
    double quantity = double.parse(widget.itemQuantity.text);
    double amount = (price * quantity);
    widget.itemAmount.text = amount.toString();
  }
}
