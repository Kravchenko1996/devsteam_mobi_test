import 'dart:convert';

import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:devsteam_mobi_test/widgets/Signature/SignatureBottomSheet.dart';
import 'package:devsteam_mobi_test/widgets/Signature/SignatureScreen.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SignatureWidget extends StatelessWidget {
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
          onPressed: () async {
            if (invoiceView.signature != null) {
              showModalBottomSheet(
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                context: context,
                builder: (BuildContext context) {
                  return SignatureBottomSheet();
                },
              );
            } else {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (
                    context,
                  ) =>
                      SignatureScreen(),
                  settings: RouteSettings(
                    name: 'SignatureScreen',
                  ),
                ),
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    MdiIcons.signatureFreehand,
                    color: Colors.grey,
                    size: 30,
                  ),
                  Text(
                    invoiceView.signature != null ? 'Signed' : 'Signature',
                  ),
                ],
              ),
              invoiceView.signature != null
                  ? Image.memory(
                      base64Decode(invoiceView.signature),
                      height: 75,
                      width: 75,
                      color: Colors.black,
                      fit: BoxFit.fitHeight,
                    )
                  : Container()
            ],
          ),
        );
      },
    );
  }
}
