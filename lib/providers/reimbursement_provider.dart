import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/model/bug.dart';
import 'package:reimbursement/model/databaseFields.dart';
import 'package:reimbursement/model/receipt.dart';
import 'package:reimbursement/model/tripApproval.dart';

import 'user_provider.dart';

//return 3 different streams.
//stream recieve the data,
//use object constructor to create new object from new data
// push the new object into some sort of list that can be used and analized.
// push the new data into a stream.
// need separate streams for trip approval list, trips, and pending reimbursements,
//also need to figure out how to get reimbursements since they will be nested in each trip.
//reimbursements for each trip will be mapped out and then displayed in the UI.

class ReimbursementProvider {
  final String storageBucketURL = "gs://reimbursements-b84cd.appspot.com/";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  /// use the User class and its properties to define the UserType in a structured way.
  /// ex. User.admin = "admin";
  String userType;
  FirebaseUser currentUser;
  List<Receipt> receipts;

  void dispose() {}

  BuildContext context;
  Stream<List<TripApproval>> _tripsStream;
  Stream<List<Receipt>> _receiptStream;
  double amount;
  Stream<List<TripApproval>> _pendingTripStream;
  Stream<List<Receipt>> _pendingReceiptsStream;
  Stream<List<TripApproval>> _completedTripsStream;

  //firebase streams
  ReimbursementProvider() {
    initStreams(context: context);
    //initialize PendingReimbursement Stream..
  }

  Stream<List<TripApproval>> get tripStream => _tripsStream;
  Stream<List<TripApproval>> get completedTripStream => _completedTripsStream;
  Stream<List<TripApproval>> get pendingTripStream => _pendingTripStream;
  Stream<List<Receipt>> get reimbursementStream => _receiptStream;
  Stream<List<Receipt>> get pendingReimbursementStream =>
      _pendingReceiptsStream;

  ///Initializes all streams
  ///should be run when the app is first opened.
  ///this loads up the app with all the necessary data.
  void initStreams({@required BuildContext context}) async {
    userType = Provider.of<UserProvider>(context, listen: false).userType;
    print(userType);
    currentUser = await _auth.currentUser();
    if (userType == Users.admin) {
      _startTripStream();
      _startReimbursementStream();
      _startCompletedTripStream();
      _startPendingTripStream();
    } else if (userType == Users.treasury) {
      _startTripStream();
      _startReimbursementStream();
      _startPendingReimbursementStream();
      _startCompletedTripStream();
    } else if (userType == Users.superUser) {
      _startTripStream();
      _startCompletedTripStream();
      _startReimbursementStream();
      _startPendingTripStream();
      _startPendingReimbursementStream();
    } else {
      _startTripStream();
      _startReimbursementStream();
      _startCompletedTripStream();
    }
  }

  //Trips Approvals

  ///starts a Pending trip Stream.
  ///This is to be used by the Admin so they can see what
  ///Trips haven't been approved yet, and approve them.
  void _startPendingTripStream() {
    _pendingTripStream = _firestore
        .collection(Collections.unapprovedTrips)
        .snapshots()
        .map((data) {
      return data.documents
          .map((doc) {
            if (doc.data.isNotEmpty) {
              print(doc.data);
              return TripApproval.fromSnapshot(snapshotData: doc);
            } else {
              return null;
            }
          })
          .where((item) => item != null)
          .toList();
    });
  }

  ///Starts a completed Trip Stream.
  ///this shows what trips have already been completed for the current user.
  void _startCompletedTripStream() {
    _completedTripsStream = _firestore
        .collection(Collections.users)
        .document(currentUser.uid)
        .collection(Collections.completedTrips)
        .snapshots()
        .map((data) {
      return data.documents
          .map((doc) {
            if (doc.data.isNotEmpty) {
              return TripApproval.fromSnapshot(snapshotData: doc);
            } else {
              return null;
            }
          })
          .where((item) => item != null)
          .toList();
    });
  }

  ///Starts Trip Stream for the User.

  void _startTripStream() {
    _tripsStream = _firestore
        .collection(Collections.users)
        .document(currentUser.uid)
        .collection(Collections.trips)
        .snapshots()
        .map((data) {
      return data.documents
          .map((doc) {
            if (doc.data.isNotEmpty) {
              return TripApproval.fromSnapshot(snapshotData: doc);
            } else {
              return null;
            }
          })
          .where((item) => item != null)
          .toList();
    });
  }

