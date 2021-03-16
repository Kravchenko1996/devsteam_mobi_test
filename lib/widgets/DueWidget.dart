import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class DueWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext invoiceContext,
        InvoiceView invoiceView,
        Widget child,
      ) {
        return MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () => showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            context: context,
            builder: (BuildContext context) {
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
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: invoiceView.dueOptions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            invoiceView.selectDueOption(
                              invoiceView.dueOptions[index],
                              context,
                            );
                            if (invoiceView.dueOptions[index] ==
                                invoiceView.dueOptions.last) {
                              final DateTime picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2025),
                              );
                              if (picked != null) {
                                invoiceView.setDueDateByDatePicker(picked);
                              }
                            }
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: invoiceView.dueOptions[index] ==
                                    invoiceView.dueOption
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        invoiceView.dueOptions[index],
                                      ),
                                      Icon(
                                        MdiIcons.check,
                                        size: 20,
                                      ),
                                    ],
                                  )
                                : Text(
                                    invoiceView.dueOptions[index],
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          child: Container(
            child: Text(
              invoiceView.dueOption != null
                  ? invoiceView.dueOption == invoiceView.dueOptions.last
                      ? 'Due by ${DateFormat('MMM d').format(DateTime.parse(invoiceView.dueDate))}'
                      : invoiceView.dueOption
                  : invoiceView.dueOptions.first,
            ),
          ),
        );
      },
    );
  }
}
