import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:flutter/material.dart';

class AllClientsWidget extends StatelessWidget {
  final void Function(Client) onChoose;
  final List<Client> clients;

  const AllClientsWidget({
    Key key,
    this.onChoose,
    this.clients,
  }) : super(key: key);

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
              onChoose(clients[index]);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
