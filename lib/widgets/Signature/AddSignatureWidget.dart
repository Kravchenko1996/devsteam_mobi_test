import 'package:devsteam_mobi_test/widgets/Signature/SignatureScreen.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddSignatureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (
              context,
            ) {
              return SignatureScreen();
            },
          ),
        );
      },
      child: Row(
        children: [
          Icon(
            MdiIcons.signatureFreehand,
            color: Colors.grey,
            size: 30,
          ),
          Text(
            'Signature',
          ),
        ],
      ),
    );
  }
}
