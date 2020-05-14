import 'package:serviceapp/home_screen/homepage.dart';
import 'package:serviceapp/home_screen/inboxpage.dart';
import 'package:serviceapp/home_screen/jobpage.dart';
import 'package:serviceapp/home_screen/profilepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:serviceapp/firebase/auth.dart';
import 'package:serviceapp/firebase/database.dart';
import 'package:serviceapp/loading.dart';
import 'package:serviceapp/user.dart';

class Home extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Home> {
  User user = new User();
  FireAuth auth = new FireAuth();

  //initialize First Page as Home page
  int bottomSelectedIndex = 0;

  //Controller for PageView
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  //Function to build PageView for scrolling through Pages
  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        HomePage(),
        JobPage(),
        InboxPage(),
        ProfilePage(),
      ],
    );
  }

  //when Page is swiped
  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  //when BottomNav is clicked
  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  //function to retrieve user data
  Future<User> getUserData() async {
    FirebaseUser authUser = await auth.getCurrentUser();
    user = await Database(authUser.uid.toString()).getData();
    //adding to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance().then((value) {
      value.setString('uid',authUser.uid.toString());
      value.setString('name', user.name);
      value.setString('email', user.email);
      value.setString('hp', user.hp);
      print("Shared Preferences saved!");
    });
    return user;
  }

  //main
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: getUserData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? new Scaffold(
//                appBar: AppBar(
//                  automaticallyImplyLeading: false,
//                  title: Text(
//                  'Welcome, '+snapshot.data.name,
//                  style: TextStyle(fontFamily: 'Baloo2'),
//                ),
//                  backgroundColor: Colors.blueGrey[900],
//                  centerTitle: true,),
                body: buildPageView(),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.blue[100],
                  backgroundColor: Colors.blueGrey[900],
                  currentIndex: bottomSelectedIndex,
                  onTap: (index) {
                    bottomTapped(index);
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      title: Text("Home")
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.work),
                        title: Text("Job")
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.inbox),
                        title: Text("Inbox")
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.account_circle),
                        title: Text("Profile")
                    )
                  ],
                ),
              )
            : Loading();
      },
    );
  }

}

