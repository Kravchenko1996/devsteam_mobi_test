import 'package:devsteam_mobi_test/view_models/photos.dart';
import 'package:devsteam_mobi_test/widgets/CenterLoadingIndicator.dart';
import 'package:devsteam_mobi_test/widgets/PhotosList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getPhotos();
  }

  getPhotos() async {
    PhotosView photosView = Provider.of<PhotosView>(context, listen: false);
    photosView.getPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PhotosView>(builder: (
      BuildContext context,
      PhotosView photosView,
      Widget child,
    ) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Gallery',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            child: photosView.photos != null && photosView.photos.length > 0
                ? PhotosList()
                : CenterLoadingIndicator(),
          ),
        ),
      );
    });
  }
}
