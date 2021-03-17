import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/models/Tax.dart';
import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/tax.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaxForm extends StatefulWidget {
  final GlobalKey taxFormKey;
  final TextEditingController taxName;
  final TextEditingController taxAmount;
  final TextEditingController taxType;
  final Invoice invoice;

  const TaxForm({
    Key key,
    this.taxFormKey,
    this.taxName,
    this.taxAmount,
    this.taxType,
    this.invoice,
  }) : super(key: key);

  @override
  _TaxFormState createState() => _TaxFormState();
}

class _TaxFormState extends State<TaxForm> {
  bool isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    TaxView taxView = Provider.of<TaxView>(context, listen: false);
    // Set "On total" as a default taxType
    if (widget.taxType.text.isEmpty) {
      widget.taxType.text = taxView.taxTypes.first;
    }
    if (taxView.tax != null) {
      widget.taxName.text = taxView.tax.name;
      widget.taxType.text = taxView.tax.type;
      widget.taxAmount.text = taxView.tax.amount.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext taxContext,
        TaxView taxView,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: isMenuOpen,
                    child: Container(
                      // ToDo replace fixed height with height of bottomModalSheet
                      height: 120,
                      child: ListView.builder(
                        itemCount: taxView.taxTypes.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              setState(() {
                                widget.taxType.text = taxView.taxTypes[index];
                                isMenuOpen = !isMenuOpen;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(taxView.taxTypes[index]),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tax'),
                      RaisedButton(
                        child: Text('Save'),
                        onPressed: () {
                          Tax newTax = Tax(
                            id: taxView.tax != null ? taxView.tax.id : null,
                            name: widget.taxName.text,
                            amount: double.parse(widget.taxAmount.text),
                            type: widget.taxType.text,
                            included: 1,
                          );
                          taxView.saveTax(
                            newTax,
                            widget.invoice != null ? widget.invoice.id : null,
                            context.read<InvoiceView>(),
                          );
                          if (newTax.id == null) {
                            taxView.taxesOfInvoice.add(newTax);
                          }
                          Navigator.of(context).popUntil(
                            (route) => route.settings.name == 'InvoiceScreen',
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MaterialButton(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            Text('Tax type'),
                            Text(widget.taxType.text),
                          ],
                        ),
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
                    ],
                  ),
                  Visibility(
                    visible: widget.taxType.text == 'On total',
                    child: Column(
                      children: [
                        Form(
                          key: widget.taxFormKey,
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 100,
                                child: TextFormField(
                                  controller: widget.taxName,
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
                                  controller: widget.taxAmount,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: '0.00',
                                  ),
                                  onTap: () => widget.taxAmount.selection =
                                      TextSelection(
                                    baseOffset: 0,
                                    extentOffset:
                                        widget.taxAmount.value.text.length,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Included in Item Price',
                            ),
                            Switch(
                              value: taxView.included,
                              onChanged: (value){
                                setState(() {
                                  taxView.setIncluded = !taxView.included;
                                  print(taxView.included);
                                });
                              },
                              activeTrackColor: Colors.lightBlueAccent,
                              activeColor: Colors.blueAccent,
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
      },
    );
  }
}
