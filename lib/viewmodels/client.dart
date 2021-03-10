import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:flutter/material.dart';

class ClientView with ChangeNotifier {
  Client _client;

  Client get client => _client;
  set setClient(Client value) {
    _client = value;
  }

  void getClientById(int clientId) async {
    var res = await DBProvider.db.getClientById(clientId);
    _client = res;
    notifyListeners();
  }

  void saveClient(
    Client client,
    int clientId,
  ) async {
    var res = await DBProvider.db.upsertClient(
      client,
      clientId,
    );
    _client = res;
    notifyListeners();
    // getClientById(clientId);
  }

  void selectClient(Client selectedClient) {
    _client = selectedClient;
    notifyListeners();
  }

  void removeClientFromInvoice(int invoiceId) async {
    var res = await DBProvider.db.removeClientFromInvoice(invoiceId);
    if (res == null) {
      _client = null;
    }
    notifyListeners();
  }
}
