import 'package:devsteam_mobi_test/models/Payment.dart';
import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/payment.dart';
import 'package:devsteam_mobi_test/widgets/FABWidget.dart';
import 'package:devsteam_mobi_test/widgets/Payment/PaymentModal.dart';
import 'package:devsteam_mobi_test/widgets/RowWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentsScreen extends StatefulWidget {
  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<PaymentView>(context, listen: false).countBalanceDue(
        Provider.of<InvoiceView>(context, listen: false).total);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext paymentContext,
        PaymentView paymentView,
        Widget child,
      ) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Payments',
            ),
          ),
          floatingActionButton: FABWidget(
            isModal: true,
            label: 'Add payment',
            route: PaymentModal(
              toCreate: true,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: Container(
            margin: EdgeInsets.all(15),
            child: Column(
              children: [
                buildRow(
                  'Invoice total',
                  context.read<InvoiceView>().total.toString(),
                ),
                buildRow(
                  'Balance due',
                  paymentView.balanceDue == null
                      ? context.read<InvoiceView>().total.toString()
                      : paymentView.balanceDue.toString(),
                ),
                _buildPayments(paymentView),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPayments(PaymentView paymentView) {
    return Container(
      child: paymentView.paymentsOfInvoice == null
          ? Container()
          : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: paymentView.paymentsOfInvoice.length,
              itemBuilder: (BuildContext context, int index) {
                final Payment currentPayment =
                    paymentView.paymentsOfInvoice[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    setState(() {
                      paymentView.paymentsOfInvoice.removeAt(index);
                      if (currentPayment.id != null) {
                        paymentView.deletePayment(currentPayment.id);
                      }
                      paymentView
                          .countBalanceDue(context.read<InvoiceView>().total);
                      paymentView
                          .countPaymentsSum(paymentView.paymentsOfInvoice);
                    });
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Payment dismissed',
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
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      paymentView.selectPaymentFromList(currentPayment);
                      paymentView.paymentMethod.text = currentPayment.method;
                      paymentView.paymentAmount.text =
                          currentPayment.amount.toString();
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        context: context,
                        builder: (BuildContext context) {
                          return PaymentModal(
                            toCreate: false,
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentPayment.method,
                              ),
                            ],
                          ),
                          Text(
                            currentPayment.amount.toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
