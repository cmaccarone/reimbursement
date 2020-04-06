import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reimbursement/screens/misc_reusable/constants.dart';
import 'package:reimbursement/screens/misc_reusable/widgets.dart';

class ReviewReceiptScreen extends StatefulWidget {
  final File receiptImage;

  ReviewReceiptScreen({this.receiptImage});

  @override
  _ReviewReceiptScreenState createState() => _ReviewReceiptScreenState();
}

class _ReviewReceiptScreenState extends State<ReviewReceiptScreen> {
  TextEditingController vendorController;
  TextEditingController amountController;
  TextEditingController dateController;
  MediaQueryData queryData;

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Image.asset(
                'assets/profilePic.jpg',
              ),
              color: Colors.orange,
              width: queryData.size.width,
            ),
          ),
          Container(
            height: 270,
            color: Colors.blueGrey,
            width: queryData.size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
              child: Column(
                children: <Widget>[
                  ReceiptTextField(
                    controller: vendorController,
                    inputLabel: "VENDOR",
                  ),
                  ReceiptTextField(
                    controller: amountController,
                    inputLabel: "AMOUNT",
                    KeyboardType: TextInputType.number,
                  ),
                  ReceiptTextField(
                    controller: dateController,
                    inputLabel: "DATE",
                    KeyboardType: TextInputType.datetime,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //finish adding receipts
                      FlatButton(
                        onPressed: () {},
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Finish",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45),
                            ),
                          ),
                        ),
                      ),
                      //add another receipt
                      FlatButton(
                        onPressed: () {},
                        padding: EdgeInsets.all(0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: kTealColor),
                          height: 40,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Text(
                                "Add Another Receipt",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
