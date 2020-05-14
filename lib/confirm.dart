import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:serviceapp/home_screen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmPage extends StatelessWidget {
  final List<String> services;
  ConfirmPage({this.services});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Booking Confirmation",
          style: TextStyle(fontFamily: 'Baloo2'),
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: confirmList(context),
    );
  }

  Widget confirmList(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        ListView.builder(
            shrinkWrap: true,
            itemCount: services.length,
            itemBuilder: (context, index) {
              String service = services.elementAt(index);
              return Card(
                child: ListTile(
                  leading: Icon(
                    Icons.check,
                    color: Colors.green[600],
                  ),
                  contentPadding: EdgeInsets.all(24),
                  title: Text(
                    (index + 1).toString() +
                        ". " +
                        service.substring(0, service.indexOf(",")),
                    style: TextStyle(
                        fontFamily: "Baloo2",
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  subtitle: Text(
                    "RM " +
                        service
                            .substring(service.indexOf(","), service.length)
                            .replaceAll(", ", ""),
                    style: TextStyle(fontFamily: "Baloo2", fontSize: 16),
                    textAlign: TextAlign.right,
                  ),
                ),
              );
            }),
        Container(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
            "Total: RM " + _total().toStringAsFixed(2),
            style: TextStyle(fontFamily: "Baloo2", fontSize: 20),
            textAlign: TextAlign.right,
          ),
        )),
        ButtonTheme(
          buttonColor: Colors.green[600],
          child: RaisedButton(
            child: Text("Place Booking",style: TextStyle(fontFamily: "Baloo2",color: Colors.white),),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
            ),
            onPressed: () async {
              await _saveToFirestore();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(20.0))),
                    title: new Text("Booking Placed!",
                        style: TextStyle(
                            fontFamily: "Baloo2",
                            fontWeight: FontWeight.bold)),
                    content: new Text(
                      "A service staff will attend to you soon! You can check the status and view the receipt at the Job Page.",
                      style: TextStyle(
                          fontFamily: "Baloo2",
                          color: Colors.blueGrey[900]),
                    ),
                    actions: <Widget>[
                      new FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                Home()), (Route<dynamic> route) => false);
                          },
                          child: new Text("OK"))
                    ],
                  );
                },
              );
            },
          ),
        ),
        ButtonTheme(
          buttonColor: Colors.blueGrey[900],
          child: RaisedButton(
            child: Text("Cancel",style: TextStyle(fontFamily: "Baloo2",color: Colors.white),),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
            ),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        )
      ],
    );
  }

  double _total() {
    double price = 0;
    services.forEach((element) {
      price = price +
          (double.parse(element
              .substring(element.indexOf(","), element.length)
              .replaceAll(", ", "")));
    });
    return price;
  }

  Future _saveToFirestore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = await prefs.getString("uid");
    String currentTime = DateTime.now().toString();
    await Firestore.instance.collection("User").document(uid).collection("Booking").document(currentTime).setData({
      'date':currentTime,
      'status':"awaiting",
      'services': services,
      'staff':"",
      "total": _total()
    });
  }

}
