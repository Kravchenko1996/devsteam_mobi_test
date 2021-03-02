import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:flutter/material.dart';

class AllClientsWidget extends StatefulWidget {
  final void Function(Client) onChoose;
  final List<Client> clients;

  const AllClientsWidget({
    Key key,
    this.onChoose,
    this.clients,
  }) : super(key: key);

  @override
  _AllClientsWidgetState createState() => _AllClientsWidgetState();
}

class _AllClientsWidgetState extends State<AllClientsWidget> {
  List<Client> clients = [];

  @override
  void initState() {
    super.initState();
    _getAllClients();
  }

  void _getAllClients() async {
    clients = await DBProvider.db.getAllClients();
    setState(() {
      clients = clients;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: clients.length,
      itemBuilder: (BuildContext context, int index) {
        return Center(
          child: GestureDetector(
            child: Text(
              clients[index].name,
            ),
            onTap: () {
              widget.onChoose(clients[index]);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
