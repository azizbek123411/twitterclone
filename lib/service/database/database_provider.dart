import 'package:flutter/material.dart';
import 'package:twitterclone/service/auth/auth_service.dart';
import 'package:twitterclone/service/database/database_service.dart';

import '../../models/user.dart';

class DatabaseProvider extends ChangeNotifier {
  final _auth = AuthService();
  final _db = DatabaseService();

  Future<UserProfile?> userProfile(String uid) => _db.getUserFromFirebase(uid);

  Future<void>updateBio(String bio)=>_db.updateUserBioInFirebase(bio);

}
