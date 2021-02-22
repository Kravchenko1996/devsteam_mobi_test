import 'package:flutter/material.dart';

class TabWidget extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final double size;
  final String text;

  const TabWidget({
    Key key,
    this.index,
    this.currentIndex,
    this.icon,
    this.size,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color activeColor = Colors.lightBlue;
    Color passiveColor = Colors.grey;
    return Tab(
      icon: Icon(
        icon,
        size: size,
        color: currentIndex == index ? activeColor : passiveColor,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: currentIndex == index ? activeColor : passiveColor,
          fontSize: 14,
        ),
      ),
    );
  }
}
