import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/model/tripApproval.dart';
import 'package:reimbursement/providers/firebase_reimbursement_provider.dart';
import 'package:reimbursement/providers/firebase_userData.dart';
import 'package:reimbursement/screens/misc_reusable/constants.dart';
import 'package:reimbursement/screens/misc_reusable/widgets.dart';
import 'package:reimbursement/screens/request_approvals/receiptScreen.dart';

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
    return Consumer<UserProvider>(builder: (context, userData, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: kBackGroundColor,
          appBar: AppBar(
            title: Center(
              child: Text(
                "Submit Travel Request",
              ),
            ),
          ),
          body: Column(
            children: <Widget>[
              Flexible(
                flex: !_isExpanded ? 3 : 0,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  switchInCurve: Curves.bounceIn,
                  switchOutCurve: Curves.linear,
                  child: !_isExpanded
                      ? StreamBuilder<List<TripApproval>>(
                          stream: _stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<TripApproval>> snapshot) {
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
                                                        ReceiptScreen(
                                                            completedOnly:
                                                                false,
                                                            tripApproval:
                                                                snapshot.data[
                                                                    index])));
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
                                      return CompletedTripCell(
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
                        )
                      : Container(),
                ),
              ),
              _isExpanded
                  ? Expanded(
                      child: ListView(
                        children: [
                          Column(
                            children: <Widget>[
                              SignInTextFields(
                                autoFocusEnabled: true,
                                hideText: false,
                                controller: descriptionController,
                                inputLabel: "Trip Name",
                                onChanged: (text) {
                                  description = text;
                                },
                              ),
                              SignInTextFields(
                                autoFocusEnabled: false,
                                hideText: false,
                                controller: startDateController,
                                inputLabel: "Start Date",
                                onChanged: (text) {
                                  startDate = text;
                                },
                              ),
                              SignInTextFields(
                                autoFocusEnabled: false,
                                hideText: false,
                                controller: endDateController,
                                inputLabel: "End Date",
                                onChanged: (text) {
                                  endDate = text;
                                },
                              ),
                              SignInTextFields(
                                autoFocusEnabled: false,
                                hideText: false,
                                controller: costController,
                                inputLabel: "Total Trip Cost",
                                onChanged: (text) {
                                  cost = text;
                                },
                              )
                            ],
                          ),
                          Container(
                            height: 70,
                            child: Column(
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () async {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);

                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    FirebaseUser currentUser =
                                        await FirebaseAuth.instance
                                            .currentUser();
                                    TripApproval trip = TripApproval(
                                        requestedBy: userData.fullName,
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
                                        Provider.of<ReimbursementProvider>(
                                                context,
                                                listen: false)
                                            .requestApprovalForTrip(
                                                tripApproval: trip);
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
                                  style:
                                      GoogleFonts.roboto(color: Colors.white),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      height: 70,
                      child: Column(
                        children: <Widget>[
                          FlatButton(
                            onPressed: () async {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              FirebaseUser currentUser =
                                  await FirebaseAuth.instance.currentUser();
                              TripApproval trip = TripApproval(
                                  requestedBy: userData.fullName,
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
                                  Provider.of<ReimbursementProvider>(context,
                                          listen: false)
                                      .requestApprovalForTrip(
                                          tripApproval: trip);
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
                        ],
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  Text('header'),
                  Expanded(
                    child: Container(
                      color: Colors.green,
                      child: Text('body'),
                    ),
                  ),
                  Text('footer'),
                ]),
              )));
    }));
  }
}
