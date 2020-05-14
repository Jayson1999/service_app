import 'package:flutter/material.dart';
import 'package:serviceapp/firebase/auth.dart';
import 'package:serviceapp/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Future getUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                snapshot.data.getString("name"),
                style: TextStyle(fontFamily: 'Baloo2'),
              ),
              backgroundColor: Colors.blueGrey[900],
            ),
            body: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Center(
                      child: Image.network("https://cdn3.iconfinder.com/data/icons/internet-and-web-4/78/internt_web_technology-13-512.png",width: 250,height: 250,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Center(child: Text("Name: "+snapshot.data.getString("name"),style: TextStyle(fontSize: 20,fontFamily: "Baloo2",),)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Center(child: Text("Email: "+snapshot.data.getString("email"),style: TextStyle(fontSize: 20,fontFamily: "Baloo2",),)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Center(child: Text("Handphone No.: "+snapshot.data.getString("hp"),style: TextStyle(fontSize: 20,fontFamily: "Baloo2",),)),
                    ),
                    ButtonTheme(
                      buttonColor: Colors.redAccent,
                      child: RaisedButton(
                        onPressed: ()async{
                          await FireAuth().signOutUser();
                        },
                        child: Text("LOG OUT",style: TextStyle(fontFamily: "Baloo2",color: Colors.white),),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }
        else{
          return Loading();
        }
      },
    );
  }

}
