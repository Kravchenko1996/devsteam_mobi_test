import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/widgets/Client/ContactsScreen.dart';
import 'package:flutter/material.dart';

class ClientForm extends StatelessWidget {
  final GlobalKey clientFormKey;
  final TextEditingController clientName;
  final TextEditingController clientEmail;
  final VoidCallback onSave;
  final VoidCallback onRemove;
  final void Function(Client) onChoose;

  const ClientForm({
    Key key,
    this.clientFormKey,
    this.clientName,
    this.clientEmail,
    this.onSave,
    this.onRemove,
    this.onChoose,
  }) : super(key: key);

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
          child: Form(
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
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        onRemove();
                      },
                      child: Text('Delete'),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactsScreen(
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
          ),
        ),
      ],
    );
  }
}
