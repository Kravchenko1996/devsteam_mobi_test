import 'package:devsteam_mobi_test/models/Photo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PhotosView extends ChangeNotifier {
  final Dio _dio = Dio();
  final String clientId =
      'cf49c08b444ff4cb9e4d126b7e9f7513ba1ee58de7906e4360afc1a33d1bf4c0';
  List<Photo> _photos = [];

  List<Photo> get photos => _photos;

  Future<void> getPhotos() async {
    try {
      final response = await _dio
          .get('https://api.unsplash.com/photos/?client_id=$clientId');
      _photos = response.data
          .cast<Map<String, dynamic>>()
          .map<Photo>((json) => Photo.fromJson(json))
          .toList() as List<Photo>;
      notifyListeners();
    } catch (response) {
      print(response);
    }
  }
}
