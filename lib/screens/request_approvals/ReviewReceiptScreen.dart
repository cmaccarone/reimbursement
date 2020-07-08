import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:option_picker/option_picker.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/model/receipt.dart';
import 'package:reimbursement/model/tripApproval.dart';
import 'package:reimbursement/providers/firebase_reimbursement_provider.dart';
import 'package:reimbursement/providers/firebase_userData.dart';
import 'package:reimbursement/screens/misc_reusable/constants.dart';
import 'package:reimbursement/screens/misc_reusable/widgets.dart';

//todo write test to make sure only doubles can be typed into the value box..

class ReviewReceiptScreen extends StatefulWidget {
  final List<File> receiptImage;
  final TripApproval forTrip;

  ReviewReceiptScreen({this.receiptImage, @required this.forTrip});

  @override
  _ReviewReceiptScreenState createState() => _ReviewReceiptScreenState();
}

class _ReviewReceiptScreenState extends State<ReviewReceiptScreen> {
  TextEditingController vendorController;
  TextEditingController amountController;
  TextEditingController dateController;
  FirebaseUser _currentUser;
  MediaQueryData queryData;
  String vendor = "Receipt";
  double amount;
  DateTime receiptDate;
  Color onPressedColor = Colors.blueGrey;
  List<File> receiptImages = [];
  List<dynamic> carouselImages = [];

  ///use [empty] to clear out the carosel.
  void addImage(File image, bool empty) {
    List<File> receiptImages1 = [];
    List<dynamic> carouselImages1 = [];
    if (empty == true) {
      receiptImages1.add(image);
      carouselImages1.add(Image(image: FileImage(image), fit: BoxFit.contain));
      receiptImages = receiptImages1;
      carouselImages = carouselImages1;
    } else {
      receiptImages.add(image);
      carouselImages.add(Image(image: FileImage(image), fit: BoxFit.contain));
    }
  }

  void _getCurrentUser() async {
    _currentUser = await FirebaseAuth.instance.currentUser();
  }

  @override
  void initState() {
    super.initState();
    widget.receiptImage.forEach((image) {
      addImage(image, false);
    });

    _getCurrentUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    vendorController.dispose();
    amountController.dispose();
    dateController.dispose();
  }

  void pickPhoto(bool reset) {
    ImagePicker imagePicker = ImagePicker();
    OptionPicker.show(
      context: context,
      title: "Pick a Photo",
      subtitle: "",
      firstButtonText: "Gallery",
      secondButtonText: "Take Picture",
      cancelText: "Cancel",
      onPressedFirst: () async {
        var pickedFile = await imagePicker.getImage(
            source: ImageSource.gallery, imageQuality: 50);
        File image = File(pickedFile.path);
        setState(() {
          addImage(image, reset);
        });
      },
      onPressedSecond: () async {
        var pickedFile = await imagePicker.getImage(
            source: ImageSource.camera, imageQuality: 50);
        File image = File(pickedFile.path);
        setState(() {
          addImage(image, reset);
        });
      },
    );
  }

  //todo implement a way to add notes.
  void uploadReceipt() async {
    Receipt receipt = Receipt(
        submittedByName:
            Provider.of<UserProvider>(context, listen: false).fullName,
        receiptDate: receiptDate,
        reimbursed: false,
        parentTrip: widget.forTrip,
        amount: amount,
        submittedByUUID: _currentUser.uid,
        timeSubmitted: DateTime.now(),
        vendor: vendor);
    print(receipt.amount);
    Provider.of<ReimbursementProvider>(context, listen: false)
        .uploadReceiptWithPictures(
            receipt: receipt, receiptImages: receiptImages);
  }

  void clearTextBoxes() {
    vendorController.clear();
    amountController.clear();
    dateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(vendor),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              pickPhoto(false);
            },
            icon: Icon(
              Icons.add_a_photo,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Carousel(
                  dotIncreasedColor: HSLColor.fromAHSL(1, 0, 0, 1).toColor(),
                  dotBgColor: Color(0),
                  dotPosition: DotPosition.bottomCenter,
                  dotColor: kRecieptInputImageCaroselDotColor,
                  showIndicator: true,
                  indicatorBgPadding: 10,
                  boxFit: BoxFit.contain,
                  autoplay: false,
                  images: carouselImages),
              color: kReceiptInputScreenBgColor,
              width: queryData.size.width,
            ),
          ),
          Container(
            color: Colors.white,
            width: queryData.size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26, 10, 26, 0),
              child: Column(
                children: <Widget>[
                  ReceiptTextField(
                    controller: vendorController,
                    onChanged: (value) {
                      setState(() {
                        print(value);
                        vendor = value;
                      });
                    },
                    inputLabel: "VENDOR",
                  ),
                  ReceiptTextField(
                    controller: amountController,
                    inputLabel: "AMOUNT",
                    onChanged: (value) {
                      assert(
                        double.parse(amount.toString()) != null,
                        "input value needs to be a number",
                      );
                      //todo add test to make sure only numbers are passed in here/make sure people cant pass anything else.
                      amount = double.parse(value);
                    },
                    KeyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  ReceiptTextField(
                    controller: dateController,
                    inputLabel: "DATE",
                    onTap: () {
                      DatePicker.showDatePicker(
                        context,
                        pickerTheme: DateTimePickerTheme(
                            itemTextStyle:
                                TextStyle(fontSize: 24, color: Colors.black),
                            cancelTextStyle:
                                TextStyle(color: Colors.black, fontSize: 18),
                            confirmTextStyle:
                                TextStyle(color: kTealColor, fontSize: 18),
                            backgroundColor: Colors.white),
                        pickerMode: DateTimePickerMode.date,
                        dateFormat: "MMMM-dd-yyyy",
                        onConfirm: (date, list) {
                          setState(() {
                            dateController = TextEditingController(
                                text: DateFormat('MMMM-dd-yyyy')
                                    .format(date)
                                    .toString());
                            receiptDate = date;
                          });
                        },
                      );
                    },
                    KeyboardType: TextInputType.datetime,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //finish adding receipts
                        Expanded(
                          child: FlatButton(
                            onPressed: () async {
                              await uploadReceipt();
                              Navigator.of(context).pop();
                            },
                            child: Center(
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
                        Expanded(
                          child: FlatButton(
                            color: kTealColor,
                            highlightColor: Colors.grey,
                            onPressed: () async {
                              await uploadReceipt();
                              setState(() {
                                pickPhoto(true);
                                clearTextBoxes();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: 50,
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text(
                                    "Add Another Receipt",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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
