import 'package:reimbursement/model/databaseFields.dart';
import 'package:uuid/uuid.dart';

class Approval {
  DateTime dateRequested;
  DateTime dateApproved;
  DateTime tripStartDate;
  DateTime tripEndDate;
  String approvedBy;
  String requestedBy;
  String tripName;
  String id = Uuid().v1();
  double requestedCost;
  double approvedCost;

  //Contructor - create object in App
  Approval(
      {this.dateRequested,
      this.dateApproved,
      this.tripStartDate,
      this.tripEndDate,
      this.approvedBy,
      this.requestedBy,
      this.approvedCost,
      this.requestedCost,
      this.tripName});

  //Constructor - Create object coming from firebase
  Approval.fromMap(Map<String, dynamic> map)
      : dateRequested = DateTime.parse(map[ApprovalFields.dateRequested]),
        dateApproved = DateTime.parse(map[ApprovalFields.dateApproved]),
        tripStartDate = DateTime.parse(map[ApprovalFields.tripStartDate]),
        tripEndDate = DateTime.parse(map[ApprovalFields.tripEndDate]),
        approvedBy = map[ApprovalFields.approvedBy],
        requestedBy = map[ApprovalFields.requestedBy],
        tripName = map[ApprovalFields.tripName],
        id = map[ApprovalFields.id],
        requestedCost = map[ApprovalFields.requestedCost],
        approvedCost = map[ApprovalFields.approvedCost];

  //Convert Object into Map for firebase
  Map<String, dynamic> toMap(Approval approval) {
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
      ApprovalFields.approvedCost: approval.approvedCost
    };
  }
}
