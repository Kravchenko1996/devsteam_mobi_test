import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CompanyForm extends StatelessWidget {
  final GlobalKey companyFormKey;
  final TextEditingController companyName;
  final TextEditingController companyPhone;
  final TextEditingController companyMobile;
  final TextEditingController companyAddress;
  final TextEditingController companyEmail;
  final TextEditingController companyWebsite;
  final bool toEdit;

  const CompanyForm({
    Key key,
    this.companyFormKey,
    this.companyName,
    this.companyPhone,
    this.companyMobile,
    this.companyAddress,
    this.companyEmail,
    this.companyWebsite,
    this.toEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: companyFormKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 45),
              child: TextFormField(
                autofocus: toEdit ? false : true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Business name',
                ),
                controller: companyName,
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Enter something please!';
                  }
                  return null;
                },
              ),
            ),
            Container(
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Phone',
                  prefixIcon: Icon(
                    MdiIcons.phone,
                  ),
                ),
                keyboardType: TextInputType.number,
                controller: companyPhone,
              ),
            ),
            Container(
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Mobile',
                  prefixIcon: Icon(
                    MdiIcons.cellphone,
                  ),
                ),
                keyboardType: TextInputType.number,
                controller: companyMobile,
              ),
            ),
            Container(
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Address',
                  prefixIcon: Icon(
                    MdiIcons.googleMaps,
                  ),
                ),
                controller: companyAddress,
              ),
            ),
            Container(
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Email',
                  prefixIcon: Icon(
                    MdiIcons.email,
                  ),
                ),
                controller: companyEmail,
              ),
            ),
            Container(
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Website',
                  prefixIcon: Icon(
                    MdiIcons.web,
                  ),
                ),
                controller: companyWebsite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
