import 'package:devsteam_mobi_test/widgets/Item/ItemForm.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ItemScreen extends StatelessWidget {
  final GlobalKey itemFormKey;
  final TextEditingController itemTitle;
  final TextEditingController itemPrice;
  final TextEditingController itemQuantity;
  final TextEditingController itemAmount;
  final VoidCallback onSave;

  const ItemScreen({
    Key key,
    this.itemFormKey,
    this.itemTitle,
    this.itemPrice,
    this.itemQuantity,
    this.itemAmount,
    this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(MdiIcons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          MaterialButton(
            onPressed: () async {
              onSave();
            },
            child: Text('Save'),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: ItemForm(
            itemFormKey: itemFormKey,
            itemTitle: itemTitle,
            itemPrice: itemPrice,
            itemQuantity: itemQuantity,
            itemAmount: itemAmount,
            ),
      ),
    );
  }
}
