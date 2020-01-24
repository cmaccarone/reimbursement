import 'dart:ffi';

class Receipt {
  Double amount;
  String vendor;
  DateTime date;
  String pictureURL;
  bool mightHaveAlreadyBeenSubmitted;

  Receipt(
      {this.amount,
      this.vendor,
      this.date,
      this.pictureURL,
      this.mightHaveAlreadyBeenSubmitted});
  //TODO: check if this receipt has ever been entered before. if it has give an error, also if the user chooses to continue set mightHaveAlreadyBeenSubmitted to true.
}