  ///Approves the given list of Trips
  ///@param tripApprovalList - holds a list of approved trips to approved.
  ///This function gives the admin a way to approve multiple trips at once.
  void approveOrDenyTrips({List<TripApproval> tripApprovalList}) async {
    assert(tripApprovalList.length != 0);
    tripApprovalList.map((trip) {
      if (trip.approved == ApprovalState.approved) {
        return trip;
      } else {
        return null;
      }
    }).forEach((tripApproval) {
      _firestore.runTransaction((transaction) async {
        //Updates users trip status to approved (this happens in the UI) the new mutated trip is passed in as the new data to be updated.
        await transaction.update(
            _firestore
                .collection(Collections.users)
                .document(tripApproval.submittedByID)
                .collection(Collections.trips)
                .document(tripApproval.id),
            tripApproval.toMap(tripApproval));
        //removes reimbursement from the admin pendingApproval list
        await transaction.delete(_firestore
            .collection(Collections.unapprovedTrips)
            .document(tripApproval.id));
      });
    });
  }

  ///Approves single Trip
  void approveOrDenySingleTrip({TripApproval tripApproval}) async {
    _firestore.runTransaction((transaction) async {
      //Updates users trip status to approved (this happens in the UI) the new mutated trip is passed in as the new data to be updated.
      await transaction.update(
          _firestore
              .collection(Collections.users)
              .document(tripApproval.submittedByID)
              .collection(Collections.trips)
              .document(tripApproval.id),
          tripApproval.toMap(tripApproval));
      //removes reimbursement from the admin pendingApproval list
      await transaction.delete(_firestore
          .collection(Collections.unapprovedTrips)
          .document(tripApproval.id));
    });
  }

  ///Requests approval for a trip
  void requestApprovalForTrip({TripApproval tripApproval}) async {
    print("approval requested");
    //function adds data to users pending approval list and the Admin pending approval list atomicly.
    try {
      await _firestore.runTransaction((transaction) async {
        //adds reimbursement to admin pending approval list.
        await transaction.set(
            _firestore
                .collection(Collections.unapprovedTrips)
                .document(tripApproval.id),
            tripApproval.toMap(tripApproval));
        //adds reimbursement to user pending approval list.
        await transaction.set(
            _firestore
                .collection(Collections.users)
                .document(tripApproval.submittedByID)
                .collection(Collections.trips)
                .document(tripApproval.id),
            tripApproval.toMap(tripApproval));
      });
    } catch (e) {
      print(e);
    }
  }

  ///this moves the trip to the user's completed trips list.
  void completeApprovedTrip({TripApproval trip}) {
    _firestore.runTransaction((transaction) async {
      await transaction.delete(_firestore
          .collection(Collections.users)
          .document(trip.submittedByID)
          .collection(Collections.trips)
          .document(trip.id));

      await transaction.set(
          _firestore
              .collection(Collections.users)
              .document(trip.submittedByID)
              .collection(Collections.completedTrips)
              .document(trip.id),
          trip.toMap(trip));
    });
  }

  ///Cancels a Pending Trip.
  ///Called if the user swipes a trip to cancel it while its still pending.
  void cancelPendingTrip({TripApproval trip}) {
    _firestore.runTransaction((transaction) async {
      await transaction.delete(_firestore
          .collection(Collections.users)
          .document(trip.submittedByID)
          .collection(Collections.trips)
          .document(trip.id));

      await transaction.delete(
          _firestore.collection(Collections.unapprovedTrips).document(trip.id));
    });
  }

  /// returns the total amount spent on the specified trip.
  /// @Return double - returns the amount that has been spent so far on this trip.
  double getTotalSpent({TripApproval onTrip}) {
    //todo finish writing getTotalSpent
    double total;
    receipts.map((reimbursement) {
      // reimbursement.
    });
  }

  //Receipts

  ///Creates a Reimbursement Stream.
  ///This is for the user.
  void _startReimbursementStream() {
    _receiptStream = _firestore
        .collection(Collections.users)
        .document(currentUser.uid)
        .collection(Collections.receipts)
        .snapshots()
        .map((data) {
      return data.documents
          .map((doc) {
            if (doc.data.isNotEmpty) {
              Receipt reimbursement = Receipt.fromSnapshot(snapshot: doc);
              receipts.add(reimbursement);
              return reimbursement;
            } else {
              return null;
            }
          })
          .where((item) => item != null)
          .toList();
    });
  }

  /// Pending Reimbursement Stream,
  /// This is for the Treasury Users to be able to see the
  /// pending reimbursements.
  void _startPendingReimbursementStream() {
    _pendingReceiptsStream =
        _firestore.collection(Collections.receipts).snapshots().map((data) {
      return data.documents
          .map((doc) {
            if (doc.data.isNotEmpty) {
              return Receipt.fromSnapshot(snapshot: doc);
            } else {
              return null;
            }
          })
          .where((item) => item != null)
          .toList();
    });
  }

