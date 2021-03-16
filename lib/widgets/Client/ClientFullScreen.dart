import 'package:devsteam_mobi_test/models/Client.dart';
import 'package:devsteam_mobi_test/viewmodels/client.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class ClientFullScreen extends StatefulWidget {
  final TextEditingController clientName;
  final TextEditingController clientEmail;
  final bool toEdit;
  final Client client;

  const ClientFullScreen({
    Key key,
    this.clientName,
    this.clientEmail,
    this.toEdit,
    this.client,
  }) : super(key: key);

  @override
  _ClientFullScreenState createState() => _ClientFullScreenState();
}

class _ClientFullScreenState extends State<ClientFullScreen> {
  final GlobalKey<FormState> _fullClientFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ClientView clientView = Provider.of<ClientView>(context, listen: false);
    if (widget.toEdit) {
      _nameController.text = widget.clientName.text;
      _emailController.text = widget.clientEmail.text;
      clientView.setClient = null;
      if (widget.client != null) {
        _phoneController.text = widget.client.phone != null
            ? widget.client.phone.toString()
            : null;
        _mobileController.text = widget.client.mobile != null
            ? widget.client.mobile.toString()
            : null;
        _address1Controller.text = widget.client.address1 != null
            ? widget.client.address1
            : null;
        _address2Controller.text = widget.client.address2 != null
            ? widget.client.address2
            : null;
        _cityController.text =
            widget.client.city != null ? widget.client.city : null;
        _stateController.text =
            widget.client.state != null ? widget.client.state : null;
        _postalController.text = widget.client.postal != null
            ? widget.client.postal.toString()
            : null;
        _countryController.text = widget.client.country != null
            ? widget.client.country.toString()
            : null;
        _notesController.text = widget.client.notes != null
            ? widget.client.notes.toString()
            : null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext clientContext,
        ClientView clientView,
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
                  if (_fullClientFormKey.currentState.validate()) {
                    Client client = Client(
                      id: widget.client != null
                          ? widget.client.id
                          : null,
                      name: _nameController.text,
                      email: _emailController.text.isNotEmpty
                          ? _emailController.text
                          : null,
                      phone: _phoneController.text.isNotEmpty
                          ? int.parse(_phoneController.text)
                          : null,
                      mobile: _mobileController.text.isNotEmpty
                          ? int.parse(_mobileController.text)
                          : null,
                      address1: _address1Controller.text.isNotEmpty
                          ? _address1Controller.text
                          : null,
                      address2: _address2Controller.text.isNotEmpty
                          ? _address2Controller.text
                          : null,
                      city: _cityController.text.isNotEmpty
                          ? _cityController.text
                          : null,
                      state: _stateController.text.isNotEmpty
                          ? _stateController.text
                          : null,
                      postal: _postalController.text.isNotEmpty
                          ? int.parse(_postalController.text)
                          : null,
                      country: _countryController.text.isNotEmpty
                          ? _countryController.text
                          : null,
                      notes: _notesController.text.isNotEmpty
                          ? _notesController.text
                          : null,
                    );
                    clientView.saveClient(
                      client,
                      widget.client != null ? widget.client.id : null,
                    );
                    Navigator.of(context).popUntil(
                      (route) => route.settings.name == 'InvoiceScreen',
                    );
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _fullClientFormKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 45),
                      child: TextFormField(
                        autofocus: widget.toEdit ? false : true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter client name',
                        ),
                        controller: _nameController,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Enter something please!';
                          }
                          return null;
                        },
                      ),
                    ),
                    _buildTitle('Contacts'),
                    _buildFormFieldWithIcon(
                      'Email',
                      MdiIcons.emailOutline,
                      _emailController,
                      TextInputType.text,
                    ),
                    _buildFormFieldWithIcon(
                      'Phone',
                      MdiIcons.phone,
                      _phoneController,
                      TextInputType.number,
                    ),
                    _buildFormFieldWithIcon(
                      'Mobile',
                      MdiIcons.cellphone,
                      _mobileController,
                      TextInputType.number,
                    ),
                    Divider(),
                    _buildTitle('Address'),
                    _buildFormFieldWithIcon(
                      'Address 1',
                      MdiIcons.homeOutline,
                      _address1Controller,
                      TextInputType.text,
                    ),
                    _buildFormFieldWithIcon(
                      'Address 2',
                      MdiIcons.homeOutline,
                      _address2Controller,
                      TextInputType.text,
                    ),
                    _buildFormFieldWithIcon(
                      'City',
                      MdiIcons.city,
                      _cityController,
                      TextInputType.text,
                    ),
                    _buildFormFieldWithIcon(
                      'State',
                      MdiIcons.map,
                      _stateController,
                      TextInputType.text,
                    ),
                    _buildFormFieldWithIcon(
                      'Zip/Postal code',
                      MdiIcons.unfoldMoreVertical,
                      _postalController,
                      TextInputType.number,
                    ),
                    _buildFormFieldWithIcon(
                      'Country',
                      MdiIcons.flagOutline,
                      _countryController,
                      TextInputType.text,
                    ),
                    Divider(),
                    _buildFormFieldWithIcon(
                      'Add notes',
                      MdiIcons.text,
                      _notesController,
                      TextInputType.text,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      padding: EdgeInsets.only(left: 45),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(title.toUpperCase()),
        ],
      ),
    );
  }

  Widget _buildFormFieldWithIcon(
    String hintText,
    IconData icon,
    TextEditingController controller,
    TextInputType keyboardType,
  ) {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          prefixIcon: Icon(
            icon,
          ),
        ),
        controller: controller,
        keyboardType: keyboardType,
      ),
    );
  }
}
