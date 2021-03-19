import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Item.dart';
import 'package:flutter/material.dart';

class ItemView with ChangeNotifier {
  Item _item;

  Item get item => _item;

  set setItem(Item value) => _item = value;

  final GlobalKey<FormState> _itemFormKey = GlobalKey<FormState>();

  GlobalKey<FormState> get itemFormKey => _itemFormKey;

  bool _taxable = false;

  bool get taxable => _taxable;

  set setTaxable(bool value) => _taxable = value;

  bool _discountable = false;

  bool get discountable => _discountable;

  set setDiscountable(bool value) => _discountable = value;

  bool _btnEnabled = false;

  bool get btnEnabled => _btnEnabled;

  set setBtnEnabled(bool value) => _btnEnabled = value;

  void enableBtn() {
    _btnEnabled = _itemFormKey.currentState.validate();
    notifyListeners();
  }

  void switchTaxable() {
    _taxable = !_taxable;
    notifyListeners();
  }

  void switchDiscount() {
    _discountable = !_discountable;
    notifyListeners();
  }

  Future<Item> saveItem(
    Item item,
    int invoiceId,
  ) async {
    Item res = await DBProvider.db.upsertItem(
      item,
      invoiceId,
    );
    return res;
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
