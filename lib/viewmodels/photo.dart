import 'package:devsteam_mobi_test/Database.dart';
import 'package:devsteam_mobi_test/models/Photo.dart';
import 'package:flutter/material.dart';

class PhotoView with ChangeNotifier {
  List<Photo> _photosOfInvoice = [];

  List<Photo> get photosOfInvoice => _photosOfInvoice;

  set setPhotosOfInvoice(List<Photo> value) {
    _photosOfInvoice = value;
  }

  void addPhotoToList(Photo image) {
    _photosOfInvoice.add(image);
    notifyListeners();
  }

  void removePhotoFromList(Photo image) {
    _photosOfInvoice.remove(image);
    if (image.id != null) {
      deletePhoto(image.id);
    }
    notifyListeners();
  }

  void savePhoto(Photo photo) async {
    await DBProvider.db.upsertPhoto(photo);
  }

  void deletePhoto(int photoId) async {
    await DBProvider.db.deletePhoto(photoId);
  }

  void getAllPhotosByInvoiceId(int invoiceId) async {
    List<Photo> res = await DBProvider.db.getAllPhotosByInvoiceId(invoiceId);
    if (res != null) {
      _photosOfInvoice = res;
    }
    notifyListeners();
  }
}
