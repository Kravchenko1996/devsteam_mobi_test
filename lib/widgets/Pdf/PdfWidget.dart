import 'dart:typed_data';

import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/client.dart';
import 'package:devsteam_mobi_test/viewmodels/company.dart';
import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/payment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class PdfWidget extends StatefulWidget {
  final Invoice invoice;

  const PdfWidget({
    Key key,
    this.invoice,
  }) : super(key: key);

  @override
  _PdfWidgetState createState() => _PdfWidgetState();
}

class _PdfWidgetState extends State<PdfWidget> {
  final GlobalKey<State<StatefulWidget>> shareWidget = GlobalKey();
  var pageFormat;

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
    Invoice invoice,
    CompanyView companyView,
    ClientView clientView,
    InvoiceView invoiceView,
    PaymentView paymentView,
  ) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Row(
                children: [
                  pw.Text(invoice.name),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Issued ${_formatDate(
                      DateTime.fromMillisecondsSinceEpoch(
                        invoice.date,
                      ),
                    )}',
                  ),
                  pw.Text(
                    'Due ${_formatDate(
                      DateTime.parse(
                        invoice.dueDate,
                      ),
                    )}',
                  ),
                ],
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('From'),
                  pw.Text('To'),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(companyView.company.name),
                  pw.Text(clientView.client.name),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Email',
                  ),
                  pw.Text(clientView.client.email ?? '  No email')
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Description'),
                  pw.Text('Quantity'),
                  pw.Text('Rate'),
                  pw.Text('Amount'),
                ],
              ),
              pw.Divider(),
              invoiceView.itemsOfInvoice.length != 0
                  ? pw.ListView.builder(
                      itemCount: invoiceView.itemsOfInvoice.length,
                      itemBuilder: (context, int index) {
                        return pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(invoiceView.itemsOfInvoice[index].title),
                            pw.Text(
                              invoiceView.itemsOfInvoice[index].quantity
                                  .toString(),
                            ),
                            pw.Text(
                              invoiceView.itemsOfInvoice[index].price
                                  .toString(),
                            ),
                            pw.Text(
                              invoiceView.itemsOfInvoice[index].amount
                                  .toString(),
                            ),
                          ],
                        );
                      })
                  : pw.Container(),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Subtotal'),
                  pw.Text(
                    invoiceView.subTotal.toString(),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Discount (${invoiceView.discount.toString()}%)'),
                  pw.Text(
                    invoiceView.difference.toString(),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total'),
                  pw.Text(
                    invoiceView.total.toString(),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Paid'),
                  pw.Text(
                    paymentView.paymentsSum.toString(),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Balance due'),
                  pw.Text(
                    (invoiceView.total - paymentView.paymentsSum).toString(),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
    return doc.save();
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('MMM d, y').format(dateTime);
  }

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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    child: Column(
                                      children: [
                                        Icon(MdiIcons.shareVariantOutline),
                                        Text('Share'),
                                      ],
                                    ),
                                    key: shareWidget,
                                    onTap: () => _share(
                                      pageFormat,
                                      widget.invoice,
                                      companyView,
                                      clientView,
                                      invoiceView,
                                      paymentView,
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Column(
                                      children: [
                                        Icon(MdiIcons.printer),
                                        Text('Print'),
                                      ],
                                    ),
                                    onTap: () => _print(
                                      pageFormat,
                                      widget.invoice,
                                      companyView,
                                      clientView,
                                      invoiceView,
                                      paymentView,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: PdfPreview(
                                useActions: false,
                                build: (format) {
                                  pageFormat = format;
                                  return _generatePdf(
                                    format,
                                    widget.invoice,
                                    companyView,
                                    clientView,
                                    invoiceView,
                                    paymentView,
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
  }

  Future<void> _share(
    pageFormat,
    Invoice invoice,
    companyView,
    clientView,
    invoiceView,
    paymentView,
  ) async {
    // Calculate the widget center for iPad sharing popup position
    final RenderBox referenceBox =
        shareWidget.currentContext.findRenderObject();
    final topLeft =
        referenceBox.localToGlobal(referenceBox.paintBounds.topLeft);
    final bottomRight =
        referenceBox.localToGlobal(referenceBox.paintBounds.bottomRight);
    final bounds = Rect.fromPoints(topLeft, bottomRight);

    print(_generatePdf(
      pageFormat,
      invoice,
      companyView,
      clientView,
      invoiceView,
      paymentView,
    ));
    final bytes = await _generatePdf(
      pageFormat,
      invoice,
      companyView,
      clientView,
      invoiceView,
      paymentView,
    );
    await Printing.sharePdf(
      bytes: bytes,
      bounds: bounds,
      filename: 'toChange.pdf',
    );
  }

  Future<void> _print(
    pageFormat,
    Invoice invoice,
    companyView,
    clientView,
    invoiceView,
    paymentView,
  ) async {
    final bytes = _generatePdf(
      pageFormat,
      invoice,
      companyView,
      clientView,
      invoiceView,
      paymentView,
    );
    print(bytes.runtimeType);

    await Printing.layoutPdf(
      onLayout: (_) => _generatePdf(
        pageFormat,
        invoice,
        companyView,
        clientView,
        invoiceView,
        paymentView,
      ),
      name: 'Document',
      format: pageFormat,
    );
  }
}
