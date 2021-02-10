import 'package:flutter/material.dart';

class FullSizeImage extends StatelessWidget {
  final String url;
  final String desc;

  const FullSizeImage({
    Key key,
    this.url,
    this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          desc != null ? desc : 'No description in response',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: Image.network(
            url,
          ),
        ),
      ),
    );
  }
}
