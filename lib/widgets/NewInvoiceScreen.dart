import 'package:devsteam_mobi_test/widgets/ClientWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NewInvoiceScreen extends StatefulWidget {
  @override
  _NewInvoiceScreenState createState() => _NewInvoiceScreenState();
}

class _NewInvoiceScreenState extends State<NewInvoiceScreen> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _clientNameFilter = TextEditingController();
  final TextEditingController _clientEmailFilter = TextEditingController();
  final TextEditingController _itemDescFilter = TextEditingController();

  String _clientName = '';
  String _clientEmail = '';
  String _itemDesc = '';

  _NewInvoiceScreenState() {
    _clientNameFilter.addListener(_clientNameListener);
    _clientEmailFilter.addListener(_clientEmailListener);
    _itemDescFilter.addListener(_itemDescListener);
  }

  void _clientNameListener() {
    setState(() {
      if (_clientNameFilter.text.isEmpty) {
        _clientName = '';
      } else {
        _clientName = _clientNameFilter.text;
      }
    });
  }

  void _clientEmailListener() {
    setState(() {
      if (_clientEmailFilter.text.isEmpty) {
        _clientEmail = '';
      } else {
        _clientEmail = _clientEmailFilter.text;
      }
    });
  }

  void _itemDescListener() {
    setState(() {
      if (_itemDescFilter.text.isEmpty) {
        _itemDesc = '';
      } else {
        _itemDesc = _itemDescFilter.text;
      }
    });
  }

  @override
  void dispose() {
    _clientNameFilter.dispose();
    _clientEmailFilter.dispose();
    _itemDescFilter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(MdiIcons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClientWidget(
              clientName: _clientNameFilter,
              clientEmail: _clientEmailFilter,
            ),
          ],
        ),
      ),
    );
  }
}
