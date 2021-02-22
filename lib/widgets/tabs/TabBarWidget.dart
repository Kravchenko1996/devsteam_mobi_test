import 'package:devsteam_mobi_test/widgets/tabs/TabWidget.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TabBarWidget extends StatelessWidget {
  final TabController tabController;
  final int currentIndex;

  const TabBarWidget({
    Key key,
    this.tabController,
    this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      tabs: [
        TabWidget(
          size: 25.0,
          currentIndex: currentIndex,
          icon: MdiIcons.fileDocumentOutline,
          index: 0,
          text: 'Invoices',
        ),
        TabWidget(
          size: 25.0,
          currentIndex: currentIndex,
          icon: MdiIcons.clockTimeFourOutline,
          index: 1,
          text: 'Estimates',
        ),
        TabWidget(
          size: 25.0,
          currentIndex: currentIndex,
          icon: MdiIcons.poll,
          index: 2,
          text: 'Reports',
        ),
        TabWidget(
          size: 25.0,
          currentIndex: currentIndex,
          icon: MdiIcons.dotsHorizontal,
          index: 3,
          text: 'More',
        ),
      ],
    );
  }
}
