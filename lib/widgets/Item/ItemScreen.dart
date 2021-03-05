import 'package:devsteam_mobi_test/models/Item.dart';
import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/item.dart';
import 'package:devsteam_mobi_test/widgets/Item/ItemForm.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class ItemScreen extends StatelessWidget {
  final GlobalKey itemFormKey;
  final TextEditingController itemTitle;
  final TextEditingController itemPrice;
  final TextEditingController itemQuantity;
  final TextEditingController itemAmount;
  final VoidCallback onSave;
  final List<Item> itemsOfInvoice;
  final bool toCreate;

  const ItemScreen(
      {Key key,
      this.itemFormKey,
      this.itemTitle,
      this.itemPrice,
      this.itemQuantity,
      this.itemAmount,
      this.onSave,
      this.itemsOfInvoice,
      this.toCreate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemView>(
      builder: (
        BuildContext itemContext,
        ItemView itemView,
        Widget child,
      ) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(MdiIcons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              MaterialButton(
                onPressed: () async {
                  if (toCreate) {
                    Item newItem = Item(
                      title: itemTitle.text,
                      price: double.parse(itemPrice.text),
                      quantity: double.parse(itemQuantity.text),
                      amount: double.parse(itemAmount.text),
                    );
                    itemView.saveItem(
                      newItem,
                      null,
                    );
                    itemsOfInvoice.add(newItem);
                    context.read<InvoiceView>().setSubTotal =
                        context.read<InvoiceView>().subTotal +
                            newItem.amount;
                  } else {
                    Item editedItem = Item(
                      id: itemView.item.id,
                      title: itemTitle.text,
                      price: double.parse(itemPrice.text),
                      quantity: double.parse(itemQuantity.text),
                      amount: double.parse(itemAmount.text),
                    );
                    int index = itemsOfInvoice.indexOf(itemView.item);
                    itemsOfInvoice[index] = editedItem;
                    itemView.saveItem(
                      editedItem,
                      itemView.item.invoiceId,
                    );
                    context.read<InvoiceView>().setSubTotal =
                        context.read<InvoiceView>().subTotal +
                            editedItem.amount;
                  }
                  context.read<InvoiceView>().updateDifference();
                  Navigator.of(context).pop();
                  // onSave();
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
      },
    );
  }
}
