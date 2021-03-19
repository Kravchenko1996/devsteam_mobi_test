import 'package:devsteam_mobi_test/viewmodels/discount.dart';
import 'package:devsteam_mobi_test/viewmodels/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemForm extends StatefulWidget {
  final GlobalKey itemFormKey;
  final TextEditingController itemTitle;
  final TextEditingController itemPrice;
  final TextEditingController itemQuantity;
  final TextEditingController itemAmount;
  final TextEditingController discountPercentage;
  final TextEditingController discountAmount;

  const ItemForm({
    Key key,
    this.itemFormKey,
    this.itemTitle,
    this.itemPrice,
    this.itemQuantity,
    this.itemAmount,
    this.discountPercentage,
    this.discountAmount,
  }) : super(key: key);

  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext itemContext,
        ItemView itemView,
        Widget child,
      ) {
        return Form(
          key: itemView.itemFormKey,
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (_) => itemView.enableBtn(),
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
                controller: widget.itemPrice,
                keyboardType: TextInputType.number,
                onChanged: (_) => _countAmount(context),
                onTap: () => _selectAllText(widget.itemPrice),
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
                controller: widget.itemQuantity,
                keyboardType: TextInputType.number,
                onChanged: (_) => _countAmount(context),
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
                  hintText: widget.itemAmount.text.isNotEmpty ? widget.itemAmount.text : '0',
                ),
                textAlign: TextAlign.end,
                controller: widget.itemAmount,
              ),
            ],
          ),
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

  void _countAmount(BuildContext context) {
    double price = double.parse(widget.itemPrice.text);
    double quantity = double.parse(widget.itemQuantity.text);
    double amount = 0;
    amount = (price * quantity);
    widget.itemAmount.text = amount.toString();
    if (context.read<ItemView>().discountable) {
      if (context.read<DiscountView>().isPercentageLast) {
        widget.discountAmount.text = (double.parse(widget.itemAmount.text) *
                double.parse(widget.discountPercentage.text) /
                100)
            .toStringAsFixed(2);
        widget.itemAmount.text =
            (price * quantity - double.parse(widget.discountAmount.text)).toString();
      } else {
        widget.itemAmount.text =
            ((double.parse(widget.itemPrice.text) * double.parse(widget.itemQuantity.text)) -
                    double.parse(widget.discountAmount.text))
                .toString();
        widget.discountPercentage.text = ((double.parse(widget.discountAmount.text) * 100) /
                (double.parse(widget.itemPrice.text) *
                    double.parse(widget.itemQuantity.text)))
            .toStringAsFixed(2);
      }
      // amount = (price * quantity) - double.parse(discountAmount.text);
    }
  }
}
