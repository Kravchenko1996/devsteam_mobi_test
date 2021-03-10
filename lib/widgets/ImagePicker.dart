import 'dart:io';

import 'package:devsteam_mobi_test/viewmodels/company.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImagePickerWidget extends StatefulWidget {
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {

  _imgFromCamera(CompanyView companyView) async {
    // ignore: deprecated_member_use
    File _image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    companyView.chooseLogo(_image);
  }

  _imgFromGallery(CompanyView companyView) async {
    // ignore: deprecated_member_use
    File _image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    companyView.chooseLogo(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext companyContext,
        CompanyView companyView,
        Widget child,
      ) {
        return Center(
          child: GestureDetector(
            onTap: () {
              _showPicker(context, companyView);
            },
            child: CircleAvatar(
              radius: 55,
              child: companyView.logo != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        companyView.logo,
                        width: 100,
                        height: 100,
                        fit: BoxFit.fitHeight,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      width: 100,
                      height: 100,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  void _showPicker(context, CompanyView companyView) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery(companyView);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera(companyView);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
