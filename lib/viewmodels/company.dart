import 'dart:io';

import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Company.dart';
import 'package:flutter/material.dart';

class CompanyView with ChangeNotifier {
  File _logo;

  File get logo => _logo;

  set setLogo(File value) {
    _logo = value;
  }

  Company _company;

  Company get company => _company;

  set setCompany(Company value) {
    _company = value;
  }

  void chooseLogo(File image) async {
    _logo = image;
    notifyListeners();
  }

  void saveCompany(Company company) async {
    Company res = await DBProvider.db.upsertCompany(company);
    _company = res;
    notifyListeners();
  }

  void getCompanyById(int id) async {
    Company res = await DBProvider.db.getCompanyById(id);
    print('--');
    print(res);
    _company = res;
    notifyListeners();
  }
}
