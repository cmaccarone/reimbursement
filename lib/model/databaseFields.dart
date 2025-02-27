class Collections {
  static final String users = 'users';
  static final String trips = 'trips';
  static final String unapprovedTrips = 'unapprovedTrips';
  static final String pendingReimbursement = 'pendingReimbursement';
  static final String receipts = 'receipts';
  static final String completedTrips = 'completedTrips';
  static final String bugs = 'bugs';
  static final String reimbursementCache = 'reimbursementCache';
  static final String specialTravel = 'specialTravel';
}

class UserFields {
  static final String address = 'address';
  static final String city = 'city';
  static final String state = 'state';
  static final String zipCode = 'zipCode';
  static final String userType = 'userType';
  static final String payMeBy = 'PayMeBy';
  static final String email = 'email';
  static final String firstName = 'firstName';
  static final String lastName = 'lastName';
}

class BugFields {
  static final String timeReported = 'timeReported';
  static final String reporterEmail = 'reporterEmail';
  static final String reporterName = 'reporterName';
  static final String reporterUserType = 'reporterUserType';
  static final String reportText = 'reportText';
  static final String id = 'id';
}

class ReceiptFields {
  static final String receiptDate = 'receiptDate';
  static final String vendor = 'vendor';
  static final String photoURLs = 'photoURLs';
  static final String reimbursed = 'reimbursed';
  static final String reimbursement = 'reimbursement';
  static final String submittedBy = 'submittedBy';
  static final String timeSubmitted = 'timeSubmitted';
  static final String timeReimbursed = 'timeReimbursed';
  static final String amount = "amount";
  static final String Id = "Id";
  static final String submittedByID = "submittedByID";
  static final String description = "description";
  static final String notes = 'notes';
  static final String tripApproval = 'tripApproval';
  static final String mightHaveAlreadyBeenSubmitted =
      "mightHaveAlreadyBeenSubmitted";
  static final String submittedByName = 'submittedByName';
  static final String reimbursedBy = 'reimbursedBy';
}

class ApprovalFields {
  static final String dateRequested = 'dateRequested';
  static final String dateApproved = 'dateApproved';
  static final String tripStartDate = 'tripStartDate';
  static final String tripEndDate = 'tripEndDate';
  static final String approvedBy = 'approvedBy';
  static final String requestedBy = 'requestedBy';
  static final String tripName = 'tripName';
  static final String id = 'id';
  static final String requestedCost = 'requestedCost';
  static final String approvedCost = 'approvedCost';
  static final String approved = "approved";
  static final String submittedByID = "submittedByID";
}

class FirebaseStorageFields {
  static final String receipts = 'receipts/';
  static final String profilePictures = 'profilePictures/';
}
