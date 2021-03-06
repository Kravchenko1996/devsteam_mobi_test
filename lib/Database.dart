import 'dart:io';

import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/models/Company.dart';
import 'package:devsteam_mobi_test/models/Discount.dart';
import 'package:devsteam_mobi_test/models/Item.dart';
import 'package:devsteam_mobi_test/models/Payment.dart';
import 'package:devsteam_mobi_test/models/Photo.dart';
import 'package:devsteam_mobi_test/models/Tax.dart';
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
          CREATE TABLE Company (
            id INTEGER PRIMARY KEY,
            logo TEXT,
            name TEXT NOT NULL,
            phone INTEGER,
            mobile INTEGER,
            address TEXT,
            email TEXT,
            website TEXT
      )""");
      await db.execute("""
          CREATE TABLE Clients (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT,
            phone INTEGER,
            mobile INTEGER,
            address1 TEXT,
            address2 TEXT,
            city TEXT,
            state TEXT,
            postal INTEGER,
            country TEXT,
            notes TEXT
      )""");
      await db.execute("""
          CREATE TABLE Invoices (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL UNIQUE,
            total REAL,
            discount REAL,
            date INTEGER,
            due_date TEXT,
            due_option TEXT,
            signature TEXT,
            comment TEXT,
            client_id INTEGER,
            company_id INTEGER,
            FOREIGN KEY (client_id) REFERENCES Clients (id)
              ON DELETE NO ACTION ON UPDATE NO ACTION,
            FOREIGN KEY (company_id) REFERENCES Company (id)
              ON DELETE NO ACTION ON UPDATE NO ACTION    
      )""");
      await db.execute("""
          CREATE TABLE Items (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            price REAL NOT NULL,
            quantity REAL NOT NULL,
            amount REAL NOT NULL,
            invoice_id INTEGER,
            taxable INTEGER,
            discountable INTEGER,
            FOREIGN KEY (invoice_id) REFERENCES Invoices (id)
              ON DELETE NO ACTION ON UPDATE NO ACTION     
      )""");
      await db.execute("""
          CREATE TABLE Payments (
            id INTEGER PRIMARY KEY,
            method TEXT NOT NULL,
            amount REAL NOT NULL,
            invoice_id INTEGER,
            FOREIGN KEY (invoice_id) REFERENCES Invoices (id)
              ON DELETE NO ACTION ON UPDATE NO ACTION  
      )""");
      await db.execute("""
          CREATE TABLE Photos (
            id INTEGER PRIMARY KEY,
            file TEXT NOT NULL,
            invoice_id INTEGER,
            FOREIGN KEY (invoice_id) REFERENCES Invoices (id)
              ON DELETE NO ACTION ON UPDATE NO ACTION  
      )""");
      await db.execute("""
          CREATE TABLE Taxes (
            id INTEGER PRIMARY KEY,
            name TEXT,
            type TEXT,
            amount REAL,
            included INTEGER,
            invoice_id INTEGER,
            item_id INTEGER,
            FOREIGN KEY (invoice_id) REFERENCES Invoices (id)
              ON DELETE NO ACTION ON UPDATE NO ACTION
            FOREIGN KEY (item_id) REFERENCES Items (id)
              ON DELETE NO ACTION ON UPDATE NO ACTION  
      )""");
      await db.execute("""
          CREATE TABLE Discounts (
            id INTEGER PRIMARY KEY,
            percentage REAL,
            amount REAL,
            item_id INTEGER,
            invoice_id INTEGER,
            is_percentage_last INTEGER,
            FOREIGN KEY (item_id) REFERENCES Items (id)
              ON DELETE NO ACTION ON UPDATE NO ACTION
            FOREIGN KEY (invoice_id) REFERENCES Invoices (id)
              ON DELETE NO ACTION ON UPDATE NO ACTION  
      )""");
    });
  }

  // DISCOUNTS

  Future<Discount> upsertDiscount(
    Discount discount,
    int invoiceId,
  ) async {
    final db = await database;
    if (discount.id == null) {
      discount.id = await db.insert(
        "Discounts",
        discount.toMap(),
      );
    } else {
      if (discount.invoiceId == null) {
        discount.invoiceId = invoiceId;
      }
      await db.update(
        "Discounts",
        discount.toMap(),
        where: "id = ?",
        whereArgs: [discount.id],
      );
    }
    return discount;
  }

  getDiscountByItemId(int itemId) async {
    final db = await database;
    var res = await db.query(
      "Discounts",
      where: "item_id = ?",
      whereArgs: [itemId],
    );
    return res.isNotEmpty ? Discount.fromMap(res.first) : null;
  }

  // TAXES

  Future<Tax> upsertTax(
    Tax tax,
    int invoiceId,
  ) async {
    final db = await database;
    if (tax.id == null) {
      tax.id = await db.insert(
        "Taxes",
        tax.toMap(),
      );
    } else {
      if (tax.invoiceId == null) {
        tax.invoiceId = invoiceId;
      }
      await db.update(
        "Taxes",
        tax.toMap(),
        where: "id = ?",
        whereArgs: [tax.id],
      );
    }
    return tax;
  }

  getTaxByInvoiceId(int invoiceId) async {
    final db = await database;
    var res = await db.query(
      "Taxes",
      where: "invoice_id = ?",
      whereArgs: [invoiceId],
    );
    return res.isNotEmpty ? Tax.fromMap(res.first) : null;
  }

  getTaxByItemId(int itemId) async {
    final db = await database;
    var res = await db.query(
      "Taxes",
      where: "item_id = ?",
      whereArgs: [itemId],
    );
    return res.isNotEmpty ? Tax.fromMap(res.first) : null;
  }

  // CLIENTS

  Future<Client> upsertClient(
    Client client,
    int clientId,
  ) async {
    final db = await database;
    if (clientId == null) {
      client.id = await db.insert(
        "Clients",
        client.toMap(),
      );
    } else {
      client.id = clientId;
      await db.update(
        "Clients",
        client.toMap(),
        where: "id = ?",
        whereArgs: [client.id],
      );
    }
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
    var res = await db.query(
      "Clients",
      where: "id = ?",
      whereArgs: [id],
    );
    return res.isNotEmpty ? Client.fromMap(res.first) : null;
  }

  removeClientFromInvoice(int invoiceId) async {
    final db = await database;
    var res = await db.query(
      "Invoices",
      where: "id = ?",
      whereArgs: [invoiceId],
    );
    if (res.isNotEmpty) {
      Invoice invoice = Invoice.fromMap(res.first);
      invoice.clientId = null;
      await db.update(
        "Invoices",
        invoice.toMap(),
        where: "id = ?",
        whereArgs: [invoice.id],
      );
    }
  }

  // INVOICES

  Future<Invoice> upsertInvoice(
    Invoice invoice,
    int clientId,
    double discount,
    double total,
    int date,
    String dueDate,
    String dueOption,
    String signature,
    String comment,
  ) async {
    final db = await database;
    if (invoice.id == null) {
      invoice.id = await db.insert(
        "invoices",
        invoice.toMap(),
      );
    } else {
      invoice.clientId = clientId;
      invoice.discount = discount;
      invoice.total = total;
      invoice.date = date;
      invoice.dueDate = dueDate;
      invoice.dueOption = dueOption;
      invoice.signature = signature;
      invoice.comment = comment;
      await db.update(
        "Invoices",
        invoice.toMap(),
        where: "id = ?",
        whereArgs: [invoice.id],
      );
    }
    return invoice;
  }

  getInvoiceById(int id) async {
    final db = await database;
    var res = await db.query(
      "Invoices",
      where: "id = ?",
      whereArgs: [id],
    );
    return res.isNotEmpty ? Invoice.fromMap(res.first) : null;
  }

  getAllInvoices() async {
    final db = await database;
    var res = await db.query("Invoices");
    List<Invoice> invoices =
        res.isNotEmpty ? res.map((e) => Invoice.fromMap(e)).toList() : [];
    return invoices;
  }

  // ITEMS

  Future<Item> upsertItem(
    Item item,
    int invoiceId,
  ) async {
    final db = await database;
    if (item.id == null) {
      item.id = await db.insert("Items", item.toMap());
    } else {
      if (item.invoiceId == null) {
        item.invoiceId = invoiceId;
      }
      await db.update(
        "Items",
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

  deleteItem(int id) async {
    final db = await database;
    db.delete(
      "Items",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // PAYMENTS

  Future<Payment> upsertPayment(
    Payment payment,
    int invoiceId,
  ) async {
    final db = await database;
    if (payment.id == null) {
      payment.id = await db.insert(
        "Payments",
        payment.toMap(),
      );
    } else {
      if (payment.invoiceId == null) {
        payment.invoiceId = invoiceId;
      }
      await db.update(
        "Payments",
        payment.toMap(),
        where: "id = ?",
        whereArgs: [payment.id],
      );
    }
    return payment;
  }

  Future<List<Payment>> getAllPayments() async {
    final db = await database;
    var res = await db.query("Payments");
    List<Payment> payments =
        res.isNotEmpty ? res.map((e) => Payment.fromMap(e)).toList() : [];
    return payments;
  }

  getAllPaymentsByInvoiceId(int invoiceId) async {
    final db = await database;
    var res = await db.query(
      "Payments",
      where: "invoice_id = ?",
      whereArgs: [invoiceId],
    );
    return res.isNotEmpty ? res.map((e) => Payment.fromMap(e)).toList() : null;
  }

  deletePayment(int id) async {
    final db = await database;
    db.delete(
      "Payments",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // PHOTOS

  Future<Photo> upsertPhoto(Photo photo) async {
    final db = await database;
    if (photo.id == null) {
      photo.id = await db.insert(
        "Photos",
        photo.toMap(),
      );
    }
    return photo;
  }

  getAllPhotosByInvoiceId(int invoiceId) async {
    final db = await database;
    var res = await db.query(
      "Photos",
      where: "invoice_id = ?",
      whereArgs: [invoiceId],
    );
    return res.isNotEmpty ? res.map((e) => Photo.fromMap(e)).toList() : null;
  }

  deletePhoto(int id) async {
    final db = await database;
    db.delete(
      "Photos",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // COMPANY

  Future<Company> upsertCompany(Company company) async {
    final db = await database;
    if (company.id == null) {
      company.id = await db.insert(
        "Company",
        company.toMap(),
      );
    } else {
      await db.update(
        "Company",
        company.toMap(),
        where: "id = ?",
        whereArgs: [company.id],
      );
    }
    getAllCompanies();
    return company;
  }

  getCompanyById(int id) async {
    final db = await database;
    var res = await db.query(
      "Company",
      where: "id = ?",
      whereArgs: [id],
    );
    return res.isNotEmpty ? Company.fromMap(res.first) : null;
  }

  getAllCompanies() async {
    final db = await database;
    var res = await db.query("Company");
    List<Company> companies =
        res.isNotEmpty ? res.map((e) => Company.fromMap(e)).toList() : [];
    return companies;
  }
}
