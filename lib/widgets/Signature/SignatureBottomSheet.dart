import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:devsteam_mobi_test/widgets/Signature/SignatureScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignatureBottomSheet extends StatelessWidget {
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
              MaterialButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (
                          context,
                          ) {
                        return SignatureScreen();
                      },
                    ),
                  );
                },
                child: Text(
                  'Edit',
                ),
              ),
              MaterialButton(
                onPressed: () {
                  context.read<InvoiceView>().setSignatureImage(null);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Delete',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
