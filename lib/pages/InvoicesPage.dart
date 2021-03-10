import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/models/Item.dart';
import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:devsteam_mobi_test/widgets/CenterLoadingIndicator.dart';
import 'package:devsteam_mobi_test/widgets/FABWidget.dart';
import 'package:devsteam_mobi_test/widgets/InvoiceScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvoicesPage extends StatefulWidget {
  @override
  _InvoicesPageState createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<InvoiceView>(context, listen: false).getAllInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FABWidget(
        label: 'invoice',
        route: InvoiceScreen(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Consumer<InvoiceView>(
            builder: (
              BuildContext invoiceContext,
              InvoiceView invoiceView,
              Widget child,
            ) {
              return invoiceView.invoices == null
                  ? CenterLoadingIndicator()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: invoiceView.invoices.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InvoiceScreen(
                                  invoice: invoiceView.invoices[index],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Column(
                              children: [
                                _buildClientInfo(
                                    invoiceView.invoices[index].clientId),
                                Center(
                                  child: Text(
                                    '${invoiceView.invoices[index].name}',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                _buildItemsInfo(invoiceView.invoices[index].id),
                              ],
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
    return clientId != null
        ? await DBProvider.db.getClientById(clientId)
        : null;
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
