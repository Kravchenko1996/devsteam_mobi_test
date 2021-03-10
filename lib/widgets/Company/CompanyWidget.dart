import 'package:devsteam_mobi_test/models/Invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/company.dart';
import 'package:devsteam_mobi_test/widgets/Company/CompanyScreen.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class CompanyWidget extends StatelessWidget {
  final Invoice invoice;

  const CompanyWidget({
    Key key,
    this.invoice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () async {
        if (invoice != null && invoice.companyId != null) {
          context.read<CompanyView>().getCompanyById(invoice.companyId);
        }
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (
              context,
            ) {
              return CompanyScreen();
            },
          ),
        );
      },
      child: Row(
        children: [
          Icon(
            MdiIcons.officeBuilding,
            color: Colors.grey,
            size: 30,
          ),
          Text(
            context.read<CompanyView>().company != null
                ? context.read<CompanyView>().company.name
                : 'Company',
          ),
        ],
      ),
    );
  }
}
