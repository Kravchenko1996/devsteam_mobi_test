import 'package:devsteam_mobi_test/view_models/photos.dart';
import 'package:devsteam_mobi_test/widgets/PhotoWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhotosList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PhotosView>(builder: (
      BuildContext context,
      PhotosView photosView,
      Widget child,
    ) {
      return ListView.builder(
          itemCount: photosView.photos.length,
          itemBuilder: (BuildContext context, int index) {
            return PhotoWidget(
              name: photosView.photos[index].user,
              url: photosView.photos[index].url,
              desc: photosView.photos[index].desc,
            );
          });
    });
  }
}
