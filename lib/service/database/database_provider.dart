import 'package:flutter/material.dart';
import 'package:twitterclone/service/auth/auth_service.dart';
import 'package:twitterclone/service/database/database_service.dart';

import '../../models/comment.dart';
import '../../models/post.dart';
import '../../models/user.dart';

class DatabaseProvider extends ChangeNotifier {
  final _auth = AuthService();
  final _db = DatabaseService();

  Future<UserProfile?> userProfile(String uid) => _db.getUserFromFirebase(uid);

  Future<void> updateBio(String bio) => _db.updateUserBioInFirebase(bio);

  List<Post> _allPosts = [];

  List<Post> get allPosts => _allPosts;

  Future<void> postMessage(String message) async {
    await _db.postMessageInFirebase(message);
    await loadAllPosts();
  }

  Future<void> loadAllPosts() async {
    final allPosts = await _db.getAllPostsFromFirebase();

    final blockedUserIds = await _db.getBlockedUidsFromFirebase();
    _allPosts =
        allPosts.where((post) => !blockedUserIds.contains(post.uid)).toList();

    _allPosts = allPosts;
    initializeLikeMap();

    notifyListeners();
  }

  List<Post> filterUserPosts(String uid) {
    return _allPosts.where((post) => post.uid == uid).toList();
  }

  Future<void> deletePost(String postId) async {
    await _db.deletePostFromFirebase(postId);
    await loadAllPosts();
  }

  Map<String, int> _likeCounts = {};

  List<String> _likedPosts = [];

  bool isPostLikedByCurrentUser(String postId) => _likedPosts.contains(postId);

  int getLikeCount(String postId) => _likeCounts[postId] ?? 0;

  void initializeLikeMap() {
    final currentUserId = _auth.getCurrentUid();

    _likedPosts.clear();

    for (var post in _allPosts) {
      _likeCounts[post.id] = post.likeCount;

      if (post.likedBy.contains(currentUserId)) {
        _likedPosts.add(post.id);
      }
    }
  }

  Future<void> toggleLike(String postId) async {
    final likedPostOriginal = _likedPosts;
    final likeCountsOriginal = _likeCounts;

    if (_likedPosts.contains(postId)) {
      _likedPosts.remove(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) - 1;
    } else {
      _likedPosts.add(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) + 1;
    }
    notifyListeners();

    try {
      await _db.toggleLikeInFirebase(postId);
    } catch (e) {
      _likedPosts = likedPostOriginal;
      _likeCounts = likeCountsOriginal;
      notifyListeners();
    }
  }

  final Map<String, List<Comment>> _comments = {};

  List<Comment> getComments(String postId) => _comments[postId] ?? [];

  Future<void> loadComments(String postId) async {
    final allComments = await _db.getCommentFromFirebase(postId);
    _comments[postId] = allComments;
    notifyListeners();
  }

  Future<void> addComment(String postId, message) async {
    await _db.addCommentInFirebase(postId, message);
    await loadComments(postId);
  }

  Future<void> deleteComment(String commentId, postId) async {
    await _db.deleteCommentInFirebase(commentId);
    await loadComments(postId);
  }

  List<UserProfile> _blockedUsers = [];

  List<UserProfile> get blockedUsers => _blockedUsers;

  Future<void> loadAllBlockedUsers() async {
    final blockedUsersId = await _db.getBlockedUidsFromFirebase();
    final blockedUsersData = await Future.wait(
      blockedUsersId.map(
        (id) => _db.getUserFromFirebase(id),
      ),
    );
    _blockedUsers = blockedUsersData.whereType<UserProfile>().toList();
    notifyListeners();
  }

  Future<void> blockUsers(String userId) async {
    await _db.blockUserInFirebase(userId);
    await loadAllPosts();
    notifyListeners();
  }

  Future<void> unblockUsers(String blockedUserId) async {
    await _db.unblockUserInFirebase(blockedUserId);
    await loadAllBlockedUsers();
    await loadAllPosts();
    notifyListeners();
  }

  Future<void> reportUser(String postId, userId) async {
    await _db.reportUserInFirebase(postId, userId);
  }

  final Map<String, List<String>> _followers = {};
  final Map<String, List<String>> _following = {};
  final Map<String, int> _followerCount = {};
  final Map<String, int> _followingCount = {};

  int getFollowerCount(String uid) => _followerCount[uid] ?? 0;

  int getFollowingCount(String uid) => _followingCount[uid] ?? 0;

  Future<void> loadUsersFollowers(String uid) async {
    final listOfFollowersUids = await _db.getFollowersUidsFromFirebase(uid);

    _followers[uid] = listOfFollowersUids;
    _followerCount[uid] = listOfFollowersUids.length;
    notifyListeners();
  }

  Future<void> loadUsersFollowing(String uid) async {
    final listOfFollowingUids = await _db.getFollowingUidsFromFirebase(uid);

    _following[uid] = listOfFollowingUids;
    _followingCount[uid] = listOfFollowingUids.length;
    notifyListeners();
  }

  Future<void> followUser(String targetUserId) async {
    final currentUserId = _auth.getCurrentUid();

    _following.putIfAbsent(currentUserId, () => []);
    _followers.putIfAbsent(targetUserId, () => []);

    if (!_followers[targetUserId]!.contains(currentUserId)) {
      _followers[targetUserId]!.add(currentUserId);
      _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) + 1;
      _following[currentUserId]!.add(targetUserId);
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) + 1;
    }
    notifyListeners();

    try {
      await _db.followUserInFirebase(targetUserId);
      await loadUsersFollowers(currentUserId);
      await loadUsersFollowing(currentUserId);
    } catch (e) {
      _followers[targetUserId]?.remove(currentUserId);
      _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) - 1;
      _following[currentUserId]?.remove(targetUserId);
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) - 1;

      notifyListeners();
    }
  }

  Future<void> unfollowUser(String targetUserId) async {
    final currentUserId = _auth.getCurrentUid();

    _following.putIfAbsent(currentUserId, () => []);
    _followers.putIfAbsent(targetUserId, () => []);

    if(_followers[targetUserId]!.contains(currentUserId)){
      _followers[targetUserId]?.remove(currentUserId);

      _followerCount[targetUserId]=(_followerCount[targetUserId]??1)-1;

      _following[currentUserId]?.remove(targetUserId);

      _followingCount[currentUserId]=(_followingCount[currentUserId]??1)-1;


    }
notifyListeners();

    try{
      await _db.unfollowUserInFirebase(targetUserId);
      await loadUsersFollowers(currentUserId);
      await loadUsersFollowing(currentUserId);
    }catch(e){

      _followers[targetUserId]?.add(currentUserId);
      _followerCount[targetUserId]=(_followerCount[targetUserId]??0)+1;

      _following[currentUserId]?.add(targetUserId);
      _followingCount[currentUserId]=(_followingCount[currentUserId]??0)+1;
      notifyListeners();
    }

  }

  bool isFollowing(String uid){
    final currentUserId=_auth.getCurrentUid();
    return _followers[uid]?.contains(currentUserId)??false;
  }
}
