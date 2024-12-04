import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclone/models/post.dart';
import 'package:twitterclone/service/database/database_provider.dart';
import 'package:twitterclone/ui/widgets/comment_tile.dart';
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
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    final allComment = listeningProvider.getComments(widget.post.id);

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
          ),
          allComment.isEmpty
              ? Center(
                  child: Text(
                    "No comments yet",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: allComment.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final comment = allComment[index];
                    return CommentTile(
                        comment: comment,
                        onUserTap: () {
                          goUserPage(context, comment.uid);
                        });
                  })
        ],
      ),
    );
  }
}
