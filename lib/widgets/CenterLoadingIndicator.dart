import 'package:flutter/material.dart';

class CenterLoadingIndicator extends StatefulWidget {
  @override
  _CenterLoadingIndicatorState createState() => _CenterLoadingIndicatorState();
}

class _CenterLoadingIndicatorState extends State<CenterLoadingIndicator>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget widget) {
            return new Transform.rotate(
              angle: animationController.value * 6.3,
              child: widget,
            );
          },
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
