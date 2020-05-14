import 'package:flutter/material.dart';

class ReceiptPage extends StatelessWidget {
  final AsyncSnapshot jobData;
  final int index;
  ReceiptPage({this.jobData, this.index});

  @override
  Widget build(BuildContext context) {
    String receiptNo = jobData.data
        .elementAt(index)["date"]
        .toString()
        .trim()
        .replaceAll("-", "")
        .replaceAll(":", "")
        .replaceAll(".", "");

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.assignment),
        //centerTitle: true,
        title: Text(
          "Receipt_" + receiptNo,
          style: TextStyle(fontFamily: 'Baloo2'),
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: SingleChildScrollView(
        //physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(top:15.0,bottom: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Receipt No: " + receiptNo,
                        style: TextStyle(fontFamily: "Baloo2", fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Date & Time: " +
                            jobData.data
                                .elementAt(index)["date"]
                                .toString()
                                .substring(0, 19),
                        style: TextStyle(fontFamily: "Baloo2", fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25.0, bottom: 15, left: 20, right: 20),
                      child: Text(
                        "Services: ",
                        style: TextStyle(fontFamily: "Baloo2", fontSize: 16),
                      ),
                    ),
                    serviceList(),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25.0, bottom: 15, left: 30, right: 30),
                      child: Text("TOTAL: RM "+jobData.data.elementAt(index)["total"].toStringAsFixed(2).toString(),textAlign: TextAlign.right,style: TextStyle(fontFamily: "Baloo2",fontSize: 16),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25.0, bottom: 15, left: 8, right: 30),
                      child: Text("Service Conducted by: "+jobData.data.elementAt(index)["staff"].toString(),style: TextStyle(fontFamily: "Baloo2",fontSize: 16),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25.0, bottom: 15, left: 8, right: 30),
                      child: Text("Thank you for using our service!\nThis e-receipt is computer generated and doesn't require signature.",textAlign: TextAlign.center,style: TextStyle(fontFamily: "Baloo2"),),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget serviceList() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: jobData.data.elementAt(index)["services"].length,
        itemBuilder: (context, index1) {
          String element =
              jobData.data.elementAt(index)["services"].elementAt(index1);
          return Padding(
            padding: const EdgeInsets.only(
                top: 25.0, bottom: 15, left: 30, right: 30),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  element
                      .toString()
                      .substring(0, element.toString().indexOf(",")),
                  style: TextStyle(fontFamily: "Baloo2", fontSize: 16),
                ),
                Expanded(
                  child: Text(
                      element.toString().substring(
                          element.toString().indexOf(",")+1,
                          element.toString().length),
                      style: TextStyle(fontFamily: "Baloo2", fontSize: 16),textAlign: TextAlign.right,),
                )
              ],
            ),
          );
        });
  }
}
