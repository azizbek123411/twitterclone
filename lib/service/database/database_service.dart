import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitterclone/models/user.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> saveUserInfoInFirebase(
      {required String name, required String email}) async {
    String uid = _auth.currentUser!.uid;

    String username = email.split('@')[0];

    UserProfile user = UserProfile(
      uid: uid,
      email: email,
      name: name,
      username: username,
      bio: 'bio',
    );

    final userMap = user.toMap();

    await _db.collection("Users").doc(uid).set(userMap);
  }


  Future<UserProfile? >getUserFromFirebase(String uid)async{
    try{
      DocumentSnapshot userDoc=await _db.collection("Users").doc(uid).get();

      return UserProfile.fromDocument(userDoc);
    }catch(e){
      print(e);
      return null;
    }
  }
}