  ///Requests Reimbursement for a receipt.
  ///Adds the Receipt to the Treasury Receipt List to be reimbursed
  void _requestReimbursement(
      {@required Receipt receipt, @required TripApproval forTrip}) {
    _firestore.runTransaction((transaction) async {
      //add receipt to user receipt list
      await transaction.set(
          _firestore
              .collection(Collections.users)
              .document(receipt.submittedByUUID)
              .collection(Collections.receipts)
              .document(receipt.Id),
          receipt.toMap(receipt));
      //add to the treasury pendingReimbursement list
      await transaction.set(
          _firestore
              .collection(Collections.pendingReimbursement)
              .document(receipt.Id),
          receipt.toMap(receipt));
    });
  }

  ///Reimburses the given Receipt
  ///Removes it from the treasury's Receipt list and updates
  ///the status of the reimbursement in the users receipt list.
  void reimburse(Receipt reimbursement) {
    _firestore.runTransaction((transaction) async {
      //add reimbursement to the reimbursed list for the user.
      await transaction.update(
          _firestore
              .collection(Collections.users)
              .document(reimbursement.submittedByUUID)
              .collection(Collections.receipts)
              .document(reimbursement.Id),
          reimbursement.toMap(reimbursement));
      //remove the reimbursement object from the treasury pendingReimbursement list
      await transaction.delete(_firestore
          .collection(Collections.pendingReimbursement)
          .document(reimbursement.Id));
    });
  }

  ///Use this method to return all the reimbursements for a specific trip.
  ///When a user clicks on that trip.
  ///@return List<Receipt>
  List<Receipt> getReimbursements({TripApproval forTrip}) {
    if (receipts.length != null) {
      return receipts.where((receipts) => receipts.parentTrip.id == forTrip.id);
    }
    return [];
  }

  //Bug Reporting

  ///Reports a Bug/Suggestion
  void reportBug({Bug bug}) async {
    await _firestore
        .collection(Collections.bugs)
        .document(bug.id)
        .setData(bug.toMap(bug));
  }

  // Pictures

  ///Upload Receipts
  void uploadReceiptWithPictures(
      {List<File> receiptImages,
      Receipt receipt,
      TripApproval forTrip,
      fileUploading(double),
      VoidCallback success(bool)}) async {
    FirebaseStorage _storage = FirebaseStorage(storageBucket: storageBucketURL);

    void updateURLS() async {
      for (var i = 0; i < receiptImages.length; i++) {
        var url = await _storage
            .ref()
            .child(
                "${FirebaseStorageFields.receipts}/${receiptImages.length < 2 ? receipt.Id : receipt.Id + i.toString()}.jpeg")
            .getDownloadURL();
        print(url);
        receipt.photoURLS.add(url);
      }
    }

    print("called");
    bool success;
    double currentProgress;
    currentUser = await _auth.currentUser();
    print(currentUser.uid);

    print(receiptImages.length);
    for (var i = 0; i < receiptImages.length; i++) {
      Stream<StorageTaskEvent> _uploadTask;
      //name pictures and add them to the receipt
      print(i);
      _uploadTask = _storage
          .ref()
          .child(
              "${FirebaseStorageFields.receipts}/${receiptImages.length < 2 ? receipt.Id : (receipt.Id + i.toString())}.jpeg")
          .putFile(receiptImages[i])
          .events;

      _uploadTask.forEach((event) {
        currentProgress =
            event.snapshot.bytesTransferred / event.snapshot.totalByteCount;
        print(currentProgress);
        if (currentProgress >= 1) {
          updateURLS();
          print("done");
        }
      });
    }

    _requestReimbursement(receipt: receipt, forTrip: forTrip);
  }

  ///Uploads Profile Picture to Firebase.
  void uploadProfilePicture(
      {File file, VoidCallback fileUploading(double)}) async {
    currentUser = await _auth.currentUser();
    double currentProgress;
    FirebaseStorage _storage = FirebaseStorage(storageBucket: storageBucketURL);
    Stream<StorageTaskEvent> _uploadTask;
    _uploadTask = _storage
        .ref()
        .child(
            "${FirebaseStorageFields.profilePictures}/${currentUser.uid}.jpeg")
        .putFile(file)
        .events;

    _uploadTask.forEach((event) {
      currentProgress =
          event.snapshot.bytesTransferred / event.snapshot.totalByteCount;
      return fileUploading(currentProgress);
    });
  }

  //todo: Create function to check all reimbursement to see if the receipt has already been reimbursed.
  //todo: add a single ARRAY to the user database for quickly checking if the receipt was already reimbursed.
  //todo finish getTotalSpentForTrip (totaling all the receipts so far and returning value)

  //todo: add function to deal with when someone completes a trip and finishes submitting all their reimbursements.
}
