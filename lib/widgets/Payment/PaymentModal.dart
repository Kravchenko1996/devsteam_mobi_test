import 'package:devsteam_mobi_test/widgets/FormHeader.dart';
import 'package:flutter/material.dart';

class PaymentModal extends StatefulWidget {
  final GlobalKey paymentFormKey;
  final TextEditingController paymentMethod;
  final TextEditingController paymentAmount;
  final VoidCallback onSave;
  final double total;
  final TextEditingController invoiceBalanceDue;
  final bool createMode;

  const PaymentModal({
    Key key,
    this.paymentFormKey,
    this.paymentMethod,
    this.paymentAmount,
    this.onSave,
    this.total,
    this.invoiceBalanceDue,
    this.createMode,
  }) : super(key: key);

  @override
  _PaymentModalState createState() => _PaymentModalState();
}

class _PaymentModalState extends State<PaymentModal> {
  bool isMenuOpen = false;
  final List<String> paymentMethods = [
    'Bank account',
    'Check',
    'PayPal',
    'Cash',
    'Card',
    'Stripe',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.createMode) {
      widget.paymentAmount.text = widget.total.toString();
      widget.paymentMethod.text = paymentMethods.last;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  height: 80,
                  child: ListView.builder(
                    itemCount: paymentMethods.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.paymentMethod.text = paymentMethods[index];
                            isMenuOpen = !isMenuOpen;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text('${paymentMethods[index]}'),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Form(
                key: widget.paymentFormKey,
                child: Column(
                  children: [
                    FormHeader(
                      title: 'Add payment',
                      onSave: widget.onSave,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: MaterialButton(
                            child: Text(
                              widget.paymentMethod.text.isEmpty
                                  ? 'Payment method'
                                  : widget.paymentMethod.text,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                if (isMenuOpen) {
                                  isMenuOpen = !isMenuOpen;
                                } else {
                                  isMenuOpen = true;
                                }
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 50,
                          child: TextFormField(
                            autofocus: true,
                            controller: widget.paymentAmount,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '${widget.total ?? 0}',
                            ),
                            onTap: () =>
                                widget.paymentAmount.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset:
                                  widget.paymentAmount.value.text.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
