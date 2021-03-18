import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/models/Item.dart';
import 'package:devsteam_mobi_test/models/Tax.dart';
import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/item.dart';
import 'package:devsteam_mobi_test/viewmodels/tax.dart';
import 'package:devsteam_mobi_test/widgets/Item/ItemForm.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class ItemScreen extends StatefulWidget {
  final GlobalKey itemFormKey;
  final TextEditingController itemTitle;
  final TextEditingController itemPrice;
  final TextEditingController itemQuantity;
  final TextEditingController itemAmount;
  final Invoice invoice;

  const ItemScreen({
    Key key,
    this.itemFormKey,
    this.itemTitle,
    this.itemPrice,
    this.itemQuantity,
    this.itemAmount,
    this.invoice,
  }) : super(key: key);

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  final GlobalKey<FormState> _taxFormKey = GlobalKey<FormState>();
  final TextEditingController _taxNameController = TextEditingController();
  final TextEditingController _taxAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    TaxView taxView = Provider.of<TaxView>(context, listen: false);
    ItemView itemView = Provider.of<ItemView>(context, listen: false);
    itemView.setTaxable = false;
    if (itemView.item != null) {
      itemView.setTaxable = itemView.item.taxable == 1 ? true : false;
      taxView.getTaxByItemId(itemView.item.id);
      _taxNameController.text = taxView.tax.name;
      _taxAmountController.text = taxView.tax.amount.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemView>(
      builder: (
        BuildContext itemContext,
        ItemView itemView,
        Widget child,
      ) {
        return Consumer<InvoiceView>(
          builder: (
            BuildContext invoiceContext,
            InvoiceView invoiceView,
            Widget child,
          ) {
            return Consumer<TaxView>(
              builder: (
                BuildContext taxContext,
                TaxView taxView,
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
                          _submitItem(
                            itemView,
                            invoiceView,
                            taxView,
                            context,
                          );
                        },
                        child: Text(
                          'Save',
                        ),
                      ),
                    ],
                  ),
                  body: _buildBody(
                    itemView,
                    taxView,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildBody(
    ItemView itemView,
    TaxView taxView,
  ) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            ItemForm(
              itemFormKey: widget.itemFormKey,
              itemTitle: widget.itemTitle,
              itemPrice: widget.itemPrice,
              itemQuantity: widget.itemQuantity,
              itemAmount: widget.itemAmount,
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      MdiIcons.fileDocumentOutline,
                    ),
                    Text('Taxable'),
                  ],
                ),
                Switch(
                  value: itemView.taxable,
                  onChanged: (value) {
                    setState(() {
                      itemView.setTaxable = !itemView.taxable;
                    });
                  },
                  activeTrackColor: Colors.lightBlueAccent,
                  activeColor: Colors.blueAccent,
                ),
              ],
            ),
            Visibility(
              visible: itemView.taxable && taxView.tax.type == 'Per item',
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildTaxForm(),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  itemView.taxable
                      ? 'Item tax will be added to the item price'
                      : 'This item will appear as non-taxable',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _submitItem(
    ItemView itemView,
    InvoiceView invoiceView,
    TaxView taxView,
    BuildContext context,
  ) async {
    Item item = Item(
      id: itemView.item != null ? itemView.item.id : null,
      title: widget.itemTitle.text,
      price: double.parse(widget.itemPrice.text),
      quantity: double.parse(widget.itemQuantity.text),
      amount: double.parse(widget.itemAmount.text),
      taxable: itemView.taxable ? 1 : 0,
    );
    itemView.saveItem(item, null);
    if (item.id == null) {
      invoiceView.itemsOfInvoice.add(item);
    } else {
      // replace item with updated to show changes on UI
      int index = invoiceView.itemsOfInvoice.indexOf(itemView.item);
      invoiceView.itemsOfInvoice[index] = item;
    }
    if (itemView.taxable) {
      Tax tax = Tax(
        id: taxView.tax != null ? taxView.tax.id : null,
        name: _taxNameController.text,
        amount: double.parse(_taxAmountController.text),
        type: taxView.taxTypes[1],
        included: null,
        itemId: itemView.item.id,
      );
      taxView.saveTax(
        tax,
        widget.invoice != null ? widget.invoice.id : null,
        invoiceView,
      );
    }
    invoiceView.updateDifference();
    invoiceView.countSubtotal(invoiceView.itemsOfInvoice);
    invoiceView.countTotal(invoiceView.itemsOfInvoice);
    context.read<TaxView>().updateTaxDifference(invoiceView);
    Navigator.of(context).pop();
  }

  Widget _buildTaxForm() {
    return Form(
      key: _taxFormKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 80,
            child: TextFormField(
              controller: _taxNameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Tax name',
              ),
              onTap: () {},
            ),
          ),
          Container(
            width: 50,
            child: TextFormField(
              controller: _taxAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '0.00',
                suffixIcon: Text('%'),
                suffixIconConstraints: BoxConstraints(
                  minWidth: 10,
                ),
                border: InputBorder.none,
              ),
              onTap: () => _taxAmountController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _taxAmountController.value.text.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
