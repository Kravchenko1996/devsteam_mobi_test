import 'package:devsteam_mobi_test/models/Company.dart';
import 'package:devsteam_mobi_test/viewmodels/company.dart';
import 'package:devsteam_mobi_test/widgets/Company/CompanyForm.dart';
import 'package:devsteam_mobi_test/widgets/ImagePicker.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class CompanyScreen extends StatefulWidget {
  final bool toEdit;

  const CompanyScreen({
    Key key,
    this.toEdit,
  }) : super(key: key);

  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final _companyFormKey = GlobalKey<FormState>();
  final TextEditingController _companyNameCntrller = TextEditingController();
  final TextEditingController _companyPhoneCntrller = TextEditingController();
  final TextEditingController _companyMobileCntrller = TextEditingController();
  final TextEditingController _companyAddressCntrller = TextEditingController();
  final TextEditingController _companyEmailCntrller = TextEditingController();
  final TextEditingController _companyWebsiteCntrller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext companyContext,
        CompanyView companyView,
        Widget child,
      ) {
        if (widget.toEdit != null && widget.toEdit) {
          _companyNameCntrller.text = companyView.company.name;
          _companyPhoneCntrller.text = companyView.company.phone != null
              ? companyView.company.phone.toString()
              : companyView.company.phone;
          _companyMobileCntrller.text = companyView.company.mobile != null
              ? companyView.company.mobile.toString()
              : companyView.company.mobile;
          _companyAddressCntrller.text = companyView.company.address;
          _companyEmailCntrller.text = companyView.company.email;
          _companyWebsiteCntrller.text = companyView.company.website;
        }
        return Scaffold(
          appBar: AppBar(
            leading: widget.toEdit ? IconButton(
              icon: Icon(MdiIcons.close),
              onPressed: () => Navigator.of(context).pop(),
            ) : Container(),
            actions: [
              MaterialButton(
                onPressed: () async {
                  if (_companyFormKey.currentState.validate()) {
                    Company newCompany = Company(
                      id: companyView.company != null
                          ? companyView.company.id
                          : null,
                      logo: companyView.logo ?? null,
                      name: _companyNameCntrller.text,
                      phone: _companyPhoneCntrller.text.isNotEmpty
                          ? int.parse(_companyPhoneCntrller.text)
                          : null,
                      mobile: _companyMobileCntrller.text.isNotEmpty
                          ? int.parse(_companyMobileCntrller.text)
                          : null,
                      address: _companyAddressCntrller.text.isNotEmpty
                          ? _companyAddressCntrller.text
                          : null,
                      email: _companyEmailCntrller.text.isNotEmpty
                          ? _companyEmailCntrller.text
                          : null,
                      website: _companyWebsiteCntrller.text.isNotEmpty
                          ? _companyWebsiteCntrller.text
                          : null,
                    );
                    companyView.saveCompany(newCompany);
                  }
                  if (widget.toEdit) {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Save',
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                AvatarPickerWidget(),
                CompanyForm(
                  companyFormKey: _companyFormKey,
                  companyName: _companyNameCntrller,
                  companyPhone: _companyPhoneCntrller,
                  companyMobile: _companyMobileCntrller,
                  companyAddress: _companyAddressCntrller,
                  companyEmail: _companyEmailCntrller,
                  companyWebsite: _companyWebsiteCntrller,
                  toEdit: widget.toEdit,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
