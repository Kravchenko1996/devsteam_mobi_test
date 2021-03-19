import 'package:devsteam_mobi_test/viewmodels/PdfView.dart';
import 'package:devsteam_mobi_test/models/EmailCredentials.dart';
import 'package:devsteam_mobi_test/viewmodels/client.dart';
import 'package:devsteam_mobi_test/viewmodels/company.dart';
import 'package:devsteam_mobi_test/viewmodels/discount.dart';
import 'package:devsteam_mobi_test/viewmodels/invoice.dart';
import 'package:devsteam_mobi_test/viewmodels/item.dart';
import 'package:devsteam_mobi_test/viewmodels/payment.dart';
import 'package:devsteam_mobi_test/viewmodels/photo.dart';
import 'package:devsteam_mobi_test/viewmodels/tax.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/HomePage.dart';

void main() async {
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
        ChangeNotifierProvider<PaymentView>(
          create: (_) => PaymentView(),
        ),
        ChangeNotifierProvider<CompanyView>(
          create: (_) => CompanyView(),
        ),
        ChangeNotifierProvider<PhotoView>(
          create: (_) => PhotoView(),
        ),
        ChangeNotifierProvider<EmailCredentials>(
          create: (_) => EmailCredentials(),
        ),
        ChangeNotifierProvider<PdfView>(
          create: (_) => PdfView(),
        ),
        ChangeNotifierProvider<TaxView>(
          create: (_) => TaxView(),
        ),
        ChangeNotifierProvider<DiscountView>(
          create: (_) => DiscountView(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //ToDo Remove focus from all fields by tap outside
    return Listener(
      // onPointerDown: (_) {
      //   FocusScopeNode currentFocus = FocusScope.of(context);
      //   if (!currentFocus.hasPrimaryFocus &&
      //       currentFocus.focusedChild != null) {
      //     currentFocus.focusedChild.unfocus();
      //   }
      // },
      child: MaterialApp(
        title: 'Devsteam.mobi',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}
