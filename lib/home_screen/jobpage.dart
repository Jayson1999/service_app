import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:serviceapp/receipt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class JobPage extends StatefulWidget {
  @override
  _JobPageState createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await getData();
    setState(() {
      _JobPageState();
    });
    _refreshController.refreshCompleted();
  }

  Future<List> getData() async {
    List list = new List();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = await prefs.getString("uid");
    await Firestore.instance
        .collection("User")
        .document(uid)
        .collection("Booking").orderBy("date",descending: true)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        list.add(element);
      });
    });
    return await list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.work),
        //centerTitle: true,
        title: Text(
        "Jobs",
          style: TextStyle(fontFamily: 'Baloo2'),
      ),
        backgroundColor: Colors.blueGrey[900],
    ),
      body: SmartRefresher(
        enablePullDown: true,
        header: WaterDropHeader(),
        footer: ClassicFooter(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length < 1) {
                return Center(
                    child: Text(
                  "Looks like you have not placed any booking yet.\nTap on the Service Cards on the Home Page to Proceed",
                  style: TextStyle(
                    fontFamily: "Baloo2",
                  ),
                  textAlign: TextAlign.center,
                ));
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top:20.0,bottom: 20.0,left: 10.0,right: 10.0),
                  child: SingleChildScrollView(
                    child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          bool done = false;
                          if (snapshot.data.elementAt(index)["status"] == "done") {
                            done = true;
                          }
                          return InkWell(
                            onTap:done? (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReceiptPage(jobData: snapshot, index: index)),
                              );
                            }:null,
                            child: Card(
                                shadowColor: Colors.blueGrey[900],
                                child: ListTile(
                                  leading: done
                                  ? Icon(
                                      Icons.assignment_turned_in,
                                      color: Colors.green[600],
                                    )
                                  : Icon(
                                      Icons.assignment,
                                      color: Colors.amber[700],
                                    ),
                                  title: Text(
                                  snapshot.data.elementAt(index)["date"],
                                  style: TextStyle(fontFamily: "Baloo2"),
                              ),
                                  subtitle: Text(
                                  "RM " +
                                    snapshot.data.elementAt(index)["total"].toStringAsFixed(2),
                                  style: TextStyle(fontFamily: "Baloo2"),
                              ),
                                  trailing: Text(
                                "Status: " + snapshot.data.elementAt(index)["status"],
                                style: TextStyle(
                                    fontFamily: "Baloo2",
                                    color:
                                        done ? Colors.green[600] : Colors.amber[700]),
                              ),
                            )),
                          );
                        }),
                  ),
                );
              }
            } else {
              return Center(
                child: SpinKitPouringHourglass(
                  color: Colors.blueGrey[900],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
