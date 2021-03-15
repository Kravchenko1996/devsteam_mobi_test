import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/client.dart';
import 'package:devsteam_mobi_test/widgets/Client/ContactsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientForm extends StatefulWidget {
  final GlobalKey clientFormKey;
  final TextEditingController clientName;
  final TextEditingController clientEmail;
  final Invoice invoice;

  ClientForm({
    Key key,
    this.clientFormKey,
    this.clientName,
    this.clientEmail,
    this.invoice,
  }) : super(key: key);

  @override
  _ClientFormState createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ClientView>(
      builder: (
        BuildContext clientContext,
        ClientView clientView,
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
              child: Form(
                key: widget.clientFormKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Client'),
                        RaisedButton(
                          child: Text('Save'),
                          onPressed: () async {
                            clientView.saveClient(
                              Client(
                                name: widget.clientName.text,
                                email: widget.clientEmail.text.isNotEmpty
                                    ? widget.clientEmail.text
                                    : null,
                              ),
                              context.read<ClientView>().client != null
                                  ? context.read<ClientView>().client.id
                                  : null,
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    Container(
                      child: TextFormField(
                        autofocus: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter client name',
                        ),
                        controller: widget.clientName,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Enter something please!';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        autofocus: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter client email',
                        ),
                        controller: widget.clientEmail,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          onPressed: () {
                            clientView
                                .removeClientFromInvoice(widget.invoice.id);
                            setState(() {
                              widget.clientName.text = '';
                              widget.clientEmail.text = '';
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text('Delete'),
                        ),
                        RaisedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactsScreen(
                                  clientName: widget.clientName,
                                  clientEmail: widget.clientEmail,
                                ),
                              ),
                            );
                          },
                          child: Text('All clients'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
