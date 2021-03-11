import 'dart:convert';

import 'package:devsteam_mobi_test/models/Photo.dart';
import 'package:devsteam_mobi_test/viewmodels/photo.dart';
import 'package:devsteam_mobi_test/widgets/Photo/PhotoPickerWidget.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class PhotosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext invoiceContext,
        PhotoView photoView,
        Widget child,
      ) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Photos',
            ),
            centerTitle: true,
          ),
          body: GridView.count(
            crossAxisCount: 4,
            children: List.generate(
              photoView.photosOfInvoice.length + 1,
              (index) => index == 0
                  ? PhotoPickerWidget()
                  : Center(
                      child: photoView.photosOfInvoice.length > 0
                          ? _buildImage(
                              photoView.photosOfInvoice[index - 1],
                              photoView,
                            )
                          : Container(),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage(Photo image, PhotoView photoView) {
    return Stack(
      children: [
        Container(
          child: Image.memory(
            base64Decode(image.file),
            height: 100,
            width: 100,
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
          height: 25,
          width: 25,
          right: 0,
          child: Container(
            color: Colors.grey,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                MdiIcons.windowClose,
                color: Colors.white,
                size: 18,
              ),
              onPressed: () {
                photoView.removePhotoFromList(image);
              },
            ),
          ),
        )
      ],
    );
  }
}
