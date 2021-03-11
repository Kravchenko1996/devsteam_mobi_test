import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SignatureScreen extends StatefulWidget {
  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          MaterialButton(
            onPressed: () async {
              // Image image = await _signaturePadKey.currentState.toImage(
              //   pixelRatio: 3,);
            },
            child: Text(
              'Save',
            ),
          )
        ],
      ),
      body: Container(
        child: SfSignaturePad(
          key: _signaturePadKey,
        ),
      ),
    );
  }
}
