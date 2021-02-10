import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/HomePage.dart';
import 'view_models/photos.dart';

void main() {
  initApp();
}

void initApp() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PhotosView>(
          create: (_) => PhotosView(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Devsteam.mobi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
