import 'package:contacts_service/contacts_service.dart';
import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/widgets/CenterLoadingIndicator.dart';
import 'package:devsteam_mobi_test/widgets/Client/AllClientsWIdget.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ContactsScreen extends StatefulWidget {
  final void Function(Client) onChoose;

  const ContactsScreen({
    Key key,
    this.onChoose,
  }) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  Iterable<Contact> _contacts;
  List<Client> _clients = [];

  @override
  void initState() {
    super.initState();
    _getContacts();
    _getAllClients();
  }

  Future<void> _getContacts() async {
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  Future _getAllClients() async {
    var clients = await DBProvider.db.getAllClients();
    setState(() {
      _clients = clients;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Clients',
        ),
        centerTitle: true,
      ),
      // ToDo FullClientInfoWidget
      // floatingActionButton: FABWidget(
      //   label: 'Create Client',
      //   route: Container(),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _contacts == null
          ? CenterLoadingIndicator()
          : SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        child: Text('All Clients'),
                      ),
                      AllClientsWidget(
                        clients: _clients,
                        onChoose: widget.onChoose,
                      )
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _contacts?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      Contact contact = _contacts?.elementAt(index);
                      return _buildContact(contact);
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildContact(Contact contact) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 18,
      ),
      leading: (contact.avatar != null && contact.avatar.isNotEmpty)
          ? CircleAvatar(
              backgroundImage: MemoryImage(contact.avatar),
            )
          : CircleAvatar(
              child: Text(contact.initials()),
              backgroundColor: Theme.of(context).accentColor,
            ),
      title: Text(contact.displayName ?? ''),
      trailing: IconButton(
        onPressed: () {
          _createClientFromContact(contact);
        },
        icon: Icon(
          MdiIcons.plus,
        ),
      ),
    );
  }

  void _createClientFromContact(Contact contact) async {
    Client newClient = Client(
      name: contact.displayName,
      email:
          contact.emails.length == 0 ? null : contact.emails.first.toString(),
    );
    await DBProvider.db.upsertClient(newClient, null);
    _getAllClients();
  }
}
