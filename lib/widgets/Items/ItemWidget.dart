import 'package:devsteam_mobi_test/widgets/Items/ItemForm.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ItemWidget extends StatefulWidget {
  final GlobalKey itemFormKey;
  final TextEditingController itemTitle;
  final TextEditingController itemPrice;
  final TextEditingController itemQuantity;
  final VoidCallback onSave;
  final int itemId;

  const ItemWidget({
    Key key,
    this.itemFormKey,
    this.itemTitle,
    this.itemPrice,
    this.itemQuantity,
    this.onSave,
    this.itemId,
  }) : super(key: key);

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: ItemForm(
                  itemFormKey: widget.itemFormKey,
                  itemTitle: widget.itemTitle,
                  itemPrice: widget.itemPrice,
                  itemQuantity: widget.itemQuantity,
                  onSave: widget.onSave,
                ),
              );
            });
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
