import 'dart:convert';

import 'package:devsteam_mobi_test/models/Company.dart';
import 'package:devsteam_mobi_test/viewmodels/company.dart';
import 'package:devsteam_mobi_test/widgets/ImagePicker.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class CompanyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext companyContext,
        CompanyView companyView,
        Widget child,
      ) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(MdiIcons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              MaterialButton(
                onPressed: () async {
                  String companyLogo;
                  if (companyView.logo != null) {
                    companyLogo = base64Encode(
                      companyView.logo.readAsBytesSync(),
                    );
                  }
                  Company newCompany = Company(
                    name: 'Test',
                    logo: companyLogo,
                  );
                  companyView.saveCompany(newCompany);
                  companyView.setLogo = null;
                  companyView.setCompany = null;
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Save',
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              ImagePickerWidget(),
              Text(
                companyView.company.name,
              ),
            ],
          ),
        );
      },
    );
  }
}
