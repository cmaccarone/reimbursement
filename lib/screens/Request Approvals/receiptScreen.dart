import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:option_picker/option_picker.dart';
import 'package:reimbursement/model/tripApproval.dart';
import 'package:reimbursement/screens/Request Approvals/ReviewReceiptScreen.dart';
import 'package:reimbursement/screens/misc_reusable/constants.dart';
import 'package:reimbursement/screens/misc_reusable/widgets.dart';

class ReceiptScreen extends StatefulWidget {
  final TripApproval tripApproval;
  final bool completedOnly;

  ReceiptScreen({this.tripApproval, this.completedOnly});

  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  TextEditingController descriptionController = TextEditingController();

  TextEditingController startDateController = TextEditingController();

  TextEditingController endDateController = TextEditingController();

  TextEditingController costController = TextEditingController();

  TextEditingController notesController = TextEditingController();

  bool completedOnly;
  bool _isExpanded = false;
  String description;
  String startDate;
  String endDate;
  String cost;
  String notes;
  double totalReceiptVale;
  String picturePath;

  void _toogleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _clearTextBoxes() {
    endDateController.clear();
    costController.clear();
    startDateController.clear();
    notesController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
          title: Column(
        children: <Widget>[
          Text("\"${widget.tripApproval.tripName}\" Receipts"),
          Text("\$${widget.tripApproval.requestedCost}")
          //todo replace text with actual total amount.
        ],
      )),
      body: Column(
        children: <Widget>[
          Center(
            child: Container(
              height: 20,
              width: 20,
              color: Colors.red,
            ),
          ),
//          ListView.builder(
//              itemCount: 1,
//              itemBuilder: (context, index) {
//                return ReceiptCell(
//                  onPressed: () {},
//                  title: "Safeway",
//                  reimbursementTotal: "\$40.00",
//                  approvalStatus: ApprovalState.approved,
//                );
//              }),
          ExpandedSection(
            expand: _isExpanded,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.all(25.0),
              child: Column(
                children: <Widget>[
                  SignInTextFields(
                    hideText: false,
                    controller: descriptionController,
                    inputLabel: "Trip Name",
                    onChanged: (text) {
                      description = text;
                    },
                  ),
                  SignInTextFields(
                    hideText: false,
                    controller: startDateController,
                    inputLabel: "Start Date",
                    onChanged: (text) {
                      startDate = text;
                    },
                  ),
                  SignInTextFields(
                    hideText: false,
                    controller: endDateController,
                    inputLabel: "End Date",
                    onChanged: (text) {
                      endDate = text;
                    },
                  ),
                  SignInTextFields(
                    hideText: false,
                    controller: costController,
                    inputLabel: "Total Trip Cost",
                    onChanged: (text) {
                      cost = text;
                    },
                  )
                ],
              ),
            ),
          ),
          widget.completedOnly
              ? SizedBox()
              : FlatButton(
                  onPressed: () async {
                    OptionPicker.show(
                      context: context,
                      title: "Choose a Photo",
                      subtitle: "Pick a Source",
                      firstButtonText: "Gallery",
                      secondButtonText: "Take Picture",
                      cancelText: "Cancel",
                      onPressedFirst: () async {
                        var image = await ImagePicker.pickImage(
                            source: ImageSource.gallery, imageQuality: 50);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReviewReceiptScreen(
                                      receiptImage: [image],
                                      forTrip: widget.tripApproval,
                                    )));
                      },
                      onPressedSecond: () async {
                        var image = await ImagePicker.pickImage(
                            source: ImageSource.camera, imageQuality: 50);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReviewReceiptScreen(
                                      receiptImage: [image],
                                      forTrip: widget.tripApproval,
                                    )));
                      },
                    );
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.add),
                  ),
                ),
          widget.completedOnly
              ? SizedBox()
              : Center(
                  child: Text(
                  'Add Reciept',
                  style: TextStyle(color: Colors.blueAccent),
                ))
        ],
      ),
    );
  }
}
