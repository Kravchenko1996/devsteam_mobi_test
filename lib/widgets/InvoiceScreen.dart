import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/models/Item.dart';
import 'package:devsteam_mobi_test/widgets/Client/ClientWidget.dart';
import 'package:devsteam_mobi_test/widgets/Discount/DiscountWidget.dart';
import 'package:devsteam_mobi_test/widgets/InvoiceNameWidget.dart';
import 'package:devsteam_mobi_test/widgets/Items/ItemForm.dart';
import 'package:devsteam_mobi_test/widgets/Items/ItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class InvoiceScreen extends StatefulWidget {
  final Invoice invoice;

  const InvoiceScreen({
    Key key,
    this.invoice,
  }) : super(key: key);

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final _invoiceFormKey = GlobalKey<FormState>();
  final _clientFormKey = GlobalKey<FormState>();
  final _itemFormKey = GlobalKey<FormState>();
  final _discountFormKey = GlobalKey<FormState>();

  final TextEditingController _invoiceNameController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientEmailController = TextEditingController();
  final TextEditingController _itemTitleController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemQuantityController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  Client newClient = Client();
  Invoice newInvoice = Invoice();
  Item newItem = Item();

  int selectedClientId;
  List<Item> itemsOfInvoice = [];
  double subTotal = 0.0;
  Item selectedItem;
  double discount = 0.0;
  double difference = 0.0;
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.invoice != null) {
      _getAllItemsByInvoiceId();
      _getInvoiceInfo();
    }
  }

  void _getAllItemsByInvoiceId() async {
    var res = await DBProvider.db.getAllItemsByInvoiceId(widget.invoice.id);
    if (res != null) {
      setState(() {
        itemsOfInvoice = res;
        _countSubtotalOfInvoice();
        countTotal();
      });
    }
  }

  void _getInvoiceInfo() async {
    var res = await DBProvider.db.fetchInvoice(widget.invoice.id);
    if (res != null) {
      setState(() {
        discount = res.discount != null ? res.discount : 0;
        total = res.total;
        _discountController.text = res.discount.toString();
        difference = subTotal - total;
      });
    }
  }

  void _chooseClientFromList(Client selectedClient) {
    setState(() {
      selectedClientId = selectedClient.id;
      _clientNameController.text = selectedClient.name;
      _clientEmailController.text = selectedClient.email;
    });
  }

  void _saveClient() async {
    if (_clientFormKey.currentState.validate()) {
      newClient = Client(
        name: _clientNameController.text,
        email: _clientEmailController.text,
      );
      await DBProvider.db.upsertClient(
        newClient,
        selectedClientId == null && widget.invoice != null
            ? widget.invoice.clientId
            : selectedClientId,
      );
      setState(() {
        _clientNameController.text = _clientNameController.text;
      });
      Navigator.of(context).pop();
    }
  }

  void _removeClientFromInvoice() async {
    await DBProvider.db.removeClientFromInvoice(widget.invoice.id);
    setState(() {
      _clientNameController.text = '';
      _clientEmailController.text = '';
    });
    Navigator.of(context).pop();
  }

  int _getClientId() {
    var res = _clientNameController.text.isEmpty
        ? null
        : selectedClientId != null
            ? selectedClientId
            : newClient.id != null
                ? newClient.id
                : widget.invoice.clientId;
    return res;
  }

  void _saveInvoice() async {
    if (_invoiceFormKey.currentState.validate()) {
      newInvoice = Invoice(
        name: _invoiceNameController.text,
        total: total,
        clientId: _getClientId(),
      );
      await DBProvider.db.upsertInvoice(
        widget.invoice == null ? newInvoice : widget.invoice,
        _getClientId(),
        discount,
        total,
      );
      if (itemsOfInvoice != null) {
        itemsOfInvoice.forEach(
          (Item item) async {
            if (item.invoiceId == null) {
              await DBProvider.db.upsertItem(
                Item(
                  title: item.title,
                  price: item.price,
                  quantity: item.quantity,
                  amount: item.amount,
                  invoiceId: widget.invoice != null
                      ? widget.invoice.id
                      : newInvoice.id,
                ),
              );
            }
          },
        );
      }
    }
    await DBProvider.db.getAllInvoices();
  }

  void _addItemToList() {
    if (_itemFormKey.currentState.validate()) {
      int itemPrice = int.parse(_itemPriceController.text);
      int itemQuantity = int.parse(_itemQuantityController.text);
      Item newItem = Item(
        title: _itemTitleController.text,
        price: itemPrice,
        quantity: itemQuantity,
        amount: itemPrice * itemQuantity,
        invoiceId: null,
      );
      setState(() {
        itemsOfInvoice.add(newItem);
        subTotal += newItem.amount;
        total += newItem.amount;
      });
    }
    Navigator.of(context).pop();
  }

  void _countSubtotalOfInvoice() {
    if (itemsOfInvoice != null) {
      itemsOfInvoice.forEach((Item element) {
        subTotal += element.amount;
      });
    }
  }

  void _chooseItemFromList(Item onTapItem) {
    setState(() {
      selectedItem = onTapItem;
    });
    _editSelectedItem();
  }

  void _editSelectedItem() {
    setState(() {
      _itemTitleController.text = selectedItem.title;
      _itemPriceController.text = selectedItem.price.toString();
      _itemQuantityController.text = selectedItem.quantity.toString();
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: ItemForm(
              itemFormKey: _itemFormKey,
              itemTitle: _itemTitleController,
              itemPrice: _itemPriceController,
              itemQuantity: _itemQuantityController,
              onSave: _changeItemInList,
            ),
          );
        });
  }

  void _changeItemInList() {
    int index = itemsOfInvoice.indexOf(selectedItem);
    int itemPrice = int.parse(_itemPriceController.text);
    int itemQuantity = int.parse(_itemQuantityController.text);
    Item editedItem = Item(
      title: _itemTitleController.text,
      price: itemPrice,
      quantity: itemQuantity,
      amount: itemPrice * itemQuantity,
    );
    setState(() {
      itemsOfInvoice[index] = editedItem;
      subTotal -= selectedItem.amount;
      subTotal += editedItem.amount;
    });
    _itemFormKey.currentState.reset();
    Navigator.of(context).pop();
  }

  void _deleteItem(int itemId) async {
    await DBProvider.db.deleteItem(itemId);
  }

  void _saveDiscount() {
    setState(() {
      discount = double.parse(_discountController.text);
      difference = subTotal * discount / 100;
      countTotal();
    });
    Navigator.of(context).pop();
  }

  void countTotal() {
    setState(() {
      total = subTotal - difference;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(MdiIcons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Form(
          key: _invoiceFormKey,
          child: InvoiceNameWidget(
            invoice: widget.invoice,
            invoiceName: _invoiceNameController,
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () async {
              _saveInvoice();
            },
            child: Text('Save'),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                ClientWidget(
                  clientFormKey: _clientFormKey,
                  clientName: _clientNameController,
                  clientEmail: _clientEmailController,
                  onSave: _saveClient,
                  onChoose: _chooseClientFromList,
                  onRemove: _removeClientFromInvoice,
                  clientId: widget.invoice != null
                      ? widget.invoice.clientId
                      : selectedClientId,
                ),
                _buildItems(
                    widget.invoice != null ? widget.invoice.id : newInvoice.id),
                ItemWidget(
                  itemFormKey: _itemFormKey,
                  itemTitle: _itemTitleController,
                  itemPrice: _itemPriceController,
                  itemQuantity: _itemQuantityController,
                  onSave: _addItemToList,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal',
                    ),
                    Text(
                      subTotal.toString(),
                    ),
                  ],
                ),
                DiscountWidget(
                  discountFormKey: _discountFormKey,
                  invoiceDiscount: _discountController,
                  onSave: _saveDiscount,
                  discount: discount,
                  invoice: widget.invoice != null ? widget.invoice : null,
                  difference: difference,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                    ),
                    Text(
                      total.toStringAsFixed(2),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItems(int invoiceId) {
    return Container(
      child: itemsOfInvoice == null
          ? Container()
          : ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: itemsOfInvoice.length,
              itemBuilder: (BuildContext context, int index) {
                final Item currentItem = itemsOfInvoice[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    setState(() {
                      itemsOfInvoice.removeAt(index);
                      _deleteItem(currentItem.id);
                      subTotal -= currentItem.amount;
                      total -= currentItem.amount;
                    });
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${currentItem.title} dismissed'),
                      ),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.redAccent,
                    child: Icon(
                      Icons.delete,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                  child: GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(currentItem.title),
                            Row(
                              children: [
                                Text('${currentItem.quantity.toString()}'
                                    ' x ₴${currentItem.price.toString()}')
                              ],
                            ),
                          ],
                        ),
                        Text('₴${currentItem.amount.toString()}'),
                      ],
                    ),
                    onTap: () {
                      _chooseItemFromList(
                        currentItem,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
