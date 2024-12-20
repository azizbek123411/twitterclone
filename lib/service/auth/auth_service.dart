import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitterclone/service/database/database_service.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  User? getCurrentUser() => _auth.currentUser;

  String getCurrentUid() => _auth.currentUser!.uid;

  /// LOGIN METHOD

  Future<UserCredential> loginEmailPassword(String email, password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }


  /// SIGN UP METHOD
  Future<UserCredential> registerEmailPassword(String email, password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

/// LOG OUT METHOD
  Future<void> logout()async{
    await _auth.signOut();
  }

  /// DELETE METHOD
Future<void> deleteAccount()async{
    User? user=getCurrentUser();
    if(user != null){
      await DatabaseService().deleteUserInfoFromFirebase(user.uid);
      await user.delete();
    }
}

}
