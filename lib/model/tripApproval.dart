import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:reimbursement/model/databaseFields.dart';
import 'package:uuid/uuid.dart';

class TripApproval {
  String submittedByID;
  DateTime dateRequested;
  DateTime dateApproved;
  DateTime tripStartDate;
  DateTime tripEndDate;
  String approvedBy;
  String requestedBy;
  String tripName;
  String id = Uuid().v1();
  String requestedCost;
  String approvedCost;
  bool approved;

  //Contructor - create object in App
  TripApproval(
      {@required this.submittedByID,
      this.dateRequested,
      this.dateApproved,
      this.tripStartDate,
      this.tripEndDate,
      this.approvedBy,
      this.requestedBy,
      this.approvedCost,
      this.requestedCost,
      this.tripName,
      this.approved = false});

  //Constructor - Create object coming from firebase
  TripApproval.fromSnapshot({DocumentSnapshot snapshotData}) {
    var snapshot = snapshotData.data;
    dateRequested =
        (snapshot[ApprovalFields.dateRequested] as Timestamp)?.toDate() ??
            DateTime.now();
    dateApproved =
        (snapshot[ApprovalFields.dateApproved] as Timestamp)?.toDate() ??
            DateTime.now();
    tripStartDate =
        (snapshot[ApprovalFields.tripStartDate] as Timestamp)?.toDate() ??
            DateTime.now();
    tripEndDate =
        (snapshot[ApprovalFields.tripEndDate] as Timestamp)?.toDate() ??
            DateTime.now();
    approvedBy = snapshot[ApprovalFields.approvedBy];
    requestedBy = snapshot[ApprovalFields.requestedBy];
    tripName = snapshot[ApprovalFields.tripName];
    id = snapshot[ApprovalFields.id];
    requestedCost = snapshot[ApprovalFields.requestedCost] ?? 'unknown for now';
    approvedCost = snapshot[ApprovalFields.approvedCost];
    approved = snapshot[ApprovalFields.approved] ?? false;
    submittedByID = snapshot[ApprovalFields.submittedByID];
  }
  //Convert Object into Map for firebase
  Map<String, dynamic> toMap(TripApproval approval) {
    return {
      ApprovalFields.dateRequested: approval.dateRequested,
      ApprovalFields.dateApproved: approval.dateApproved,
      ApprovalFields.tripStartDate: approval.tripStartDate,
      ApprovalFields.tripEndDate: approval.tripEndDate,
      ApprovalFields.approvedBy: approval.approvedBy,
      ApprovalFields.requestedBy: approval.requestedBy,
      ApprovalFields.tripName: approval.tripName,
      ApprovalFields.id: approval.id,
      ApprovalFields.requestedCost: approval.requestedCost,
      ApprovalFields.approvedCost: approval.approvedCost,
      ApprovalFields.approved: approval.approved
    };
  }

  void approveTrip({String approvedCost}) {
    approved = true;
    if (approvedCost == null) {
      this.approvedCost = requestedCost;
    } else {
      this.approvedCost = approvedCost;
    }
  }

  void denyTrip() {
    approved = false;
    approvedCost = "0";
  }
}
