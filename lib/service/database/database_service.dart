import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitterclone/models/post.dart';
import 'package:twitterclone/models/user.dart';
import 'package:twitterclone/service/auth/auth_service.dart';

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

  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      DocumentSnapshot userDoc = await _db.collection("Users").doc(uid).get();

      return UserProfile.fromDocument(userDoc);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> updateUserBioInFirebase(String bio) async {
    String uid = AuthService().getCurrentUid();

    try {
      await _db.collection('Users').doc(uid).update({'bio': bio});
    } catch (e) {
      print(e);
    }
  }

  Future<void> postMessageInFirebase(String message) async {
    try {
      String uid = _auth.currentUser!.uid;
      UserProfile? user = await getUserFromFirebase(uid);
      Post newPost = Post(
        timestamp: Timestamp.now(),
        uid: uid,
        username: user!.username,
        name: user.name,
        id: '',

        /// firebase will auto create
        likeCount: 0,
        likedBy: [],
        message: message,
      );
      Map<String, dynamic> newPostMap = newPost.toMap();
      await _db.collection("Posts").add(newPostMap);
    } catch (e) {
      print(e);
    }
  }

  Future<List<Post>> getAllPostsFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection("Posts")
          .orderBy('timestamp', descending: true)
          .get();
      return snapshot.docs.map((doc) => Post.fromDocumnet(doc)).toList();
    } catch (e) {
      return [];
    }
  }


  Future<void> deletePostFromFirebase(String postId)async{
    try{
      await _db.collection('Posts').doc(postId).delete();
    }
        catch(e){
      print(e);
        }
  }
}
