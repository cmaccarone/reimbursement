import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/model/tripApproval.dart';
import 'package:reimbursement/providers/reimbursement_provider.dart';
import 'package:reimbursement/widgets.dart';

class ReimburseScreen extends StatefulWidget {
  final String tripApprovalTitle;
  final TripApproval tripApproval;

  ReimburseScreen({this.tripApprovalTitle, this.tripApproval});

  @override
  _ReimburseScreenState createState() => _ReimburseScreenState();
}

class _ReimburseScreenState extends State<ReimburseScreen> {
  TextEditingController descriptionController = TextEditingController();

  TextEditingController startDateController = TextEditingController();

  TextEditingController endDateController = TextEditingController();

  TextEditingController costController = TextEditingController();

  TextEditingController notesController = TextEditingController();

  bool _isExpanded = false;
  String description;
  String startDate;
  String endDate;
  String cost;
  String notes;
  double totalReceiptVale;

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
      appBar: AppBar(
          title: Column(
        children: <Widget>[
          Text("\"${widget.tripApprovalTitle}\" Receipts"),
          Text("\$200.00")
          //todo replace text with actual total amount.
        ],
      )),
      body: Column(
        children: <Widget>[
//          ListView.builder(
//              itemCount: Provider.of<ReimbursementProvider>(context)
//                  .getReimbursements(forTrip: widget.tripApproval)
//                  .length,
//              itemBuilder: (context, index) {}),
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
          FlatButton(
            onPressed: () async {
              FirebaseAuth _auth = FirebaseAuth.instance;
              FirebaseUser currentUser = await _auth.currentUser();
              TripApproval trip = TripApproval(
                  tripName: description,
                  requestedCost: cost,
                  submittedByID: currentUser.uid,
                  dateRequested: DateTime.now());
              setState(() {
                if ((_isExpanded) &&
                    (description != null) &&
                    (startDate != null) &&
                    (endDate != null)) {
                  Provider.of<ReimbursementProvider>(context, listen: false)
                      .requestApprovalForTrip(tripApproval: trip);
                  _clearTextBoxes();
                }
                _toogleExpand();
              });
            },
            child: CircleAvatar(
              child: Icon(Icons.add),
            ),
          ),
          Center(
              child: Text(
            'Add Reciept',
            style: TextStyle(color: Colors.blueAccent),
          ))
        ],
      ),
    );
  }
}
