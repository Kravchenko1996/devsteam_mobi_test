import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Discount.dart';
import 'package:flutter/material.dart';

class DiscountView with ChangeNotifier {
  Discount _discount;

  Discount get discount => _discount;

  bool _isPercentageLast = false;

  bool get isPercentageLast => _isPercentageLast;

  set setIsPercentageLast(bool value) => _isPercentageLast = value;

  void saveDiscount(
    Discount discount,
    int invoiceId,
  ) async {
    Discount res = await DBProvider.db.upsertDiscount(
      discount,
      invoiceId,
    );
    _discount = res;
    notifyListeners();
  }

  void getDiscountByItemId(int itemId) async {
    Discount res = await DBProvider.db.getDiscountByItemId(itemId);
    if (res != null) {
      _isPercentageLast = res.isPercentageLast == 1 ? true : false;
      _discount = res;
    }
    notifyListeners();
  }
}
