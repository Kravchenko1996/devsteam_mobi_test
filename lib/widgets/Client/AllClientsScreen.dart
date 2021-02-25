import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/widgets/CenterLoadingIndicator.dart';
import 'package:flutter/material.dart';

class AllClientsScreen extends StatefulWidget {
  final void Function(Client) onChoose;

  const AllClientsScreen({
    Key key,
    this.onChoose,
  }) : super(key: key);

  @override
  _AllClientsScreenState createState() => _AllClientsScreenState();
}

class _AllClientsScreenState extends State<AllClientsScreen> {
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
    return Scaffold(
      appBar: AppBar(),
      body: clients.length == 0
          ? CenterLoadingIndicator()
          : ListView.builder(
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
            ),
    );
  }
}
