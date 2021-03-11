import 'package:devsteam_mobi_test/viewmodels/photo.dart';
import 'package:devsteam_mobi_test/widgets/Photo/PhotosScreen.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class AddPhotoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext photoContext,
        PhotoView photoView,
        Widget child,
      ) {
        return MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (
                  context,
                ) {
                  return PhotosScreen();
                },
              ),
            );
          },
          child: Row(
            children: [
              Icon(
                MdiIcons.image,
                color: Colors.grey,
                size: 30,
              ),
              Text(
                photoView.photosOfInvoice.length == 0
                    ? 'Add photo'
                    : photoView.photosOfInvoice.length == 1
                      ? '${photoView.photosOfInvoice.length} photo'
                      : '${photoView.photosOfInvoice.length} photos',
              ),
            ],
          ),
        );
      },
    );
  }
}
