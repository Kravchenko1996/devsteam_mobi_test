import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/widgets/AllClientsScreen.dart';
import 'package:flutter/material.dart';

class ClientForm extends StatefulWidget {
  final TextEditingController clientName;
  final TextEditingController clientEmail;
  final VoidCallback onSave;
  final VoidCallback onRemove;
  final GlobalKey clientFormKey;
  final Client client;

  const ClientForm({
    Key key,
    this.clientName,
    this.clientEmail,
    this.onSave,
    this.onRemove,
    this.clientFormKey,
    this.client,
  }) : super(key: key);

  @override
  _ClientFormState createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  void chooseClientFromList(Client client) {
    setState(() {
      widget.clientName.text = client.name;
      widget.clientEmail.text = client.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.clientFormKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Client'),
              RaisedButton(
                child: Text('Save'),
                onPressed: () {
                  widget.onSave();
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
              validator: (val) {
                if (val.isEmpty) {
                  return 'Enter something please!';
                }
                return null;
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RaisedButton(
                onPressed: () {
                  widget.onRemove();
                },
                child: Text('Delete'),
              ),
              RaisedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllClientsScreen(
                        onChoose: chooseClientFromList,
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
    );
  }
}
