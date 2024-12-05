
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitterclone/models/post.dart';
import 'package:twitterclone/models/user.dart';
import 'package:twitterclone/service/auth/auth_service.dart';

import '../../models/comment.dart';

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

  Future<void> deletePostFromFirebase(String postId) async {
    try {
      await _db.collection('Posts').doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> toggleLikeInFirebase(String postId) async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentReference postDoc = _db.collection('Posts').doc(postId);
      await _db.runTransaction((transaction) async {
        DocumentSnapshot postSnapshot = await transaction.get(postDoc);
        List<String> likedBy = List<String>.from(postSnapshot['likedBy'] ?? []);

        int currentLikeCount = postSnapshot['likes'];
        if (!likedBy.contains(uid)) {
          likedBy.add(uid);
          currentLikeCount++;
        } else {
          likedBy.remove(uid);
          currentLikeCount--;
        }
        transaction.update(postDoc, {
          'likes': currentLikeCount,
          'likedBy': likedBy,
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addCommentInFirebase(String postId, message) async {
    try {
      String uid = _auth.currentUser!.uid;
      UserProfile? user = await getUserFromFirebase(uid);
      Comment newComment = Comment(
        timestamp: Timestamp.now(),
        id: '',
        postId: postId,
        uid: uid,
        message: message,
        name: user!.name,
        username: user.username,
      );

      Map<String, dynamic> newCommentMap = newComment.toMap();
      await _db.collection('Comments').add(newCommentMap);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteCommentInFirebase(String commentId) async {
    try {
      await _db.collection('Comments').doc(commentId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<List<Comment>> getCommentFromFirebase(String postId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('Comments')
          .where('postId', isEqualTo: postId)
          .get();
      return snapshot.docs.map((doc) => Comment.fromDocument(doc)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> reportUserInFirebase(String postId, userId) async {
    final currentUserId = _auth.currentUser!.uid;
    final report = {
      'reportedBy': currentUserId,
      'messageId': postId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    };
    await _db.collection("Reports").add(report);
  }

  Future<void> blockUserInFirebase(String userId) async {
    final currentUserId = _auth.currentUser!.uid;
    await _db
        .collection("Users")
        .doc(currentUserId)
        .collection('BlockedUsers')
        .doc(userId)
        .set({});
  }

  Future<void> unblockUserInFirebase(String blockedUserId) async {
    final currentUserId = _auth.currentUser!.uid;
    await _db
        .collection('Users')
        .doc(currentUserId)
        .collection('BlockedUsers')
        .doc(blockedUserId)
        .delete();
  }

  Future<List<String>> getBlockedUidsFromFirebase() async {
    final currentUserId = _auth.currentUser!.uid;

    final snapshot = await _db
        .collection('Users')
        .doc(currentUserId)
        .collection('BlockedUsers')
        .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }
}
