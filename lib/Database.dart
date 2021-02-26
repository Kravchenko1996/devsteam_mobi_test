import 'dart:io';

import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/models/Item.dart';
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
            total INTEGER,
            client_id INTEGER,
            FOREIGN KEY (client_id) REFERENCES Clients (id)
              ON DELETE NO ACTION ON UPDATE NO ACTION    
      )""");
      await db.execute("""
          CREATE TABLE Items (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            price INTEGER NOT NULL,
            quantity INTEGER NOT NULL,
            amount INTEGER NOT NULL,
            invoice_id INTEGER,
            FOREIGN KEY (invoice_id) REFERENCES Invoices (id)
              ON DELETE NO ACTION ON UPDATE NO ACTION     
      )""");
    });
  }

  //CLIENTS

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

  getAllClients() async {
    final db = await database;
    var res = await db.query("Clients");
    List<Client> clients =
        res.isNotEmpty ? res.map((e) => Client.fromMap(e)).toList() : [];
    return clients;
  }

  getClientById(int id) async {
    final db = await database;
    var res = await db.query("Clients", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Client.fromMap(res.first) : null;
  }

  //INVOICES

  Future<Invoice> upsertInvoice(
    Invoice invoice,
    int clientId,
  ) async {
    print('UPSERT INVOICE');
    print(invoice.toMap());
    print(clientId);
    final db = await database;
    if (invoice.id == null) {
      invoice.id = await db.insert("invoices", invoice.toMap());
    } else {
      invoice.clientId = clientId;
      await db.update(
        "Invoices",
        invoice.toMap(),
        where: "id = ?",
        whereArgs: [invoice.id],
      );
    }
    return invoice;
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

  getAllInvoices() async {
    final db = await database;
    var res = await db.query("Invoices");
    List<Invoice> invoices =
        res.isNotEmpty ? res.map((e) => Invoice.fromMap(e)).toList() : [];
    return invoices;
  }

// ITEMS

  Future<Item> upsertItem(Item item) async {
    final db = await database;
    if (item.id == null) {
      item.id = await db.insert("items", item.toMap());
    } else {
      await db.update(
        "items",
        item.toMap(),
        where: "id = ?",
        whereArgs: [item.id],
      );
    }
    return item;
  }

  getAllItems() async {
    final db = await database;
    var res = await db.query("Items");
    List<Item> items =
        res.isNotEmpty ? res.map((e) => Item.fromMap(e)).toList() : [];
    return items;
  }

  getAllItemsByInvoiceId(int invoiceId) async {
    final db = await database;
    var res = await db.query(
      "Items",
      where: "invoice_id = ?",
      whereArgs: [invoiceId],
    );
    return res.isNotEmpty ? res.map((e) => Item.fromMap(e)).toList() : null;
  }

  getItemById(int id) async {
    final db = await database;
    var res = await db.query(
      "Items",
      where: "id = ?",
      whereArgs: [id],
    );
    return res.isNotEmpty ? Item.fromMap(res.first) : null;
  }
}
