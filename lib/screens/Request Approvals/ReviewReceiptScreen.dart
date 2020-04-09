import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:reimbursement/screens/misc_reusable/constants.dart';
import 'package:reimbursement/screens/misc_reusable/widgets.dart';
import 'package:zoom_widget/zoom_widget.dart';

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    vendorController.dispose();
    amountController.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Zoom(
                scrollWeight: 0,
                backgroundColor: kBackGroundColor,
                key: UniqueKey(),
                initZoom: .001,
                doubleTapZoom: true,
                width: 3800,
                height: 3800,
                child: Image(
                  image: widget.receiptImage == null
                      ? Image.asset(
                          'assets/profilePic.jpg',
                          fit: BoxFit.fitHeight,
                        )
                      : FileImage(widget.receiptImage),
                  fit: BoxFit.fitHeight,
                ),
              ),
              color: Colors.black12,
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
                    KeyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                  ),
                  ReceiptTextField(
                    controller: dateController,
                    inputLabel: "DATE",
                    onTap: () {
                      DatePicker.showDatePicker(context,
                          pickerTheme: DateTimePickerTheme(),
                          pickerMode: DateTimePickerMode.date,
                          dateFormat: "MMMM-dd-yyyy", onConfirm: (date, list) {
                        setState(() {
                          dateController = TextEditingController(
                              text: DateFormat('MMMM-dd-yyyy')
                                  .format(date)
                                  .toString());
                        });

                        print(date);
                        print(list);
                      }, initialDateTime: DateTime.now());
                    },
                    KeyboardType: TextInputType.datetime,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //finish adding receipts
                      Expanded(
                        child: FlatButton(
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
                      ),
                      //add another receipt
                      Expanded(
                        child: FlatButton(
                          onPressed: () {},
                          padding: EdgeInsets.all(0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kTealColor),
                            height: 40,
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Text(
                                  "Add More",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
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
