import 'package:devsteam_mobi_test/viewmodels/PdfView.dart';
import 'package:devsteam_mobi_test/models/EmailCredentials.dart';
import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/client.dart';
import 'package:devsteam_mobi_test/viewmodels/company.dart';
import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/payment.dart';
import 'package:devsteam_mobi_test/viewmodels/photo.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class PdfWidget extends StatefulWidget {
  final Invoice invoice;
  final GlobalKey clientFormKey;
  final TextEditingController clientName;
  final TextEditingController clientEmail;

  const PdfWidget({
    Key key,
    this.invoice,
    this.clientFormKey,
    this.clientName,
    this.clientEmail,
  }) : super(key: key);

  @override
  _PdfWidgetState createState() => _PdfWidgetState();
}

class _PdfWidgetState extends State<PdfWidget> {
  final GlobalKey<State<StatefulWidget>> shareWidget = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext invoiceContext,
        InvoiceView invoiceView,
        Widget child,
      ) {
        return Consumer(
          builder: (
            BuildContext companyContext,
            CompanyView companyView,
            Widget child,
          ) {
            return Consumer(
              builder: (
                BuildContext clientContext,
                ClientView clientView,
                Widget child,
              ) {
                return Consumer(
                  builder: (
                    BuildContext paymentContext,
                    PaymentView paymentView,
                    Widget child,
                  ) {
                    return Consumer(
                      builder: (
                        BuildContext photoContext,
                        PhotoView photoView,
                        Widget child,
                      ) {
                        return Consumer(
                          builder: (
                            BuildContext emailContext,
                            EmailCredentials emailCredentials,
                            Widget child,
                          ) {
                            return Consumer(
                              builder: (
                                BuildContext pdfContext,
                                PdfView pdfView,
                                Widget child,
                              ) {
                                return Scaffold(
                                  appBar: AppBar(
                                    title: Text('Preview'),
                                    centerTitle: true,
                                  ),
                                  body: SafeArea(
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child: pdfView.buildToolBar(
                                            widget.invoice,
                                            emailCredentials,
                                            clientView,
                                            companyView,
                                            widget.clientName,
                                            widget.clientEmail,
                                            widget.clientFormKey,
                                            context,
                                            shareWidget,
                                            invoiceView,
                                            paymentView,
                                            photoView,
                                          ),
                                        ),
                                        Expanded(
                                          child: PdfPreview(
                                            useActions: false,
                                            build: (_) {
                                              return pdfView.generatePdf(
                                                widget.invoice,
                                                companyView,
                                                clientView,
                                                invoiceView,
                                                paymentView,
                                                photoView,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
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
              },
            );
          },
        );
      },
    );
  }
}
