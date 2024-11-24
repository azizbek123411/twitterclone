import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String uid;
  final String name;
  final String username;
  final String message;
  final Timestamp timestamp;
  final int likeCount;
  final List<String> likedBy;

  Post(
      {required this.timestamp,
      required this.uid,
      required this.username,
      required this.name,
      required this.id,
      required this.likeCount,
      required this.likedBy,
      required this.message});

  factory Post.fromDocumnet(DocumentSnapshot doc) {
    return Post(
      timestamp: doc['timestamp'],
      uid: doc['uid'],
      username: doc['username'],
      name: doc['name'],
      id: doc.id,
      likeCount: doc['likeCount'],
      likedBy: List<String>.from(doc['likedBy']),
      message: doc['message'],
    );
  }

  Map<String,dynamic> toMap(){
    return {

      'timestamp':timestamp,
      'uid':uid,
      'username':username,
      'name':name,
      'likeCount':likeCount,
      'likedBy':likedBy,
      'message':message,  

    };
  }
}
