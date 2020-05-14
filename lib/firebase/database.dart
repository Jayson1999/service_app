import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serviceapp/user.dart';

class Database{

  String _uid;
  Database(this._uid);

  final CollectionReference userCollection = Firestore.instance.collection("User");
  final CollectionReference promoCollection = Firestore.instance.collection("Promo");

  //Update / Add user document
  Future updateUser(String name, String email, String hp) async {
    return await userCollection.document(_uid).setData({
      'name' : name,
      'email' : email,
      'hp' : hp,
    });
  }

  //Get User data
  Future<User> getData() async {
    User user = new User();
    await userCollection.document(_uid).get().then((value) {
      user.name = value.data['name'];
      user.email = value.data['email'];
      user.hp = value.data['hp'];
    });

    if(user.toString()!=null) {
      print(_uid);
      print("CURRENT: "+user.name);
      return await user;
    }
    else{
      print("It's NULL!");
    }
  }

}
