import 'dart:io';

import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'models/Invoice.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _db;

  Future<Database> get database async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Invoices.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("""
          CREATE TABLE Clients (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT NOT NULL 
      )""");
      await db.execute("""
          CREATE TABLE Invoices (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL UNIQUE,
            client_id INTEGER NOT NULL,
            FOREIGN KEY (client_id) REFERENCES Clients (id)
              ON DELETE NO ACTION ON UPDATE NO ACTION    
      )""");
    });
  }

  Future<Invoice> upsertInvoice(
    Invoice invoice,
    Invoice selectedInvoice,
  ) async {
    final db = await database;
    if (selectedInvoice == null) {
      invoice.id = await db.insert("invoices", invoice.toMap());
    } else {
      invoice.id = selectedInvoice.id;
      await db.update(
        "Invoices",
        invoice.toMap(),
        where: "id = ?",
        whereArgs: [selectedInvoice.id],
      );
    }
    return invoice;
  }

  // Future<Invoice> removeClientFromInvoice(
  //   Invoice invoice,
  //   Invoice selectedInvoice,
  // ) async {
  //   final db = await database;
  //   invoice.id = selectedInvoice.id;
  //   print(invoice.toMap());
  //   var res = await db.update(
  //     "Invoices",
  //     invoice.toMap(),
  //     where: "client_id = ?",
  //     whereArgs: [invoice.clientId],
  //   );
  //   print(invoice.clientId);
  //   return invoice;
  // }

  Future<Client> upsertClient(
    Client client,
    int clientId,
  ) async {
    final db = await database;
    if (clientId == null) {
      client.id = await db.insert("Clients", client.toMap());
    } else {
      client.id = clientId;
      await db.update(
        "Clients",
        client.toMap(),
        where: "id = ?",
        whereArgs: [clientId],
      );
    }
    return client;
  }

  Future<Client> fetchClient(int id) async {
    final db = await database;
    List<Map> res = await db.query(
      "Clients",
      columns: Client.columns,
      where: "id = ?",
      whereArgs: [id],
    );
    Client client = Client.fromMap(res[0]);
    return client;
  }

  Future<Invoice> fetchInvoice(int id) async {
    final db = await database;
    List<Map> res = await db.query(
      "Invoices",
      columns: Invoice.columns,
      where: "id = ?",
      whereArgs: [id],
    );
    Invoice invoice = Invoice.fromMap(res[0]);
    return invoice;
  }

  // Future<Invoice> fetchInvoiceAndClient(int invoiceId) async {
  //   final db = await database;
  //   List<Map> res = await db.query(
  //     "Invoices",
  //     columns: Invoice.columns,
  //     where: "id = ?",
  //     whereArgs: [invoiceId],
  //   );
  //   Invoice invoice = Invoice.fromMap(res[0]);
  //   invoice.client = await fetchClient(invoice.clientId);
  //   return invoice;
  // }

  getAllClients() async {
    final db = await database;
    var res = await db.query("Clients");
    List<Client> clients =
        res.isNotEmpty ? res.map((e) => Client.fromMap(e)).toList() : [];
    return clients;
  }

  getAllInvoices() async {
    final db = await database;
    var res = await db.query("Invoices");
    List<Invoice> invoices =
        res.isNotEmpty ? res.map((e) => Invoice.fromMap(e)).toList() : [];
    return invoices;
  }

  getClientById(int id) async {
    final db = await database;
    var res = await db.query("Clients", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Client.fromMap(res.first) : null;
  }

// getInvoiceById(int id) async {
//   final db = await database;
//   var res = await db.query("Invoices", where: "id = ?", whereArgs: [id]);
//   return res.isNotEmpty ? Invoice.fromMap(res.first) : null;
// }
//

  deleteClientById(int id) async {
    final db = await database;
    db.delete("Clients", where: "id = ?", whereArgs: [id]);
  }
}
