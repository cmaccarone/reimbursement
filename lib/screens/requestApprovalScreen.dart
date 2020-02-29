import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/constants.dart';
import 'package:reimbursement/model/tripApproval.dart';
import 'package:reimbursement/providers/reimbursement_provider.dart';
import 'package:reimbursement/screens/reimburseScreen.dart';
import 'package:reimbursement/widgets.dart';

class RequestApprovalScreen extends StatefulWidget {
  @override
  _RequestApprovalScreenState createState() => _RequestApprovalScreenState();
}

class _RequestApprovalScreenState extends State<RequestApprovalScreen> {
  bool _isExpanded = false;
  //approval entry controllers
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  String description;
  String startDate;
  String endDate;
  String cost;
  String notes;
  Stream _stream;

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
    description = null;
    startDate = null;
    endDate = null;
    cost = null;
    notes = null;
  }

  @override
  void didChangeDependencies() {
    _stream = Provider.of<ReimbursementProvider>(context).tripStream;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackGroundColor,
        appBar: AppBar(
          title: Text(
            "Submit Travel Request",
            style: TextStyle(color: kMainTextColor),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: [
                  Flexible(
                    child: StreamBuilder<List<TripApproval>>(
                      stream: _stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<TripApproval>> snapshot) {
                        print(snapshot.data);
                        if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Text('no connection');
                          case ConnectionState.waiting:
                            return Text('Awaiting bids...');
                          case ConnectionState.active:
                            return ListView.builder(
                                itemCount: snapshot.data.length ?? 0,
                                itemBuilder: (context, index) {
                                  //todo figure out why this is printing twice?
                                  print(snapshot.data);
                                  return TripCell(
                                    onDismissed: (direction) {
                                      if (snapshot.data[index].approved ==
                                          "approved") {
                                        Provider.of<ReimbursementProvider>(
                                                context,
                                                listen: false)
                                            .completeApprovedTrip(
                                                trip: snapshot.data[index]);
                                      } else {
                                        print("completed");
                                        Provider.of<ReimbursementProvider>(
                                                context,
                                                listen: false)
                                            .cancelPendingTrip(
                                                trip: snapshot.data[index]);
                                      }
                                    },
                                    onPressed: () {
                                      if (snapshot.data[index].approved ==
                                          ApprovalState.approved) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ReimburseScreen(
                                                        tripApprovalTitle:
                                                            snapshot.data[index]
                                                                .tripName,
                                                        tripApproval: snapshot
                                                            .data[index])));
                                      }
                                    },
                                    title: snapshot.data[index].tripName,
                                    reimbursementTotal:
                                        snapshot.data[index].requestedCost,
                                    approvalStatus:
                                        snapshot.data[index].approved,
                                  );
                                });
                          case ConnectionState.done:
                            return ListView.builder(
                                itemCount: snapshot.data.length ?? 0,
                                itemBuilder: (context, index) {
                                  return TripCell(
                                    title: snapshot.data[index].tripName,
                                    reimbursementTotal:
                                        snapshot.data[index].requestedCost,
                                    approvalStatus:
                                        snapshot.data[index].approved,
                                  );
                                });
                        }
                        return null; // unreachable
                      },
                    ),
                  ),
                ],
              ),
            ),
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
              onPressed: () {
                FirebaseUser currentUser =
                    Provider.of<ReimbursementProvider>(context, listen: false)
                        .currentUser;
                TripApproval trip = TripApproval(
                    approved: ApprovalState.pending,
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
                backgroundColor: kTealColor,
                child: Icon(Icons.add),
              ),
            ),
            Center(
                child: Text(
              'Add Trip',
              style: GoogleFonts.roboto(color: Colors.white),
            )),
            SizedBox(
              height: kPadding,
            ),
          ],
        ),
      ),
    );
  }
}
