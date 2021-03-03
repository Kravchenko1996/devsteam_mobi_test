import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/models/Item.dart';
import 'package:devsteam_mobi_test/models/Payment.dart';
import 'package:devsteam_mobi_test/widgets/Client/ClientWidget.dart';
import 'package:devsteam_mobi_test/widgets/Discount/DiscountWidget.dart';
import 'package:devsteam_mobi_test/widgets/InvoiceNameWidget.dart';
import 'package:devsteam_mobi_test/widgets/Item/ItemScreen.dart';
import 'package:devsteam_mobi_test/widgets/Item/ItemWidget.dart';
import 'package:devsteam_mobi_test/widgets/Payment/PaidWidget.dart';
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
  final _paymentFormKey = GlobalKey<FormState>();

  final TextEditingController _invoiceNameController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientEmailController = TextEditingController();
  final TextEditingController _itemTitleController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemQuantityController = TextEditingController();
  final TextEditingController _itemAmountController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _differenceController = TextEditingController();
  final TextEditingController _paymentMethodCntrller = TextEditingController();
  final TextEditingController _paymentAmountCntrller = TextEditingController();
  final TextEditingController _invoiceBalanceDueController =
      TextEditingController();

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
  double balanceDue = 0.0;
  List<Payment> _paymentsOfInvoice = [];

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
        _countTotal();
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
        _differenceController.text = difference.toString();
        _invoiceBalanceDueController.text = res.balanceDue.toString();
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
        balanceDue: balanceDue,
      );
      await DBProvider.db.upsertInvoice(
        widget.invoice == null ? newInvoice : widget.invoice,
        _getClientId(),
        discount,
        total,
        balanceDue,
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
      if (_paymentsOfInvoice != null) {
        _paymentsOfInvoice.forEach((Payment payment) async {
          if (payment.invoiceId == null) {
            await DBProvider.db.upsertPayment(
              Payment(
                method: payment.method,
                amount: payment.amount,
                invoiceId:
                    widget.invoice != null ? widget.invoice.id : newInvoice.id,
              ),
            );
          }
        });
      }
    }
    Navigator.of(context).pop();
  }

  void _saveItem(Item item) async {
    await DBProvider.db.upsertItem(item);
  }

  void _addItemToList() {
    if (_itemFormKey.currentState.validate()) {
      double price = _itemPriceController.text.isNotEmpty
          ? double.parse(_itemPriceController.text)
          : 0.0;
      double quantity = _itemQuantityController.text.isNotEmpty
          ? double.parse(_itemQuantityController.text)
          : 0.0;
      double amount = _itemAmountController.text.isNotEmpty
          ? double.parse(_itemAmountController.text)
          : 0.0;
      Item newItem = Item(
        title: _itemTitleController.text,
        price: price,
        quantity: quantity,
        amount: amount,
        invoiceId: null,
      );
      _saveItem(newItem);
      setState(() {
        itemsOfInvoice.add(newItem);
        subTotal += newItem.amount;
        _differenceController.text = (subTotal * discount / 100).toString();
        total += newItem.amount;
      });
    }
    _updateDifference();
    _countTotal();
    Navigator.of(context).pop();
  }

  void _updateDifference() {
    double disc = _discountController.text == null
        ? double.parse(_discountController.text)
        : discount;
    setState(() {
      difference = (subTotal * disc / 100);
      _differenceController.text = difference.toString();
    });
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
      _itemAmountController.text = selectedItem.amount.toString();
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ItemScreen(
            itemFormKey: _itemFormKey,
            itemTitle: _itemTitleController,
            itemPrice: _itemPriceController,
            itemQuantity: _itemQuantityController,
            itemAmount: _itemAmountController,
            onSave: _changeItemInList,
          );
        },
      ),
    );
  }

  void _changeItemInList() {
    int index = itemsOfInvoice.indexOf(selectedItem);
    Item editedItem = Item(
      title: _itemTitleController.text,
      price: double.parse(_itemPriceController.text),
      quantity: double.parse(_itemQuantityController.text),
      amount: double.parse(_itemAmountController.text),
    );
    setState(() {
      itemsOfInvoice[index] = editedItem;
      subTotal -= selectedItem.amount;
      subTotal += editedItem.amount;
      _updateDifference();
      _countTotal();
    });
    _itemFormKey.currentState.reset();
    Navigator.of(context).pop();
  }

  void _deleteItem(int itemId) async {
    await DBProvider.db.deleteItem(itemId);
  }

  void _saveDiscount() {
    if (_discountController.text.isNotEmpty) {
      setState(() {
        discount = double.parse(_discountController.text);
        difference = subTotal * discount / 100;
        _countTotal();
      });
    }
    Navigator.of(context).pop();
  }

  void _countTotal() {
    setState(() {
      total = subTotal - difference;
    });
  }

  void _saveBalanceDue() {
    if (_invoiceBalanceDueController.text.isNotEmpty) {
      setState(() {
        balanceDue = double.parse(_invoiceBalanceDueController.text);
      });
    }
  }

  void _savePayment(Payment payment) async {
    await DBProvider.db.upsertPayment(payment);
  }

  void _addPaymentToList() async {
    if (_paymentAmountCntrller.text.isNotEmpty) {
      double amount = double.parse(_paymentAmountCntrller.text);
      Payment newPayment = Payment(
        method: _paymentMethodCntrller.text,
        amount: amount,
      );
      setState(() {
        _paymentsOfInvoice.add(newPayment);
        _invoiceBalanceDueController.text = (total - amount).toString();
      });
      print(_paymentsOfInvoice);
      _savePayment(newPayment);
      _saveBalanceDue();
      Navigator.of(context).pop();
    }
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
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
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
        _buildItems(widget.invoice != null ? widget.invoice.id : newInvoice.id),
        ItemWidget(
          itemFormKey: _itemFormKey,
          itemTitle: _itemTitleController,
          itemPrice: _itemPriceController,
          itemQuantity: _itemQuantityController,
          itemAmount: _itemAmountController,
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
          invoiceDifference: _differenceController,
          onSave: _saveDiscount,
          discount: discount,
          invoice: widget.invoice != null ? widget.invoice : null,
          difference: difference,
          subTotal: subTotal,
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
        ),
        PaidWidget(
          total: total,
          paymentFormKey: _paymentFormKey,
          paymentMethod: _paymentMethodCntrller,
          paymentAmount: _paymentAmountCntrller,
          onSave: _addPaymentToList,
          invoiceBalanceDue: _invoiceBalanceDueController,
          paymentsList: _paymentsOfInvoice,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Balance due',
            ),
            Text(
              _invoiceBalanceDueController.text,
            ),
          ],
        )
      ],
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
                      difference = (subTotal *
                          double.parse(_discountController.text) /
                          100);
                      _differenceController.text = difference.toString();
                      total = subTotal - difference;
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
