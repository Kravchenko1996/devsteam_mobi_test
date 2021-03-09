import 'package:devsteam_mobi_test/models/Payment.dart';
import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/payment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentModal extends StatefulWidget {
  final GlobalKey paymentFormKey;
  final TextEditingController paymentMethod;
  final TextEditingController paymentAmount;
  final TextEditingController invoiceBalanceDue;
  final bool toCreate;

  const PaymentModal({
    Key key,
    this.paymentFormKey,
    this.paymentMethod,
    this.paymentAmount,
    this.invoiceBalanceDue,
    this.toCreate,
  }) : super(key: key);

  @override
  _PaymentModalState createState() => _PaymentModalState();
}

class _PaymentModalState extends State<PaymentModal> {
  bool isMenuOpen = false;
  double paymentsSum = 0;

  @override
  void initState() {
    super.initState();
    if (widget.toCreate) {
      PaymentView paymentView = Provider.of<PaymentView>(
        context,
        listen: false,
      );
      paymentView.countPaymentsSum(paymentView.paymentsOfInvoice);
      // Set "Other" as a default paymentMethod
      widget.paymentMethod.text = paymentView.paymentMethods.last;
      // Always show the rest in new payment
      // ToDo select all text while adding new payment
      widget.paymentAmount.text =
          (context.read<InvoiceView>().total - paymentView.paymentsSum)
              .toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentView>(
      builder: (
        BuildContext paymentContext,
        PaymentView paymentView,
        Widget child,
      ) {
        return Consumer<InvoiceView>(
          builder: (
            BuildContext invoiceContext,
            InvoiceView invoiceView,
            Widget child,
          ) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: 15,
                    top: 15,
                    right: 15,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 15,
                  ),
                  child: Column(
                    children: [
                      Visibility(
                        visible: isMenuOpen,
                        child: Container(
                          // ToDo replace fixed height with height of bottomModalSheet
                          height: 120,
                          child: ListView.builder(
                            itemCount: paymentView.paymentMethods.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.paymentMethod.text =
                                        paymentView.paymentMethods[index];
                                    isMenuOpen = !isMenuOpen;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    paymentView.paymentMethods[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.toCreate
                                    ? 'Add payment'
                                    : 'Edit payment',
                              ),
                              RaisedButton(
                                child: Text('Save'),
                                onPressed: () {
                                  if (widget.toCreate) {
                                    Payment newPayment = Payment(
                                      method: widget.paymentMethod.text,
                                      amount: double.parse(
                                        widget.paymentAmount.text,
                                      ),
                                    );
                                    paymentView.savePayment(
                                      newPayment,
                                      null,
                                    );
                                    paymentView.paymentsOfInvoice.add(
                                      newPayment,
                                    );
                                  } else {
                                    Payment editedPayment = Payment(
                                      id: paymentView.payment.id,
                                      method: widget.paymentMethod.text,
                                      amount: double.parse(
                                        widget.paymentAmount.text,
                                      ),
                                    );
                                    int index = paymentView.paymentsOfInvoice
                                        .indexOf(paymentView.payment);
                                    paymentView.paymentsOfInvoice[index] =
                                        editedPayment;
                                    paymentView.savePayment(
                                      editedPayment,
                                      paymentView.payment.invoiceId,
                                    );
                                  }
                                  paymentView
                                      .countBalanceDue(invoiceView.total);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: MaterialButton(
                                  child: Text(
                                    widget.paymentMethod.text,
                                  ),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(
                                      () {
                                        if (isMenuOpen) {
                                          isMenuOpen = !isMenuOpen;
                                        } else {
                                          isMenuOpen = true;
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                              Form(
                                key: widget.paymentFormKey,
                                child: Container(
                                  width: 50,
                                  child: TextFormField(
                                    autofocus: true,
                                    controller: widget.paymentAmount,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: '0.00',
                                    ),
                                    onTap: () => widget.paymentAmount
                                        .selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset: widget
                                          .paymentAmount.value.text.length,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
