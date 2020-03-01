import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:reimbursement/model/databaseFields.dart';
import 'package:uuid/uuid.dart';

class TripApproval extends Equatable {
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

  ///use approvalState
  String approved = ApprovalState.pending;

  @override
  List<Object> get props => [
        submittedByID,
        dateRequested,
        dateApproved,
        tripStartDate,
        tripEndDate,
        approvedBy,
        requestedBy,
        tripName,
        id,
        requestedCost,
        approvedCost,
        approved = ApprovalState.pending
      ];

  //Contructor - create object in App
  TripApproval(
      {this.submittedByID,
      this.dateRequested,
      this.dateApproved,
      this.tripStartDate,
      this.tripEndDate,
      this.approvedBy,
      this.requestedBy,
      this.approvedCost,
      this.requestedCost,
      this.tripName,
      this.approved});

  //Constructor - Create object coming from firebase
  TripApproval.fromSnapshot({DocumentSnapshot snapshotData}) {
    dateRequested =
        (snapshotData[ApprovalFields.dateRequested] as Timestamp)?.toDate() ??
            DateTime.now();
    dateApproved =
        (snapshotData[ApprovalFields.dateApproved] as Timestamp)?.toDate() ??
            DateTime.now();
    tripStartDate =
        (snapshotData[ApprovalFields.tripStartDate] as Timestamp)?.toDate() ??
            DateTime.now();
    tripEndDate =
        (snapshotData[ApprovalFields.tripEndDate] as Timestamp)?.toDate() ??
            DateTime.now();
    approvedBy = snapshotData[ApprovalFields.approvedBy];
    requestedBy = snapshotData[ApprovalFields.requestedBy];
    tripName = snapshotData[ApprovalFields.tripName];
    id = snapshotData[ApprovalFields.id];
    requestedCost =
        snapshotData[ApprovalFields.requestedCost] ?? 'unknown for now';
    approvedCost = snapshotData[ApprovalFields.approvedCost];
    approved = snapshotData[ApprovalFields.approved];
    submittedByID = snapshotData[ApprovalFields.submittedByID];
  }
  //Convert Object into Map for firebase
  Map<String, dynamic> toMap(TripApproval approval) {
    return {
      ApprovalFields.submittedByID: approval.submittedByID,
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
    approved = ApprovalState.approved;
    if (approvedCost == null) {
      this.approvedCost = requestedCost;
    } else {
      this.approvedCost = approvedCost;
    }
  }

  void denyTrip() {
    approved = ApprovalState.denied;
    approvedCost = "0";
  }
}

class ApprovalState {
  static final String approved = "approved";
  static final String denied = "denied";
  static final String pending = "pending";
}
