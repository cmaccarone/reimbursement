import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:option_picker/option_picker.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/model/receipt.dart';
import 'package:reimbursement/model/tripApproval.dart';
import 'package:reimbursement/providers/reimbursement_provider.dart';
import 'package:reimbursement/screens/Request Approvals/ReviewReceiptScreen.dart';
import 'package:reimbursement/screens/misc_reusable/constants.dart';

class ReceiptScreen extends StatefulWidget {
  final TripApproval tripApproval;
  final bool completedOnly;

  ReceiptScreen({this.tripApproval, this.completedOnly});

  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  TextEditingController descriptionController = TextEditingController();

  TextEditingController startDateController = TextEditingController();

  TextEditingController endDateController = TextEditingController();

  TextEditingController costController = TextEditingController();

  TextEditingController notesController = TextEditingController();

  bool completedOnly;
  bool _isExpanded = false;
  String description;
  String startDate;
  String endDate;
  String cost;
  String notes;
  double totalReceiptVale;
  String picturePath;
  Stream _stream;

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
  void didChangeDependencies() {
    _stream = Provider.of<ReimbursementProvider>(context).reimbursementStream;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
          title: Column(
        children: <Widget>[
          Text("\"${widget.tripApproval.tripName}\" Receipts"),
          Text("\$${widget.tripApproval.requestedCost}")
          //todo replace text with actual total amount.
        ],
      )),
      body: Column(
        children: <Widget>[
          StreamBuilder<List<Receipt>>(
            stream: _stream,
            builder:
                (BuildContext context, AsyncSnapshot<List<Receipt>> snapshot) {
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.white));
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text(
                    'no connection',
                    style: TextStyle(color: Colors.white),
                  );
                case ConnectionState.waiting:
                  return Text('Awaiting bids...',
                      style: TextStyle(color: Colors.white));
                case ConnectionState.active:
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.length ?? 0,
                        itemBuilder: (context, index) {
                          print(snapshot.data[index].vendor);
                          return Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            height: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 120,
                                  child: Image(
                                    height: 120,
                                    fit: BoxFit.cover,
                                    image: NetworkImage(snapshot
                                            .data[index].photoURLS[index]) ??
                                        NetworkImage(
                                            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FMonkey_selfie_copyright_dispute&psig=AOvVaw22FEgkUgxpWN4UcY3xhtBH&ust=1586753462153000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCJDpsbaL4ugCFQAAAAAdAAAAABAD"),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    color: Colors.blueGrey,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              snapshot.data[index].vendor,
                                              style: kReceiptCellTitleTextStyle,
                                            ),
                                            Text(
                                              DateFormat('MMMM dd, yyyy')
                                                  .format(snapshot
                                                      .data[index].receiptDate)
                                                  .toString(),
                                              style:
                                                  kReceiptCellSubTitleTextStyle,
                                            ),
                                            Text(
                                              snapshot.data[index].reimbursed
                                                  ? "Submitted"
                                                  : "Pending".toString(),
                                              style:
                                                  kReceiptCellSubTitleTextStyle,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "\$${snapshot.data[index].amount.toStringAsFixed(2)}",
                                          style: kReceiptCellSubTitleTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  );
                case ConnectionState.done:
              }
              return null; // unreachable
            },
          ),
          widget.completedOnly
              ? SizedBox()
              : FlatButton(
                  onPressed: () async {
                    OptionPicker.show(
                      context: context,
                      title: "Choose a Photo",
                      subtitle: "Pick a Source",
                      firstButtonText: "Gallery",
                      secondButtonText: "Take Picture",
                      cancelText: "Cancel",
                      onPressedFirst: () async {
                        var image = await ImagePicker.pickImage(
                            source: ImageSource.gallery, imageQuality: 50);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReviewReceiptScreen(
                                      receiptImage: [image],
                                      forTrip: widget.tripApproval,
                                    )));
                      },
                      onPressedSecond: () async {
                        var image = await ImagePicker.pickImage(
                            source: ImageSource.camera, imageQuality: 50);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReviewReceiptScreen(
                                      receiptImage: [image],
                                      forTrip: widget.tripApproval,
                                    )));
                      },
                    );
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.add),
                  ),
                ),
          widget.completedOnly
              ? SizedBox()
              : Center(
                  child: Text(
                  'Add Reciept',
                  style: TextStyle(color: Colors.blueAccent),
                ))
        ],
      ),
    );
  }
}
