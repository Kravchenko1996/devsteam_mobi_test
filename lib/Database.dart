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
            name TEXT NOT NULL,
            client_id INTEGER NOT NULL,
            FOREIGN KEY (client_id) REFERENCES Clients (id)
              ON DELETE NO ACTION ON UPDATE NO ACTION    
      )""");
    });
  }

  Future<Invoice> upsertInvoice(Invoice invoice) async {
    final db = await database;
    if (invoice.id == null) {
      invoice.id = await db.insert("invoices", invoice.toMap());
    } else {
      await db.update(
        "invoices",
        invoice.toMap(),
        where: "id = ?",
        whereArgs: [invoice.id],
      );
    }
    return invoice;
  }

  Future<Client> upsertClient(Client client) async {
    final db = await database;

    if (client.id == null) {
      client.id = await db.insert("Clients", client.toMap());
    } else {
      await db.update(
        "Clients",
        client.toMap(),
        where: "id = ?",
        whereArgs: [client.id],
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

  Future<List<Invoice>> fetchLatestInvoices(int limit) async {
    final db = await database;
    List<Map> res = await db.query(
      "Clients",
      columns: Invoice.columns,
      limit: limit,
      orderBy: "id DESC",
    );
    List<Invoice> invoices = List();
    res.forEach((element) {
      Invoice invoice = Invoice.fromMap(element);
      invoices.add(invoice);
    });
    return invoices;
  }

  Future<Client> fetchClientAndInvoice(int clientId) async {
    final db = await database;
    List<Map> res = await db.query(
      "Clients",
      columns: Client.columns,
      where: "id = ?",
      whereArgs: [clientId],
    );
    Client client = Client.fromMap(res[0]);
    // client.invoiceId = await fetchInvoice(client.invoice_id);
    return client;
  }

  // newInvoice(Invoice newInvoice) async {
  //   final db = await database;
  //   var res = await db.rawInsert("INSERT Into Invoices (name, client, item)"
  //       "VALUES (${newInvoice.name}, ${newInvoice.client}, ${newInvoice.item})");
  //   return res;
  // }

  // newClient(Client newClient) async {
  //   final db = await database;
  //   var res = await db.rawInsert("INSERT Into Clients (name,email)"
  //       "VALUES (${newClient.name},${newClient.email})");
  //   return res;
  // }

  // newClient(Client newClient) async {
  //   var res = await _db.insert("Clients", newClient.toMap());
  //   return res;
  // }
  //
  getAllClients() async {
    final db = await database;
    var res = await db.query("Clients");
    List<Client> clients =
        res.isNotEmpty ? res.map((e) => Client.fromMap(e)).toList() : [];
    print(clients);
    return clients;
  }

  //
  // getClientById(int id) async {
  //   var res = await _db.query("Invoices", where: "id = ?", whereArgs: [id]);
  //   return res.isNotEmpty ? Invoice.fromMap(res.first) : null;
  // }
  //
  // newInvoice(Invoice newInvoice) async {
  //   var res = await _db.insert("Invoices", newInvoice.toMap());
  //   return res;
  // }

// getInvoiceById(int id) async {
//   final db = await database;
//   var res = await db.query("Invoices", where: "id = ?", whereArgs: [id]);
//   return res.isNotEmpty ? Invoice.fromMap(res.first) : null;
// }
//
  getAllInvoices() async {
    final db = await database;
    var res = await db.query("Invoices");
    List<Invoice> invoices =
        res.isNotEmpty ? res.map((e) => Invoice.fromMap(e)).toList() : [];
    return invoices;
  }
//
// deleteInvoiceById(int id) async {
//   final db = await database;
//   db.delete("Invoices", where: "id = ?", whereArgs: [id]);
// }
}
