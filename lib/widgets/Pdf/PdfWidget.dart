import 'package:devsteam_mobi_test/ToolBarWidget.dart';
import 'package:devsteam_mobi_test/models/EmailCredentials.dart';
import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/client.dart';
import 'package:devsteam_mobi_test/viewmodels/company.dart';
import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/payment.dart';
import 'package:devsteam_mobi_test/viewmodels/photo.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class PdfWidget extends StatefulWidget {
  final Invoice invoice;
  final GlobalKey clientFormKey;
  final TextEditingController clientName;
  final TextEditingController clientEmail;
  final GlobalKey shareWidget;

  const PdfWidget({
    Key key,
    this.invoice,
    this.clientFormKey,
    this.clientName,
    this.clientEmail,
    this.shareWidget,
  }) : super(key: key);

  @override
  _PdfWidgetState createState() => _PdfWidgetState();
}

class _PdfWidgetState extends State<PdfWidget> {
  PdfPageFormat pageFormat;
  SendReport sendReport;

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
                                            widget.shareWidget,
                                            pageFormat,
                                          ),
                                        ),
                                        Expanded(
                                          child: PdfPreview(
                                            useActions: false,
                                            build: (format) {
                                              pageFormat = format;
                                              return pdfView.generatePdf(
                                                pageFormat,
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
