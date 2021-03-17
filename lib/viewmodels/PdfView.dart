import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:devsteam_mobi_test/models/EmailCredentials.dart';
import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/client.dart';
import 'package:devsteam_mobi_test/viewmodels/company.dart';
import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/payment.dart';
import 'package:devsteam_mobi_test/viewmodels/photo.dart';
import 'package:devsteam_mobi_test/widgets/Client/ClientForm.dart';
import 'package:devsteam_mobi_test/widgets/Payment/PaymentModal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';

class PdfView with ChangeNotifier {
  Future<Uint8List> _pdf;

  Future<Uint8List> get pdf => _pdf;

  Future<Uint8List> generatePdf(
    Invoice invoice,
    CompanyView companyView,
    ClientView clientView,
    InvoiceView invoiceView,
    PaymentView paymentView,
    PhotoView photoView,
  ) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Row(
                children: [
                  pw.Text(invoice.name),
                ],
              ),
              _buildSbRow(
                invoice.date != null
                    ? 'Issued ${_formatDate(
                        DateTime.fromMillisecondsSinceEpoch(
                          invoice.date,
                        ),
                      )}'
                    : '',
                invoice.dueDate != 'Due on receipt'
                    ? 'Due ${_formatDate(
                        DateTime.parse(
                          invoice.dueDate,
                        ),
                      )}'
                    : 'Due on receipt',
              ),
              pw.Divider(),
              _buildSbRow(
                'From',
                'To',
              ),
              _buildSbRow(
                companyView.company.name,
                clientView.client != null ? clientView.client.name : '',
              ),
              _buildSbRow(
                'Email',
                clientView.client != null && clientView.client.email != null
                    ? clientView.client.email
                    : 'No email',
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
              _buildSbRow(
                'Subtotal',
                invoiceView.subTotal.toString(),
              ),
              _buildSbRow(
                'Discount (${invoiceView.discount.toString()}%)',
                invoiceView.difference.toString(),
              ),
              _buildSbRow(
                'Total',
                invoiceView.total.toString(),
              ),
              _buildSbRow(
                'Paid',
                paymentView.paymentsSum.toString(),
              ),
              _buildSbRow(
                'Balance due',
                (invoiceView.total - paymentView.paymentsSum).toString(),
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(invoice.comment ?? ''),
                  invoiceView.signature != null
                      ? pw.Container(
                          height: 100,
                          width: 100,
                          child: _buildImage(invoiceView.signature),
                        )
                      : pw.Container(),
                ],
              ),
              photoView.photosOfInvoice.length != 0
                  ? pw.Expanded(
                      child: pw.GridView(
                        crossAxisCount: 4,
                        children: List.generate(
                          photoView.photosOfInvoice.length,
                          (index) => pw.Container(
                            margin: pw.EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: _buildImage(
                              photoView.photosOfInvoice[index].file,
                            ),
                          ),
                        ),
                      ),
                    )
                  : pw.Container(),
            ],
          );
        },
      ),
    );
    _pdf = doc.save();
    return _pdf;
  }

  pw.Widget _buildImage(String path) {
    return pw.Image(
      pw.MemoryImage(
        base64Decode(path),
      ),
    );
  }

  pw.Widget _buildSbRow(
    String textOne,
    String textTwo,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(textOne),
        pw.Text(textTwo),
      ],
    );
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('MMM d, y').format(dateTime);
  }

  Future<void> share(
    GlobalKey shareWidget,
    Invoice invoice,
    InvoiceView invoiceView,
    PaymentView paymentView,
    PhotoView photoView,
    ClientView clientView,
    CompanyView companyView,
  ) async {
    generatePdf(
      invoice,
      companyView,
      clientView,
      invoiceView,
      paymentView,
      photoView,
    );
    // Calculate the widget center for iPad sharing popup position
    final RenderBox referenceBox =
        shareWidget.currentContext.findRenderObject();
    final topLeft =
        referenceBox.localToGlobal(referenceBox.paintBounds.topLeft);
    final bottomRight =
        referenceBox.localToGlobal(referenceBox.paintBounds.bottomRight);
    final bounds = Rect.fromPoints(topLeft, bottomRight);
    await Printing.sharePdf(
      bytes: await _pdf,
      bounds: bounds,
      filename: '${invoice.name}.pdf',
    );
  }

  Future<void> printFile(
    Invoice invoice,
    InvoiceView invoiceView,
    PaymentView paymentView,
    PhotoView photoView,
    ClientView clientView,
    CompanyView companyView,
  ) async {
    generatePdf(
      invoice,
      companyView,
      clientView,
      invoiceView,
      paymentView,
      photoView,
    );
    await Printing.layoutPdf(
      onLayout: (_) => _pdf,
      name: '${invoice.name}.pdf',
      format: PdfPageFormat.a4,
    );
  }

  Future<void> sendEmail(
    Invoice invoice,
    InvoiceView invoiceView,
    PaymentView paymentView,
    PhotoView photoView,
    EmailCredentials emailCredentials,
    ClientView clientView,
    CompanyView companyView,
    TextEditingController clientName,
    TextEditingController clientEmail,
    GlobalKey clientFormKey,
    context,
  ) async {
    if (clientView.client.email == null) {
      clientName.text = clientView.client.name;
      clientEmail.text = clientView.client.email;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              "Please specify the client's email address",
              textAlign: TextAlign.center,
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    context: context,
                    builder: (BuildContext context) {
                      return ClientForm(
                        clientFormKey: clientFormKey,
                        clientName: clientName,
                        clientEmail: clientEmail,
                        invoice: invoice,
                      );
                    },
                  );
                },
                child: Text(
                  'Add email',
                ),
              ),
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                ),
              )
            ],
          );
        },
      );
    } else {
      generatePdf(
        invoice,
        companyView,
        clientView,
        invoiceView,
        paymentView,
        photoView,
      );
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/${invoice.name}.pdf");
      await file.writeAsBytes(
        await _pdf,
      );
      final smtpServer = SmtpServer(
        'smtp.gmail.com',
        username: emailCredentials.username,
        password: emailCredentials.password,
      );
      final message = Message()
        ..from = Address(emailCredentials.username, companyView.company.name)
        ..recipients.add(clientView.client.email)
        ..subject = invoice.name
        ..text = 'Hello, ${clientView.client.name},'
            '\nPlease find ${invoice.name} for ${invoice.total} from ${companyView.company.name}.'
            '\nRegards,\n${companyView.company.name}'
        ..attachments.add(
          FileAttachment(file),
        );

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
        showDialog(
          context: context,
          builder: (
            BuildContext context,
          ) {
            return AlertDialog(
              content: Text(
                'Message sent successfully',
              ),
              actions: [
                MaterialButton(
                  child: Text(
                    'Okay',
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
        print(e.message);
      }
    }
  }

  Widget buildToolBar(
    Invoice invoice,
    EmailCredentials emailCredentials,
    ClientView clientView,
    CompanyView companyView,
    TextEditingController clientName,
    TextEditingController clientEmail,
    GlobalKey clientFormKey,
    context,
    GlobalKey shareWidget,
    InvoiceView invoiceView,
    PaymentView paymentView,
    PhotoView photoView,
  ) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: clientView.client != null && invoiceView.itemsOfInvoice.length != 0
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Column(
                    children: [
                      Icon(MdiIcons.send),
                      Text('Send'),
                    ],
                  ),
                  onTap: () async {
                    final PermissionStatus permissionStatus =
                        await _getPermission();
                    if (permissionStatus == PermissionStatus.granted) {
                      sendEmail(
                        invoice,
                        invoiceView,
                        paymentView,
                        photoView,
                        emailCredentials,
                        clientView,
                        companyView,
                        clientName,
                        clientEmail,
                        clientFormKey,
                        context,
                      );
                    } else {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            child: Text(
                              'No permission',
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Column(
                    children: [
                      Icon(
                        MdiIcons.shareVariantOutline,
                      ),
                      Text('Share'),
                    ],
                  ),
                  key: shareWidget,
                  onTap: () => share(
                    shareWidget,
                    invoice,
                    invoiceView,
                    paymentView,
                    photoView,
                    clientView,
                    companyView,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Column(
                    children: [Icon(MdiIcons.creditCard), Text('Mark paid')],
                  ),
                  onTap: () => showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    context: context,
                    builder: (BuildContext context) {
                      return PaymentModal(
                        // paymentFormKey: _paymentFormKey,
                        // paymentMethod: _paymentMethodController,
                        // paymentAmount: _paymentAmountController,
                        toCreate: true,
                      );
                    },
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Column(
                    children: [
                      Icon(MdiIcons.printer),
                      Text('Print'),
                    ],
                  ),
                  onTap: () => printFile(
                    invoice,
                    invoiceView,
                    paymentView,
                    photoView,
                    clientView,
                    companyView,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Icon(
                      MdiIcons.send,
                      color: Colors.grey,
                    ),
                    Text(
                      'Send',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      MdiIcons.shareVariantOutline,
                      color: Colors.grey,
                    ),
                    Text(
                      'Send',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      MdiIcons.creditCard,
                      color: Colors.grey,
                    ),
                    Text(
                      'Mark paid',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      MdiIcons.printer,
                      color: Colors.grey,
                    ),
                    Text(
                      'Print',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.storage.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.storage].request();
      return permissionStatus[Permission.storage] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }
}
