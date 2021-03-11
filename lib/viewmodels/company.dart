import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Company.dart';
import 'package:flutter/material.dart';

class CompanyView with ChangeNotifier {
  String _logo;

  String get logo => _logo;

  Company _company;

  Company get company => _company;

  List<Company> _companies = [];

  List<Company> get companies => _companies;

  set setCompany(Company value) {
    _company = value;
  }

  void chooseLogo(String image) async {
    _logo = image;
    notifyListeners();
  }

  void saveCompany(Company company) async {
    Company res = await DBProvider.db.upsertCompany(company);
    _company = res;
    notifyListeners();
  }

  void getAllCompanies() async {
    List<Company> res = await DBProvider.db.getAllCompanies();
    if (res.length != 0) {
      _company = res.first;
      _logo = res.first.logo;
    }
    notifyListeners();
  }
}
