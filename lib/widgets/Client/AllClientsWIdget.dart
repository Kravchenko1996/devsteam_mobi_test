import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/viewmodels/client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllClientsWidget extends StatefulWidget {
  final GlobalKey clientFormKey;
  final TextEditingController clientName;
  final TextEditingController clientEmail;
  final List<Client> clients;

  const AllClientsWidget({
    Key key,
    this.clientFormKey,
    this.clientName,
    this.clientEmail,
    this.clients,
  }) : super(key: key);

  @override
  _AllClientsWidgetState createState() => _AllClientsWidgetState();
}

class _AllClientsWidgetState extends State<AllClientsWidget> {
  void _setControllers(
    String clientName,
    String clientEmail,
  ) {
    setState(() {
      widget.clientName.text = clientName;
      widget.clientEmail.text = clientEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.clients.length,
      itemBuilder: (BuildContext context, int index) {
        return Center(
          child: GestureDetector(
            child: Text(
              widget.clients[index].name,
            ),
            onTap: () {
              context.read<ClientView>().selectClient(widget.clients[index]);
              _setControllers(
                widget.clients[index].name,
                widget.clients[index].email,
              );
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
