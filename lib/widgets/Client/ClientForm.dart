import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/widgets/Client/AllClientsScreen.dart';
import 'package:flutter/material.dart';

class ClientForm extends StatelessWidget {
  final GlobalKey clientFormKey;
  final TextEditingController clientName;
  final TextEditingController clientEmail;
  final VoidCallback onSave;
  final VoidCallback onRemove;
  final Client client;
  final void Function(Client) onChoose;

  const ClientForm({
    Key key,
    this.clientName,
    this.clientEmail,
    this.onSave,
    this.onRemove,
    this.clientFormKey,
    this.client,
    this.onChoose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: clientFormKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Client'),
              RaisedButton(
                child: Text('Save'),
                onPressed: () {
                  onSave();
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
              controller: clientName,
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
              controller: clientEmail,
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
                  // onRemove();
                },
                child: Text('Delete'),
              ),
              RaisedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllClientsScreen(
                        onChoose: onChoose,
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
