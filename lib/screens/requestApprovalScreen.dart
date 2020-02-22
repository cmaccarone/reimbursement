import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/model/tripApproval.dart';
import 'package:reimbursement/providers/reimbursement_provider.dart';
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Submit Travel Request"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: [
                  Flexible(
                    child: StreamBuilder<List<TripApproval>>(
                      stream:
                          Provider.of<ReimbursementProvider>(context).stream,
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
                                  return TripCell(
                                    title: 'new',
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
              'Add New Trip Request',
              style: TextStyle(color: Colors.blueAccent),
            ))
          ],
        ),
      ),
    );
  }
}

class TripCell extends StatelessWidget {
  final String title;
  final bool approvalStatus;
  final String reimbursementTotal;

  TripCell({this.title, this.reimbursementTotal, this.approvalStatus});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              Icons.airplanemode_active,
              color: Colors.blueAccent,
              size: 50,
            ),
            SizedBox(
              width: 50,
            ),
            Column(
              children: <Widget>[
                Text(title),
                Text(
                  approvalStatus ? "approved" : "denied" ?? "pending",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            SizedBox(
              width: 50,
            ),
            Text(
              reimbursementTotal,
              style: TextStyle(color: Colors.green),
            )
          ],
        ),
        Text("--------------------------------------------")
      ],
    );
  }
}

class ExpandedSection extends StatefulWidget {
  final Widget child;
  final bool expand;
  ExpandedSection({this.expand = false, this.child});

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection>
    with SingleTickerProviderStateMixin {
  AnimationController expandController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    Animation curve = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment: 1.0, sizeFactor: animation, child: widget.child);
  }
}
