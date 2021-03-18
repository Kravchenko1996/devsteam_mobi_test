import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Item.dart';
import 'package:flutter/material.dart';

class ItemView with ChangeNotifier {
  Item _item;

  Item get item => _item;

  set setItem(Item value) => _item = value;

  bool _taxable = false;

  bool get taxable => _taxable;

  set setTaxable(bool value) => _taxable = value;

  void saveItem(
    Item item,
    int invoiceId,
  ) async {
    Item res = await DBProvider.db.upsertItem(
      item,
      invoiceId,
    );
    _item = res;
    notifyListeners();
  }

  void selectItemFromList(Item selectedItem) {
    _item = selectedItem;
    notifyListeners();
  }

  void deleteItem(int itemId) async {
    await DBProvider.db.deleteItem(itemId);
  }

  void getItemById(int itemId) async {
    Item res = await DBProvider.db.getItemById(itemId);
    _item = res;
    notifyListeners();
  }
}
