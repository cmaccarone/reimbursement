import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reimbursement/widgets.dart';

class RequestApprovalScreen extends StatefulWidget {
  @override
  _RequestApprovalScreenState createState() => _RequestApprovalScreenState();
}

class _RequestApprovalScreenState extends State<RequestApprovalScreen> {
  bool _isExpanded = false;

  List<Widget> table1 = [
    ListViewCell(),
    ListViewCell(),
    Center(
        child: Text(
      'Add New Trip Request',
      style: TextStyle(color: Colors.blueAccent),
    ))
  ];

  void _toogleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Submit Travel Request"),
        ),
        body: Column(
          children: <Widget>[
            Column(
              children: table1,
            ),
            ExpandedSection(
              expand: _isExpanded,
              child: Container(
                width: double.infinity,
                color: Colors.red,
                padding: EdgeInsets.all(25.0),
                child: Column(
                  children: <Widget>[
                    SignInTextFields(
                      inputLabel: "Description",
                    )
                  ],
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  _toogleExpand();
                });
                print(table1);
              },
              child: CircleAvatar(
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListViewCell extends StatelessWidget {
  const ListViewCell({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              Icons.airplanemode_active,
              color: Colors.blueAccent,
              size: 50,
            ),
            SizedBox(
              width: 50,
            ),
            Column(
              children: <Widget>[
                Text("Called Convention 2020"),
                Text(
                  "Pending Approval",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            SizedBox(
              width: 50,
            ),
            Text(
              "3456.99",
              style: TextStyle(color: Colors.green),
            )
          ],
        ),
        Text("--------------------------------------------")
      ],
    );
  }
}

class ExpandedSection extends StatefulWidget {
  final Widget child;
  final bool expand;
  ExpandedSection({this.expand = false, this.child});

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection>
    with SingleTickerProviderStateMixin {
  AnimationController expandController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    Animation curve = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment: 1.0, sizeFactor: animation, child: widget.child);
  }
}
