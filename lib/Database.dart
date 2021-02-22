import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'models/Invoice.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Invoices ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "client TEXT,"
          "item TEXT,"
          ")");
    });
  }

  newInvoice(Invoice newInvoice) async {
    final db = await database;
    var res = await db.rawInsert("INSERT Into Invoices (name, client, item)"
        "VALUES (${newInvoice.name}, ${newInvoice.client}, ${newInvoice.item})");
    return res;
  }

  // newInvoice(Invoice newInvoice) async {
  //   final db = await database;
  //   var res = await db.insert("Invoices", newInvoice.toMap());
  //   return res;
  // }

  getInvoiceById(int id) async {
    final db = await database;
    var res = await db.query("Invoices", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Invoice.fromMap(res.first) : null;
  }

  getAllInvoices() async {
    final db = await database;
    var res = await db.query("Invoices");
    List<Invoice> list =
        res.isNotEmpty ? res.map((e) => Invoice.fromMap(e)).toList() : [];
    return list;
  }

  deleteInvoiceById(int id) async {
    final db = await database;
    db.delete("Invoices", where: "id = ?", whereArgs: [id]);
  }
}
