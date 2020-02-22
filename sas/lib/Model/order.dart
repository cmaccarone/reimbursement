import 'seat.dart';

class Order {
  Seat seat;

  orderStatus status;
  bool framePictureReceived;
  List<String> pictureURLs = [];
  int orderNumber;
  //customer information (s) shipping
  String sFirstName;
  String sLastName;
  String sAddress;
  String sCity;
  String sZip;
  String howYouFoundUs;
  //customer billing (b) billing
  String bFirstName;
  String bLastName;
  String bAddress;
  String bCity;
  String bZip;
  //CC info
  int creditCardNumber;
  int confirmationCode;
  int expirationDate;
  DateTime orderDate;
}

enum orderStatus { Received, POIncomplete, InProgress, Finished, Shipped }
