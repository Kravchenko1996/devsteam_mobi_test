import 'package:devsteam_mobi_test/viewmodels/company.dart';
import 'package:devsteam_mobi_test/widgets/Company/CompanyScreen.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class CompanyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext companyContext,
        CompanyView companyView,
        Widget child,
      ) {
        return MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (
                  context,
                ) {
                  return CompanyScreen(
                    toEdit: true,
                  );
                },
              ),
            );
          },
          child: Row(
            children: [
              Icon(
                MdiIcons.domain,
                color: Colors.grey,
                size: 30,
              ),
              Text(
                companyView.company != null
                    ? companyView.company.name
                    : 'Company',
              ),
            ],
          ),
        );
      },
    );
  }
}
