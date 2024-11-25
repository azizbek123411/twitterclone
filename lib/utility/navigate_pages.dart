import 'package:flutter/material.dart';
import 'package:twitterclone/models/post.dart';
import 'package:twitterclone/ui/pages/drawer_screens/profile.dart';

import '../ui/pages/home/post_page.dart';

void goUserPage(BuildContext context, String uid) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProfilePage(uid: uid),
    ),
  );
}

void goPostPage(BuildContext context, Post post) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PostPage(
        post: post,
      ),
    ),
  );
}
