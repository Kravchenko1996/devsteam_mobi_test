import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/models/Item.dart';
import 'package:devsteam_mobi_test/models/Payment.dart';
import 'package:devsteam_mobi_test/models/Photo.dart';
import 'package:devsteam_mobi_test/viewmodels/client.dart';
import 'package:devsteam_mobi_test/viewmodels/company.dart';
import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/item.dart';
import 'package:devsteam_mobi_test/viewmodels/payment.dart';
import 'package:devsteam_mobi_test/viewmodels/photo.dart';
import 'package:devsteam_mobi_test/widgets/Client/ClientWidget.dart';
import 'package:devsteam_mobi_test/widgets/Company/CompanyWidget.dart';
import 'package:devsteam_mobi_test/widgets/DatePicker/DatePickerWidget.dart';
import 'package:devsteam_mobi_test/widgets/Discount/DiscountWidget.dart';
import 'package:devsteam_mobi_test/widgets/DueWidget.dart';
import 'package:devsteam_mobi_test/widgets/InvoiceNameWidget.dart';
import 'package:devsteam_mobi_test/widgets/Item/ItemScreen.dart';
import 'package:devsteam_mobi_test/widgets/Item/ItemWidget.dart';
import 'package:devsteam_mobi_test/widgets/Payment/PaidWidget.dart';
import 'package:devsteam_mobi_test/widgets/Photo/AddPhotoWidget.dart';
import 'package:devsteam_mobi_test/widgets/RowWidget.dart';
import 'package:devsteam_mobi_test/widgets/Signature/AddSignatureWidget.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

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
  final _itemFormKey = GlobalKey<FormState>();

  final TextEditingController _invoiceNameController = TextEditingController();
  final TextEditingController _itemTitleController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemQuantityController = TextEditingController();
  final TextEditingController _itemAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    InvoiceView invoiceView = Provider.of<InvoiceView>(context, listen: false);
    PaymentView paymentView = Provider.of<PaymentView>(context, listen: false);
    ClientView clientView = Provider.of<ClientView>(context, listen: false);
    PhotoView photoView = Provider.of<PhotoView>(context, listen: false);
    CompanyView companyView = Provider.of<CompanyView>(context, listen: false);
    _getCompany(companyView);
    if (widget.invoice != null) {
      _getInvoiceById(widget.invoice.id, invoiceView);
      _getAllItemsByInvoiceId(widget.invoice.id, invoiceView);
      _getAllPaymentsByInvoiceId(widget.invoice.id, paymentView);
      _getAllPhotosByInvoiceId(widget.invoice.id, photoView);
      if (widget.invoice.clientId != null) {
        _getClientById(widget.invoice.clientId, clientView);
      }
    }
    invoiceView.setSubTotal = 0;
    invoiceView.setTotal = 0;
    invoiceView.setDiscount = 0;
    invoiceView.setDifference = 0;
    invoiceView.setItemsOfInvoice = [];
    paymentView.setPaymentsOfInvoice = [];
    paymentView.setBalanceDue = 0;
    paymentView.setPaymentsSum = 0;
    invoiceView.setDate = DateTime.now();
    invoiceView.setDueOption = invoiceView.dueOptions.first;
    invoiceView.setDueDate = invoiceView.dueOptions.first;
    clientView.setClient = null;
    photoView.setPhotosOfInvoice = [];
  }

  void _getAllItemsByInvoiceId(
    int invoiceId,
    InvoiceView invoiceView,
  ) async {
    invoiceView.getAllItemsByInvoiceId(invoiceId);
  }

  void _getAllPaymentsByInvoiceId(
    int invoiceId,
    PaymentView paymentView,
  ) async {
    paymentView.getAllPaymentsByInvoiceId(invoiceId);
  }

  void _getInvoiceById(
    int invoiceId,
    InvoiceView invoiceView,
  ) async {
    invoiceView.getInvoiceById(invoiceId);
  }

  void _getClientById(
    int clientId,
    ClientView clientView,
  ) async {
    clientView.getClientById(clientId);
  }

  void _getAllPhotosByInvoiceId(
    int invoiceId,
    PhotoView photoView,
  ) async {
    photoView.getAllPhotosByInvoiceId(invoiceId);
  }

  void _getCompany(CompanyView companyView) async {
    companyView.getAllCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceView>(
      builder: (
        BuildContext invoiceContext,
        InvoiceView invoiceView,
        Widget child,
      ) {
        return Consumer<ItemView>(
          builder: (
            BuildContext itemContext,
            ItemView itemView,
            Widget child,
          ) {
            return Consumer<PaymentView>(
              builder: (
                BuildContext paymentContext,
                PaymentView paymentView,
                Widget child,
              ) {
                return Consumer<PhotoView>(
                  builder: (
                    BuildContext photoContext,
                    PhotoView photoView,
                    Widget child,
                  ) {
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
                              Invoice newInvoice = Invoice(
                                name: _invoiceNameController.text,
                                clientId:
                                    context.read<ClientView>().client != null
                                        ? context.read<ClientView>().client.id
                                        : null,
                                discount: invoiceView.discount ?? 0,
                                total: invoiceView.subTotal -
                                        invoiceView.difference ??
                                    0,
                                date: invoiceView.date.millisecondsSinceEpoch,
                                dueDate: invoiceView.dueDate,
                                dueOption: invoiceView.dueOption,
                                companyId: context.read<CompanyView>().company.id
                              );
                              Invoice invoice = await invoiceView.saveInvoice(
                                widget.invoice ?? newInvoice,
                                context.read<ClientView>().client != null
                                    ? context.read<ClientView>().client.id
                                    : null,
                                invoiceView.discount,
                                invoiceView.subTotal - invoiceView.difference,
                                invoiceView.date.millisecondsSinceEpoch,
                                invoiceView.dueDate,
                                invoiceView.dueOption,
                              );
                              if (invoiceView.itemsOfInvoice != null) {
                                invoiceView.itemsOfInvoice.forEach(
                                  (Item item) async {
                                    if (item.invoiceId == null) {
                                      itemView.saveItem(
                                        item,
                                        widget.invoice != null
                                            ? widget.invoice.id
                                            : invoice.id,
                                      );
                                    }
                                  },
                                );
                              }
                              if (paymentView.paymentsOfInvoice.length != 0) {
                                paymentView.paymentsOfInvoice.forEach(
                                  (Payment payment) async {
                                    if (payment.invoiceId == null) {
                                      paymentView.savePayment(
                                        payment,
                                        widget.invoice != null
                                            ? widget.invoice.id
                                            : invoice.id,
                                      );
                                    }
                                  },
                                );
                              }
                              if (photoView.photosOfInvoice.length != 0) {
                                photoView.photosOfInvoice.forEach(
                                  (Photo photo) async {
                                    photoView.savePhoto(
                                      Photo(
                                        id: photo.id ?? null,
                                        file: photo.file,
                                        invoiceId: widget.invoice != null
                                            ? widget.invoice.id
                                            : invoice.id,
                                      ),
                                    );
                                  },
                                );
                              }
                              Navigator.of(context).pop();
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
                            child:
                                _buildBody(itemView, invoiceView, paymentView),
                          ),
                        ),
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

  Widget _buildBody(
    ItemView itemView,
    InvoiceView invoiceView,
    PaymentView paymentView,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DatePickerWidget(),
            DueWidget(),
          ],
        ),
        ClientWidget(
          invoice: widget.invoice,
        ),
        _buildItems(
          itemView,
          invoiceView,
        ),
        ItemWidget(
          itemFormKey: _itemFormKey,
          itemTitle: _itemTitleController,
          itemPrice: _itemPriceController,
          itemQuantity: _itemQuantityController,
          itemAmount: _itemAmountController,
        ),
        buildRow(
          'Subtotal',
          invoiceView.subTotal == 0 ? '0' : invoiceView.subTotal.toString(),
        ),
        DiscountWidget(),
        buildRow(
          'Total',
          invoiceView.total != null ? invoiceView.total.toString() : '0',
        ),
        PaidWidget(),
        buildRow(
          'Balance due',
          (invoiceView.total - paymentView.paymentsSum).toString(),
        ),
        CompanyWidget(
          invoice: widget.invoice,
        ),
        AddPhotoWidget(),
        AddSignatureWidget(),
      ],
    );
  }

  Widget _buildItems(
    ItemView itemView,
    InvoiceView invoiceView,
  ) {
    return Container(
      child: invoiceView.itemsOfInvoice == null
          ? Container()
          : ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: invoiceView.itemsOfInvoice.length,
              itemBuilder: (BuildContext context, int index) {
                final Item currentItem = invoiceView.itemsOfInvoice[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    setState(() {
                      invoiceView.itemsOfInvoice.removeAt(index);
                      itemView.deleteItem(currentItem.id);
                      invoiceView.setSubTotal =
                          invoiceView.subTotal - currentItem.amount;
                      invoiceView.updateDifference();
                      invoiceView.setTotal =
                          invoiceView.subTotal - invoiceView.difference;
                    });
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${currentItem.title} dismissed',
                        ),
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
                      itemView.selectItemFromList(currentItem);
                      _itemTitleController.text = currentItem.title;
                      _itemPriceController.text = currentItem.price.toString();
                      _itemAmountController.text =
                          currentItem.amount.toString();
                      _itemQuantityController.text =
                          currentItem.quantity.toString();
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
                              toCreate: false,
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
