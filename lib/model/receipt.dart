import 'package:meta/meta.dart';
import 'package:reimbursement/model/tripApproval.dart';
import 'package:uuid/uuid.dart';

import 'databaseFields.dart';

class Receipt {
  double amount;
  String vendor;
  DateTime receiptDate;
  bool mightHaveAlreadyBeenSubmitted;
  final String Id;
  DateTime timeSubmitted = DateTime.now();
  DateTime timeReimbursed;
  bool reimbursed = false;
  String submittedByName;
  String reimbursedBy;
  String submittedByUUID;
  List<dynamic> photoURLS;
  String notes;
  TripApproval parentTrip;

  /// Creates a new receipt Object.
  ///
  /// [amount] - The amount of the reimbursement
  /// [vendor] - Where the money was spent
  /// [receiptDate] - The date the money was spent
  /// [mightHaveAlreadyBeenSubmitted] - a property that indicates if there is a possibility that the receipt
  /// was already reimbursed
  /// [Id] - a unique identifier.
  /// [timeSubmitted] - time that the receipt was submitted.
  /// [timeReimbursed] - time the receipt was reimbursed
  /// [reimbursed] - bool
  /// [submittedByName] - the name of the user who submitted the reimbursement.
  /// [photoURLS] - a list of URLs for each of the photo's of this receipt (singular). this is a list incase,
  /// the receipt needs to be represented by multiple pictures.
  /// [notes] - any additional information the user thinks needs to be noted regarding this receipt
  /// [parentTrip] - the trip that this receipt is a child of.

  Receipt(
      {@required this.submittedByUUID,
      this.reimbursed = false,
      this.amount,
      this.timeSubmitted,
      this.vendor,
      this.receiptDate,
      this.mightHaveAlreadyBeenSubmitted,
      this.photoURLS,
      this.reimbursedBy,
      this.timeReimbursed,
      this.submittedByName,
      this.notes,
      this.parentTrip})
      : this.Id = Uuid().v1();

  //todo makesure I have included all variables in both the input and output functions.
  Receipt.fromSnapshot({Map<String, dynamic> snapshot})
      : mightHaveAlreadyBeenSubmitted =
            snapshot[ReceiptFields.mightHaveAlreadyBeenSubmitted],
        receiptDate = snapshot[ReceiptFields.receiptDate]?.toDate() ?? null,
        amount = snapshot[ReceiptFields.amount],
        submittedByName = snapshot[ReceiptFields.submittedByName],
        vendor = snapshot[ReceiptFields.vendor],
        timeSubmitted = snapshot[ReceiptFields.timeSubmitted]?.toDate() ?? null,
        timeReimbursed =
            snapshot[ReceiptFields.timeReimbursed]?.toDate() ?? null,
        submittedByUUID = snapshot[ReceiptFields.submittedByID],
        reimbursed = snapshot[ReceiptFields.reimbursed],
        reimbursedBy = snapshot[ReceiptFields.reimbursedBy],
        photoURLS = snapshot[ReceiptFields.photoURLs],
        Id = snapshot[ReceiptFields.Id],
        notes = snapshot[ReceiptFields.notes],
        parentTrip = TripApproval.fromMap(
            snapshotData: snapshot[ReceiptFields.tripApproval]);

  Map<String, dynamic> toMap(Receipt receipt) {
    return {
      ReceiptFields.submittedByID: receipt?.submittedByUUID,
      ReceiptFields.reimbursedBy: receipt?.reimbursedBy,
      ReceiptFields.receiptDate: receipt?.receiptDate,
      ReceiptFields.vendor: receipt?.vendor,
      ReceiptFields.Id: receipt?.Id,
      ReceiptFields.amount: receipt?.amount,
      ReceiptFields.timeReimbursed: receipt?.timeReimbursed,
      ReceiptFields.submittedByName: receipt?.submittedByName,
      ReceiptFields.mightHaveAlreadyBeenSubmitted:
          receipt?.mightHaveAlreadyBeenSubmitted,
      ReceiptFields.photoURLs: receipt?.photoURLS,
      ReceiptFields.reimbursed: receipt?.reimbursed,
      ReceiptFields.timeSubmitted: receipt?.timeSubmitted,
      ReceiptFields.notes: receipt?.notes,
      ReceiptFields.tripApproval: receipt?.parentTrip?.toMap(parentTrip)
    };
  }
}

//class AutoInsurance extends Reimbursement {
//
//
//  int remunerationRate;
//  DateTime policyStartingDate;
//  DateTime policyEndingDate;
//
//  double premium1;
//  double premium2;
//
//  double getReimbursementAmount() {
//    double average;
//    double numberOfVehiclesAllowanceFactor;
//    if (premium1 != null && premium2 != null) {
//      average = (premium1 + premium2) / 2;
//      numberOfVehiclesAllowanceFactor = 1.6;
//    } else {
//      average = premium1;
//      numberOfVehiclesAllowanceFactor = 1;
//    }
//    double maxReimbursement = average * numberOfVehiclesAllowanceFactor;
//    return maxReimbursement - _getDeductible();
//  }
//
//  //todo: when reimbursement has been approved add it to a master AASI list to be downloaded into the CSV file.
//
//  double _policyLength({DateTime startDate, DateTime endDate}) {
//    return endDate.difference(startDate).inDays / 30;
//  }
//
//  int _getDeductible() {
//    int deductible =
//        (((_policyLength() / 12) * .165) * remunerationRate).round();
//    return _roundToNearest(input: deductible.toDouble(), roundTo: 5);
//  }
//
//  int _roundToNearest({double input, double roundTo}) {
//    int divisor = (input ~/ roundTo);
//    return (divisor * roundTo).toInt();
//  }
//}
//
//class SpecialTravel extends Reimbursement {
//  @override
//  void set approved(bool _approved) {

//    super.approved = _approved;
//  }
//}
