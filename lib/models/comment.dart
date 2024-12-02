import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String uid;
  final String message;
  final String postId;
  final String username;
  final String name;
  final Timestamp timestamp;

  Comment({
    required this.timestamp,
    required this.id,
    required this.postId,
    required this.uid,
    required this.message,
    required this.name,
    required this.username,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      timestamp: doc['timestamp'],
      id: doc.id,
      postId: doc['postId'],
      uid: doc['uid'],
      message: doc['message'],
      name: doc['name'],
      username: doc['username'],
    );
  }


  Map<String,dynamic> toMap(){
    return {
      'timestamp':timestamp,
      'id':id,
      'postId':postId,
      "uid":uid,
      'message':message,
      'name':name,
      'username':username
    };
  }
}
