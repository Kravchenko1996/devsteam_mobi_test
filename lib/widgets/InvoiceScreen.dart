import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/models/Item.dart';
import 'package:devsteam_mobi_test/widgets/Client/ClientWidget.dart';
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

  final TextEditingController _invoiceNameController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientEmailController = TextEditingController();
  final TextEditingController _itemTitleController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemQuantityController = TextEditingController();

  Client newClient = Client();
  Invoice newInvoice = Invoice();
  Item newItem = Item();

  int selectedClientId;
  List<Item> itemsOfInvoice = [];
  int total = 0;
  Item selectedItem;

  @override
  void initState() {
    super.initState();
    if (widget.invoice != null) {
      _getAllItemsByInvoiceId(widget.invoice.id);
    }
  }

  void _getAllItemsByInvoiceId(int invoiceId) async {
    var res = await DBProvider.db.getAllItemsByInvoiceId(invoiceId);
    if (res != null) {
      setState(() {
        itemsOfInvoice = res;
        countTotalOfInvoice();
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

  void _saveInvoice() async {
    if (_invoiceFormKey.currentState.validate()) {
      newInvoice = Invoice(
        name: _invoiceNameController.text,
        total: total,
        clientId: selectedClientId == null && widget.invoice != null
            ? widget.invoice.clientId
            : newClient.id,
      );
      await DBProvider.db.upsertInvoice(
        widget.invoice == null ? newInvoice : widget.invoice,
        selectedClientId == null && widget.invoice == null
            ? newClient.id
            : selectedClientId != null
                ? selectedClientId
                : widget.invoice.clientId,
      );
      await DBProvider.db.getAllInvoices();
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
  }

  void _addItemToList() {
    _itemFormKey.currentState.reset();
    if (_itemFormKey.currentState.validate()) {
      int itemPrice = int.parse(_itemPriceController.text);
      int itemQuantity = int.parse(_itemQuantityController.text);
      setState(() {
        Item newItem = Item(
          title: _itemTitleController.text,
          price: itemPrice,
          quantity: itemQuantity,
          amount: itemPrice * itemQuantity,
          invoiceId: null,
        );
        itemsOfInvoice.add(newItem);
        total += newItem.amount;
      });
    }
    // ToDo reset form after selecting item to edit;
    _itemFormKey.currentState.reset();
    Navigator.of(context).pop();
  }

  void countTotalOfInvoice() {
    if (itemsOfInvoice != null) {
      itemsOfInvoice.forEach((Item element) {
        total += element.amount;
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
      total -= selectedItem.amount;
      total += editedItem.amount;
    });
    _itemFormKey.currentState.reset();
    Navigator.of(context).pop();
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
                      'Total',
                    ),
                    Text(
                      total.toString(),
                    ),
                  ],
                ),
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
                return GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(itemsOfInvoice[index].title),
                          Row(
                            children: [
                              Text(
                                  '${itemsOfInvoice[index].quantity.toString()}'
                                  ' x ₴${itemsOfInvoice[index].price.toString()}')
                            ],
                          ),
                        ],
                      ),
                      Text('₴${itemsOfInvoice[index].amount.toString()}'),
                    ],
                  ),
                  onTap: () {
                    _chooseItemFromList(
                      itemsOfInvoice[index],
                    );
                  },
                );
              },
            ),
    );
  }
}
