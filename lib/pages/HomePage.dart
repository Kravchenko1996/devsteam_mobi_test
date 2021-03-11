import 'package:devsteam_mobi_test/pages/EstimatesPage.dart';
import 'package:devsteam_mobi_test/pages/InvoicesPage.dart';
import 'package:devsteam_mobi_test/viewmodels/company.dart';
import 'package:devsteam_mobi_test/widgets/Company/CompanyScreen.dart';
import 'package:devsteam_mobi_test/widgets/tabs/TabBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  TabController _tabController;
  int _currentIndex = 0;

  _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  void initState() {
    super.initState();
    CompanyView companyView = Provider.of<CompanyView>(context, listen: false);
    companyView.getAllCompanies();
    if (_tabController == null) {
      _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
      _tabController.addListener(_handleTabSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext companyContext,
        CompanyView companyView,
        Widget child,
      ) {
        // ToDo fix loader
        if (companyView.company != null) {
          return Scaffold(
            bottomNavigationBar: BottomAppBar(
              elevation: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff4e4b4b),
                ),
                child: TabBarWidget(
                  tabController: _tabController,
                  currentIndex: _currentIndex,
                ),
              ),
            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                InvoicesPage(),
                EstimatesPage(),
                EstimatesPage(),
                EstimatesPage(),
              ],
            ),
          );
        }
        return CompanyScreen(
          toEdit: false,
        );
      },
    );
  }
}
