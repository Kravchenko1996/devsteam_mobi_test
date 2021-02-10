import 'package:flutter/material.dart';

import 'FullSizeImage.dart';

class PhotoWidget extends StatefulWidget {
  final String url;
  final String name;
  final String desc;

  const PhotoWidget({
    Key key,
    this.url,
    this.name,
    this.desc,
  }) : super(key: key);

  @override
  _PhotoWidgetState createState() => _PhotoWidgetState();
}

class _PhotoWidgetState extends State<PhotoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 50, right: 50),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return FullSizeImage(
                      url: widget.url,
                      desc: widget.desc,
                    );
                  },
                ),
              );
            },
            child: Container(
              child: Image.network(
                widget.url,
                width: 200,
              ),
            ),
          ),
          widget.desc != null
              ? Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                    widget.desc,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
              )
              : Container(),
          widget.name != null
              ? Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Text(
                    'Author: ${widget.name}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.left,
                  ),
              )
              : Container(),
        ],
      ),
    );
  }
}
