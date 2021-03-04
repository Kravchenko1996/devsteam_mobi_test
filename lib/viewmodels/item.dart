import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Item.dart';
import 'package:flutter/material.dart';

class ItemView with ChangeNotifier {
  Item _item;

  Item get getItem => _item;
  List<Item> _items = [];

  List<Item> get items => _items;

  void saveItem(
    Item item,
    int invoiceId,
  ) async {
    Item res = await DBProvider.db.upsertItem(
      item,
      invoiceId,
    );
    // print('***');
    // print(res.toMap());
    _item = res;
    //ToDo insert invoiceId for new Items
    // var result = _items.firstWhere((element) => element.id == res.id);
    // print(result);
    notifyListeners();
  }

  void addItemToList(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void getAllItems() async {
    await DBProvider.db.getAllItems();
  }
}
