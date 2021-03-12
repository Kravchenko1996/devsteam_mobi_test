import 'dart:convert';
import 'dart:typed_data';

import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class SignatureScreen extends StatefulWidget {
  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          MaterialButton(
            onPressed: () async {
              ui.Image image = await _signaturePadKey.currentState.toImage(
                pixelRatio: 3,
              );
              ByteData byteData =
                  await image.toByteData(format: ui.ImageByteFormat.png);
              Uint8List pngBytes = byteData.buffer.asUint8List();
              context
                  .read<InvoiceView>()
                  .setSignatureImage(base64Encode(pngBytes));
              Navigator.of(context).popUntil(
                (route) => route.settings.name == 'InvoiceScreen',
              );
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
