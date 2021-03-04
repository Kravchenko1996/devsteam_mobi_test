import 'package:devsteam_mobi_test/viewmodels/client.dart';
import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/HomePage.dart';

void main() {
  initApp();
}

void initApp() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<InvoiceView>(
          create: (_) => InvoiceView(),
        ),
        ChangeNotifierProvider<ClientView>(
          create: (_) => ClientView(),
        ),
        ChangeNotifierProvider<ItemView>(
          create: (_) => ItemView(),
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
