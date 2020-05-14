import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:serviceapp/confirm.dart';

final Firestore db = Firestore.instance;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Column(
        children: <Widget>[
          SlideShow(),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              "Services",
              style: TextStyle(fontFamily: "Baloo2", fontSize: 24),
            ),
          ),
          ServiceCards(),
        ],
      ),
    ]);
  }
}

class SlideShow extends StatelessWidget {
  //Get Promo Image url from Firestore function
  Future<List<CachedNetworkImage>> loadImage() async {
    List<CachedNetworkImage> imgList = new List();
    await db.collection("News").getDocuments().then((value) {
      value.documents.forEach((element) {
        imgList.add(CachedNetworkImage(
          imageUrl: element.data["url"],
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child:
                  CircularProgressIndicator(value: downloadProgress.progress)),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ));
      });
    });
    return imgList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadImage(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length < 1) {
            return Padding(
              padding: const EdgeInsets.only(top: 143.0, bottom: 143),
              child: Center(
                  child: Text(
                "No News Found!",
                style: TextStyle(fontFamily: "Baloo2"),
              )),
            );
          } else {
            return Container(
              height: 300,
              child: Carousel(
                boxFit: BoxFit.cover,
                images: snapshot.data,
                animationCurve: Curves.fastOutSlowIn,
                autoplayDuration: Duration(seconds: 5),
                dotSize: 4.0,
                indicatorBgPadding: 2.0,
                dotBgColor: Colors.grey.withOpacity(0.4),
              ),
            );
          }
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
            child: SpinKitPouringHourglass(
              color: Colors.blueGrey[900],
            ),
          );
        }
      },
    );
  }
}

class ServiceCards extends StatefulWidget {
  @override
  _ServiceCardsState createState() => _ServiceCardsState();
}

class _ServiceCardsState extends State<ServiceCards> {
  //Get Services Card from Firestore
  Future<List<Padding>> loadImage() async {
    List<Padding> imgList = new List();
    await db.collection("Services").getDocuments().then((value) {
      value.documents.forEach((element) {
        imgList.add(Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: CachedNetworkImage(
            imageUrl: element.data["img"],
            imageBuilder: (context, imageProvider) {
              return InkWell(
                onTap: (){
                  showServices(element);
                    },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(new Radius.circular(10.0)),
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black,
                          blurRadius: 3,
                          spreadRadius: 1,
                          offset: new Offset(0, 2))
                    ],
                    image: DecorationImage(
                        colorFilter: new ColorFilter.mode(
                            Colors.brown.withOpacity(0.3), BlendMode.color),
                        image: imageProvider,
                        fit: BoxFit.cover),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        element.data["title"],
                        style: TextStyle(
                            fontFamily: "Baloo2",
                            fontSize: 18,
                            backgroundColor: Colors.black.withOpacity(0.65),
                            color: Colors.white
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress)),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ));
      });
    });
    return imgList;
  }

  showServices(DocumentSnapshot element){
    bool selected = false;
    List<String> choicesName = new List();
    print(element.data["title"]+" is pressed!");
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(20.0))),
                title: new Text(
                  element.data["title"],
                  style: TextStyle(
                      fontFamily: 'Baloo2',
                      fontWeight: FontWeight.bold),
                ),
                content: Container(
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Please Select an Option to Proceed for Booking\n",
                        style: TextStyle(
                          color: Colors.blueGrey[900],
                          fontFamily: 'Baloo2',
                        ),
                      ),
                      ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: List.from(element.data["choices"]).length,
                          itemBuilder:(context, index){
                            return StatefulBuilder(
                              builder: (context, _setStateCard){
                                String service = List.from(element.data["choices"]).elementAt(index).toString();
                                return Card(
                                  color: selected ? Colors.green[600] : Colors.blueGrey[900],
                                  child: StatefulBuilder(
                                    builder: (context, _setStateCheck){
                                      return CheckboxListTile(
                                        checkColor: Colors.blueGrey[900],
                                        activeColor: Colors.white,
                                        value: selected,
                                        selected: selected,
                                        onChanged: (value){
                                          _setStateCard((){
                                            selected = value;
                                          });
                                          _setStateCheck(() {
                                            selected = value;
                                            if(selected){
                                              choicesName.add(service);
                                            }
                                            else if(choicesName.length > 0){
                                              choicesName.remove(service);
                                            }
                                          });
                                        },
                                        title: Text(service.substring(0,service.indexOf(",")),style: TextStyle(fontFamily: "Baloo2",color: Colors.white),),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.only(top:20.0,bottom: 20.0),
                        child: ButtonTheme(
                          buttonColor: selected ? Colors.green[600] : Colors.blueGrey[900],
                          child: new RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              onPressed: () {
                                if(choicesName.length<1){
                                  //Show error message
                                  showNullOption();
                                }
                                else {
                                  print(element.data["title"] + choicesName.toString());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ConfirmPage(
                                          services: choicesName,
                                        )),
                                  );
                                }
                                // Navigator.of(context).pop();
                              },
                              child: new Text("Proceed for Booking ",style: TextStyle(color: Colors.white,fontFamily: "Baloo2"),)
                          ),
                        ),
                      ),
                      FlatButton(
                        child: Text("Cancel",style: TextStyle(fontFamily: "Baloo2",color: Colors.blueGrey[900]),),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  showNullOption(){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              "Proceed Failed!",
              style: TextStyle(
                  fontFamily: 'Baloo2',
                  fontWeight: FontWeight.bold),
            ),
            content: new Text(
              "You haven't selected any option!",
              style: TextStyle(
                color: Colors.redAccent,
                fontFamily: 'Baloo2',
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text("OK"))
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadImage(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length < 1) {
            return Padding(
              padding: const EdgeInsets.only(top: 143.0, bottom: 143),
              child: Center(
                  child: Text(
                "No Services Found!",
                style: TextStyle(fontFamily: "Baloo2"),
              )),
            );
          } else {
            return ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return snapshot.data[index];
                });
          }
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
            child: SpinKitPouringHourglass(
              color: Colors.blueGrey[900],
            ),
          );
        }
      },
    );
  }

}
