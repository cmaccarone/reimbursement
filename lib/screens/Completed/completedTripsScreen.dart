import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/model/tripApproval.dart';
import 'package:reimbursement/providers/reimbursement_provider.dart';
import 'package:reimbursement/providers/user_provider.dart';
import 'package:reimbursement/screens/Request%20Approvals/receiptScreen.dart';
import 'package:reimbursement/screens/misc_reusable/constants.dart';
import 'package:reimbursement/screens/misc_reusable/widgets.dart';

class CompletedTripsScreen extends StatefulWidget {
  @override
  _CompletedTripsScreenState createState() => _CompletedTripsScreenState();
}

class _CompletedTripsScreenState extends State<CompletedTripsScreen> {
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
    _stream = Provider.of<ReimbursementProvider>(context).completedTripStream;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userData, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: kBackGroundColor,
          appBar: AppBar(
            title: Text(
              "Completed Trips",
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

                                    return CompletedTripCell(
                                      onPressed: () {
                                        if (snapshot.data[index].approved ==
                                            ApprovalState.approved) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReceiptScreen(
                                                          completedOnly: true,
                                                          tripApprovalTitle:
                                                              snapshot
                                                                  .data[index]
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
                      ),
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
