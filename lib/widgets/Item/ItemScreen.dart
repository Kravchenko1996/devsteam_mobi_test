import 'package:devsteam_mobi_test/models/Discount.dart';
import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/models/Item.dart';
import 'package:devsteam_mobi_test/models/Tax.dart';
import 'package:devsteam_mobi_test/viewmodels/discount.dart';
import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/item.dart';
import 'package:devsteam_mobi_test/viewmodels/tax.dart';
import 'package:devsteam_mobi_test/widgets/Item/ItemForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final GlobalKey<FormState> _discountFormKey = GlobalKey<FormState>();
  final TextEditingController _discountPercentageController =
      TextEditingController();
  final TextEditingController _discountAmountController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    TaxView taxView = Provider.of<TaxView>(context, listen: false);
    ItemView itemView = Provider.of<ItemView>(context, listen: false);
    DiscountView discountView =
        Provider.of<DiscountView>(context, listen: false);
    itemView.setTaxable = false;
    itemView.setDiscountable = false;
    discountView.setIsPercentageLast = true;
    itemView.setBtnEnabled = false;
    if (widget.itemTitle.text.isNotEmpty) {
      itemView.setBtnEnabled = true;
    }
    widget.itemPrice.text = '0.00';
    widget.itemQuantity.text = '1';
    widget.itemAmount.text = '1.00';
    if (itemView.item != null) {
      itemView.setTaxable = itemView.item.taxable == 1 ? true : false;
      itemView.setDiscountable = itemView.item.discountable == 1 ? true : false;
      taxView.getTaxByItemId(itemView.item.id);
      discountView.getDiscountByItemId(itemView.item.id);
      if (taxView.tax != null) {
        _taxNameController.text = taxView.tax.name;
        _taxAmountController.text = taxView.tax.amount.toString();
      }
      if (discountView.discount != null) {
        _discountPercentageController.text =
            discountView.discount.percentage.toString();
        _discountAmountController.text =
            discountView.discount.amount.toString();
      }
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
                return Consumer<DiscountView>(
                  builder: (
                    BuildContext discountContext,
                    DiscountView discountView,
                    Widget child,
                  ) {
                    return Scaffold(
                      appBar: AppBar(
                        leading: IconButton(
                          icon: Icon(MdiIcons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        actions: [
                          itemView.btnEnabled
                              ? _submitItemBtn(
                                  itemView,
                                  invoiceView,
                                  taxView,
                                  discountView,
                                  context,
                                )
                              : MaterialButton(
                                  onPressed: () async {},
                                  child: Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                        ],
                      ),
                      body: _buildBody(
                        itemView,
                        taxView,
                        discountView,
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _submitItemBtn(
    itemView,
    invoiceView,
    taxView,
    discountView,
    context,
  ) {
    return MaterialButton(
      onPressed: () async {
        _submitItem(
          itemView,
          invoiceView,
          taxView,
          discountView,
          context,
        );
      },
      child: Text(
        'Save',
      ),
    );
  }

  Widget _buildBody(
    ItemView itemView,
    TaxView taxView,
    DiscountView discountView,
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
              discountPercentage: _discountPercentageController,
              discountAmount: _discountAmountController,
            ),
            Divider(),
            _buildSwitch(
              'Discount',
              itemView.discountable,
              itemView.switchDiscount,
            ),
            Visibility(
              visible: itemView.discountable,
              child: _buildDiscountForm(itemView, discountView),
            ),
            Divider(),
            _buildSwitch(
              'Taxable',
              itemView.taxable,
              itemView.switchTaxable,
            ),
            Divider(),
            Visibility(
              visible: itemView.taxable &&
                  taxView.tax != null &&
                  taxView.tax.type == 'Per item',
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

  Widget _buildSwitch(String title, bool value, Function setter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              MdiIcons.fileDocumentOutline,
            ),
            Text(title),
          ],
        ),
        Switch(
          value: value,
          onChanged: (value) {
            setState(() {
              setter();
            });
          },
          activeTrackColor: Colors.lightBlueAccent,
          activeColor: Colors.blueAccent,
        ),
      ],
    );
  }

  _submitItem(
    ItemView itemView,
    InvoiceView invoiceView,
    TaxView taxView,
    DiscountView discountView,
    BuildContext context,
  ) async {
    Item item = Item(
        id: itemView.item != null ? itemView.item.id : null,
        title: widget.itemTitle.text,
        price: widget.itemPrice.text.isNotEmpty
            ? double.parse(widget.itemPrice.text)
            : 0,
        quantity: widget.itemQuantity.text.isNotEmpty
            ? double.parse(widget.itemQuantity.text)
            : 1,
        amount: double.parse(widget.itemAmount.text),
        taxable: itemView.taxable ? 1 : 0,
        discountable: itemView.discountable ? 1 : 0);
    if (item.id == null) {
      invoiceView.itemsOfInvoice.add(item);
    } else {
      // replace item with the updated to show changes on UI
      int index = invoiceView.itemsOfInvoice.indexOf(itemView.item);
      invoiceView.itemsOfInvoice[index] = item;
    }
    Item newItem = await itemView.saveItem(item, null);
    // Including Tax to Item;
    if (itemView.taxable &&
        taxView.tax != null &&
        taxView.tax.type == 'Per item') {
      Tax tax = Tax(
        id: taxView.tax != null ? taxView.tax.id : null,
        itemId: newItem.id,
        name: _taxNameController.text,
        amount: double.parse(_taxAmountController.text),
        type: taxView.taxTypes[1],
        included: null,
      );
      taxView.saveTax(
        tax,
        widget.invoice != null ? widget.invoice.id : null,
        invoiceView,
      );
      context.read<TaxView>().updateTaxDifference(invoiceView);
    }
    // Including Discount to Item;
    if (itemView.discountable) {
      Discount discount = Discount(
        id: discountView.discount != null ? discountView.discount.id : null,
        itemId: newItem.id,
        percentage: double.parse(_discountPercentageController.text),
        amount: double.parse(_discountAmountController.text),
        invoiceId: null,
        isPercentageLast: discountView.isPercentageLast ? 1 : 0,
      );
      discountView.saveDiscount(discount, null);
    }
    invoiceView.updateDifference();
    invoiceView.countSubtotal(invoiceView.itemsOfInvoice);
    invoiceView.countTotal(invoiceView.itemsOfInvoice);
    Navigator.of(context).pop();
  }

  Widget _buildDiscountForm(ItemView itemView, DiscountView discountView) {
    return Form(
      key: _discountFormKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Text(
                'Percentage',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              prefixIconConstraints: BoxConstraints(minHeight: 10),
              border: InputBorder.none,
              hintText: '0.00',
              suffix: Text('%'),
            ),
            textAlign: TextAlign.end,
            controller: _discountPercentageController,
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.always,
            validator: (String val) {
              if (val.isNotEmpty && double.tryParse(val) > 100) {
                return "Discount can't be larger than the item total";
              }
              return null;
            },
            onTap: () => _selectAllText(_discountPercentageController),
            onChanged: (_) => {
              _discountAmountController.text =
                  ((double.parse(widget.itemPrice.text) *
                              double.parse(widget.itemQuantity.text)) *
                          double.parse(_discountPercentageController.text) /
                          100)
                      .toString(),
              widget.itemAmount.text = ((double.parse(widget.itemPrice.text) *
                          double.parse(widget.itemQuantity.text)) -
                      double.parse(_discountAmountController.text))
                  .toString(),
              discountView.setIsPercentageLast = true,
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Text(
                'Fixed amount',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              prefixIconConstraints: BoxConstraints(minHeight: 10),
              border: InputBorder.none,
              hintText: '0.00',
            ),
            textAlign: TextAlign.end,
            controller: _discountAmountController,
            keyboardType: TextInputType.number,
            onTap: () => _selectAllText(_discountAmountController),
            onChanged: (_) => {
              _discountPercentageController.text =
                  (double.parse(_discountAmountController.text) *
                          100 /
                          (double.parse(widget.itemPrice.text) *
                              double.parse(widget.itemQuantity.text)))
                      .toString(),
              widget.itemAmount.text = ((double.parse(widget.itemPrice.text) *
                          double.parse(widget.itemQuantity.text)) -
                      double.parse(_discountAmountController.text))
                  .toString(),
              discountView.setIsPercentageLast = false,
            },
          )
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
