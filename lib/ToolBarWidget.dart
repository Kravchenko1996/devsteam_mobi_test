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
    PdfPageFormat format,
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
        pageFormat: format,
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

  Future<void> share(GlobalKey shareWidget) async {
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
      filename: 'toChange.pdf',
    );
  }

  Future<void> printFile(PdfPageFormat pageFormat) async {
    await Printing.layoutPdf(
      onLayout: (_) => _pdf,
      name: 'Document',
      format: pageFormat,
    );
  }

  Future<void> sendEmail(
    Invoice invoice,
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
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/example.pdf");
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
    PdfPageFormat pageFormat,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          child: Column(
            children: [
              Icon(MdiIcons.send),
              Text('Send'),
            ],
          ),
          onTap: () async {
            final PermissionStatus permissionStatus = await _getPermission();
            if (permissionStatus == PermissionStatus.granted) {
              sendEmail(
                invoice,
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
          ),
        ),
        GestureDetector(
          child: Column(
            children: [
              Icon(MdiIcons.printer),
              Text('Print'),
            ],
          ),
          onTap: () => printFile(
            pageFormat,
          ),
        ),
      ],
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
