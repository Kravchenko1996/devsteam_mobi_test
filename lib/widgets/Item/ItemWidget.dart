import 'package:devsteam_mobi_test/models/Item.dart';
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
  final List<Item> itemsOfInvoice;

  const ItemWidget(
      {Key key,
      this.itemFormKey,
      this.itemTitle,
      this.itemPrice,
      this.itemQuantity,
      this.itemAmount,
      this.onSave,
      this.itemId,
      this.itemsOfInvoice})
      : super(key: key);

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {

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
              itemFormKey: widget.itemFormKey,
              itemTitle: widget.itemTitle,
              itemPrice: widget.itemPrice,
              itemQuantity: widget.itemQuantity,
              itemAmount: widget.itemAmount,
              itemsOfInvoice: widget.itemsOfInvoice,
              toCreate: true,
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
