import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/model/tripApproval.dart';
import 'package:reimbursement/providers/reimbursement_provider.dart';
import 'package:reimbursement/providers/user_provider.dart';
import 'package:reimbursement/screens/misc_reusable/constants.dart';
import 'package:reimbursement/screens/misc_reusable/widgets.dart';

import 'tripDetailScreen.dart';

class ApproveTripScreen extends StatefulWidget {
  @override
  _ApproveTripScreenState createState() => _ApproveTripScreenState();
}

class _ApproveTripScreenState extends State<ApproveTripScreen> {
  bool _isExpanded = false;
  //approval entry controllers
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  List<TripApproval> pendingApprovalsFromStream;
  List<TripApproval> approvedTrips;
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
    _stream = Provider.of<ReimbursementProvider>(context).pendingTripStream;
    super.didChangeDependencies();
  }

  String togglePendingState({String state}) {
    if (state == ApprovalState.pending) {
      return ApprovalState.approved;
    }
    if (state == ApprovalState.approved) {
      return ApprovalState.pending;
    }
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
                "Pending Approval",
                style: TextStyle(color: kAppbarTextColor),
              ),
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
                          pendingApprovalsFromStream = snapshot.data;
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
                                    return ApproveTripCell(
                                      onCellPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TripDetailScreen(
                                                        trip:
                                                            pendingApprovalsFromStream[
                                                                index])));
                                      },
                                      onCheckboxPressed: () {
                                        setState(() {
                                          pendingApprovalsFromStream[index]
                                                  .approved =
                                              togglePendingState(
                                                  state:
                                                      pendingApprovalsFromStream[
                                                              index]
                                                          .approved);
                                        });
                                      },
                                      titles: pendingApprovalsFromStream[index]
                                          .tripName,
                                      reimbursementTotal:
                                          pendingApprovalsFromStream[index]
                                              .requestedCost,
                                      approvalStatus:
                                          pendingApprovalsFromStream[index]
                                              .approved,
                                    );
                                  });
                            case ConnectionState.done:
                              return ListView.builder(
                                  itemCount: snapshot.data.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return ApproveTripCell(
                                      onCellPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TripDetailScreen(
                                                        trip:
                                                            pendingApprovalsFromStream[
                                                                index])));
                                      },
                                      onCheckboxPressed: () {
                                        setState(() {
                                          pendingApprovalsFromStream[index]
                                                  .approved =
                                              togglePendingState(
                                                  state:
                                                      pendingApprovalsFromStream[
                                                              index]
                                                          .approved);
                                        });
                                      },
                                      titles: pendingApprovalsFromStream[index]
                                          .tripName,
                                      reimbursementTotal:
                                          pendingApprovalsFromStream[index]
                                              .requestedCost,
                                      approvalStatus:
                                          pendingApprovalsFromStream[index]
                                              .approved,
                                    );
                                  });
                          }
                          return null; // unreachable
                        },
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        if (pendingApprovalsFromStream.length > 0) {
                          Provider.of<ReimbursementProvider>(context,
                                  listen: false)
                              .approveOrDenyTrips(
                                  tripApprovalList: pendingApprovalsFromStream);
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: kTealColor,
                        child: Icon(Icons.add),
                      ),
                    ),
                    Center(
                        child: Text(
                      'Approve Selected',
                      style: GoogleFonts.roboto(color: Colors.white),
                    )),
                    SizedBox(
                      height: kPadding,
                    ),
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
