import 'package:flutter/material.dart';
import 'package:twitterclone/models/post.dart';
import 'package:twitterclone/ui/widgets/my_post_tile.dart';
import 'package:twitterclone/utility/navigate_pages.dart';

class PostPage extends StatefulWidget {
  final Post post;

  const PostPage({
    super.key,
    required this.post,
  });

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: const Text(
          "Post",
        ),
      ),
      body: ListView(
        children: [
          MyPostTile(
            post: widget.post,
            onUserTap: () => goUserPage(context, widget.post.uid),
            onPostTap: () {},
          )
        ],
      ),
    );
  }
}
