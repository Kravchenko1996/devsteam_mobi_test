import 'package:flutter/material.dart';

class ClientForm extends StatefulWidget {
  final TextEditingController clientName;
  final TextEditingController clientEmail;
  final VoidCallback onSave;

  const ClientForm({
    Key key,
    this.clientName,
    this.clientEmail,
    this.onSave,
  }) : super(key: key);

  @override
  _ClientFormState createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        RaisedButton(
          child: Text('Save'),
          onPressed: () {
            widget.onSave();
          },
        ),
      ],
    );
  }
}
