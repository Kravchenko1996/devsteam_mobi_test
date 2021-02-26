import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/models/Item.dart';
import 'package:devsteam_mobi_test/widgets/CenterLoadingIndicator.dart';
import 'package:devsteam_mobi_test/widgets/FABWidget.dart';
import 'package:devsteam_mobi_test/widgets/InvoiceScreen.dart';
import 'package:flutter/material.dart';

class InvoicesPage extends StatefulWidget {
  @override
  _InvoicesPageState createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  Future _getAllInvoices() async {
    return await DBProvider.db.getAllInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FABWidget(
        label: 'Create invoice',
        route: InvoiceScreen(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: FutureBuilder(
            future: _getAllInvoices(),
            builder:
                (BuildContext context, AsyncSnapshot<dynamic> projectSnap) {
              if (projectSnap.connectionState == ConnectionState.none &&
                  projectSnap.hasData == null) {
                return Container();
              }
              return projectSnap.data == null
                  ? CenterLoadingIndicator()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: projectSnap.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InvoiceScreen(
                                  invoice: projectSnap.data[index],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: Column(
                                children: [
                                  _buildClientInfo(
                                      projectSnap.data[index].clientId),
                                  Center(
                                    child: Text(
                                      '${projectSnap.data[index].name}',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  _buildItemsInfo(projectSnap.data[index].id),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
            },
          ),
        ),
      ),
    );
  }

  Future<Client> _getClientById(int clientId) async {
    return await DBProvider.db.getClientById(clientId);
  }

  Widget _buildClientInfo(int clientId) {
    return FutureBuilder(
      future: _getClientById(clientId),
      builder: (BuildContext context, AsyncSnapshot<Client> snapshot) {
        return Text(
          snapshot.data == null ? 'No client' : '${snapshot.data.name}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }

  Future<List<Item>> _getAllItemsByInvoiceId(int invoiceId) async {
    return await DBProvider.db.getAllItemsByInvoiceId(invoiceId);
  }

  Widget _buildItemsInfo(int invoiceId) {
    return FutureBuilder(
      future: _getAllItemsByInvoiceId(invoiceId),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.data == null
            ? Text('No items')
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Container(
                      child: Text(
                        snapshot.data[index].title,
                      ),
                    ),
                  );
                },
              );
      },
    );
  }
}
