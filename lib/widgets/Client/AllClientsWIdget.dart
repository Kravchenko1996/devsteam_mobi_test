import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/viewmodels/client.dart';
import 'package:devsteam_mobi_test/widgets/Client/ClientFullScreen.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
      clientEmail != null
          ? widget.clientEmail.text = clientEmail
          : widget.clientEmail.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext clientContext,
        ClientView clientView,
        Widget child,
      ) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: widget.clients.length,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.clients[index].name,
                          ),
                          Text(
                            widget.clients[index].email != null
                                ? widget.clients[index].email
                                : 'No email',
                          )
                        ],
                      ),
                      IconButton(
                        onPressed: () async {
                          // Fill controllers with data
                          widget.clientName.text = widget.clients[index].name;
                          widget.clientEmail.text =
                              widget.clients[index].email != null
                                  ? widget.clients[index].email
                                  : '';
                          Client client = await clientView
                              .getClientById(widget.clients[index].id);
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClientFullScreen(
                                clientName: widget.clientName,
                                clientEmail: widget.clientEmail,
                                toEdit: true,
                                client: client,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          MdiIcons.pencil,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    context
                        .read<ClientView>()
                        .selectClient(widget.clients[index]);
                    _setControllers(
                      widget.clients[index].name,
                      widget.clients[index].email,
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
