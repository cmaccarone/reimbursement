import 'package:flutter_test/flutter_test.dart';
import 'package:reimbursement/model/receipt.dart';
import 'package:reimbursement/model/tripApproval.dart';
import 'package:uuid/uuid.dart';

final Receipt receipt = Receipt(
    submittedByUUID: Uuid().v1(),
    amount: 20.11,
    timeSubmitted: null,
    vendor: "walmart",
    reimbursedBy: "caleb",
    receiptDate: null,
    mightHaveAlreadyBeenSubmitted: true,
    submittedByName: "james",
    parentTrip: trip);

final TripApproval trip = TripApproval(
    tripName: "test Trip", requestedCost: "2000"); //change amount to int.

void main() {
  group('parsing', () {
    test('receipt constructors', () async {
      assert(
          receipt.parentTrip != null, 'Parent Trip for this receipt is null');

      final Map<String, dynamic> toMap = receipt.toMap(receipt);
      final copy = Receipt.fromSnapshot(snapshot: toMap);
      expect(receipt, copy);
    });
  });
}
