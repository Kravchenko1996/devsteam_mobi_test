import 'dart:convert';
import 'dart:io';

import 'package:devsteam_mobi_test/models/Photo.dart';
import 'package:devsteam_mobi_test/viewmodels/photo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class PhotoPickerWidget extends StatefulWidget {
  @override
  _PhotoPickerWidgetState createState() => _PhotoPickerWidgetState();
}

class _PhotoPickerWidgetState extends State<PhotoPickerWidget> {
  _imgFromCamera(PhotoView photoView) async {
    // ignore: deprecated_member_use
    File _image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    photoView.addPhotoToList(
      Photo(
        file: base64Encode(
          _image.readAsBytesSync(),
        ),
      ),
    );
  }

  _imgFromGallery(PhotoView photoView) async {
    // ignore: deprecated_member_use
    File _image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    photoView.addPhotoToList(
      Photo(
        file: base64Encode(
          _image.readAsBytesSync(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext invoiceContext,
        PhotoView photoView,
        Widget child,
      ) {
        return Container(
          child: Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context, photoView);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                width: 100,
                height: 100,
                child: Icon(
                  MdiIcons.plus,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPicker(context, PhotoView photoView) {
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
                        _imgFromGallery(photoView);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera(photoView);
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
