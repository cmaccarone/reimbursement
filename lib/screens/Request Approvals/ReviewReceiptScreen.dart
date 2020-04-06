import 'dart:io';

import 'package:flutter/material.dart';

class ReviewReceiptScreen extends StatefulWidget {
  final File receiptImage;

  ReviewReceiptScreen({this.receiptImage});

  @override
  _ReviewReceiptScreenState createState() => _ReviewReceiptScreenState();
}

class _ReviewReceiptScreenState extends State<ReviewReceiptScreen> {
  MediaQueryData queryData;

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);

    return Column(
      children: <Widget>[
        Container(
          child: Image.asset(
            'assets/profilePic.jpg',
          ),
          color: Colors.orange,
          width: queryData.size.width,
          height: queryData.size.height * (2 / 3),
        ),
        Container(
          color: Colors.lightBlueAccent,
          width: queryData.size.width,
          height: queryData.size.height * (1 / 3) - 83,
        )
      ],
    );
  }
}
