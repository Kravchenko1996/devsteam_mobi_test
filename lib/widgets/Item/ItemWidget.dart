import 'package:devsteam_mobi_test/widgets/Item/ItemScreen.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ItemWidget extends StatefulWidget {
  final GlobalKey itemFormKey;
  final TextEditingController itemTitle;
  final TextEditingController itemPrice;
  final TextEditingController itemQuantity;
  final TextEditingController itemAmount;
  final VoidCallback onSave;
  final int itemId;

  const ItemWidget({
    Key key,
    this.itemFormKey,
    this.itemTitle,
    this.itemPrice,
    this.itemQuantity,
    this.itemAmount,
    this.onSave,
    this.itemId,
  }) : super(key: key);

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  final _itemFormKey = GlobalKey<FormState>();
  final TextEditingController _itemTitleController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemQuantityController = TextEditingController();
  final TextEditingController _itemAmountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () async {
        // Reset controllers to add new Item after editing old ones;
        // widget.itemTitle.clear();
        widget.itemTitle.text = '';
        widget.itemPrice.text = '';
        widget.itemQuantity.text = '';
        widget.itemAmount.text = '';
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemScreen(
              itemFormKey: _itemFormKey,
              itemTitle: _itemTitleController,
              itemPrice: _itemPriceController,
              itemQuantity: _itemQuantityController,
              itemAmount: _itemAmountController,
              // onSave: widget.onSave,
            ),
          ),
        );
      },
      child: Container(
        child: Row(
          children: [
            Icon(
              MdiIcons.cartVariant,
              color: Colors.grey,
              size: 30,
            ),
            Text(
              'Add Item',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
