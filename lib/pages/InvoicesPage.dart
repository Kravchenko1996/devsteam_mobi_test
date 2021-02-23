import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/widgets/CenterLoadingIndicator.dart';
import 'package:devsteam_mobi_test/widgets/FABWidget.dart';
import 'package:devsteam_mobi_test/widgets/NewInvoiceScreen.dart';
import 'package:flutter/material.dart';

class InvoicesPage extends StatefulWidget {
  @override
  _InvoicesPageState createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  List<Invoice> invoices = [];

  @override
  void initState() {
    super.initState();
    getAllInvoices();
  }

  void getAllInvoices() async {
    invoices = await DBProvider.db.getAllInvoices();
    setState(() {
      invoices = invoices;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(invoices.length);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FABWidget(
        label: 'Create invoice',
        route: NewInvoiceScreen(),
      ),
      body: invoices.length == 0
          ? CenterLoadingIndicator()
          : ListView.builder(
              itemCount: invoices.length,
              itemBuilder: (BuildContext context, int index) {
                print('-' * 20);
                print(invoices[index].id);
                return Container(
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          '${invoices[index].clientId}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 40,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          '${invoices[index].name}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
