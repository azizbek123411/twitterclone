import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclone/service/database/database_provider.dart';
import 'package:twitterclone/ui/pages/drawer_screens/drawer.dart';
import 'package:twitterclone/ui/widgets/input_alert_box.dart';
import 'package:twitterclone/ui/widgets/my_post_tile.dart';
import 'package:twitterclone/utility/navigate_pages.dart';

import '../../../models/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);

  late final databaseProvider = Provider.of<DatabaseProvider>(
    context,
    listen: false,
  );

  Future<void> loadAllPosts() async {
    await databaseProvider.loadAllPosts();
  }

  final _messageController = TextEditingController();

  void _openPostMessageBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
        textEditingController: _messageController,
        hintText: "Type your thoughts..",
        onPressed: () async {
          await postMessage(_messageController.text);
        },
        onPressedText: 'Post',
      ),
    );
  }

  Future<void> postMessage(String message) async {
    await databaseProvider.postMessage(message);
  }

  @override
  void initState() {
    super.initState();
    loadAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: MyDrawer(),
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text(
          'home'.toUpperCase(),
          style: const TextStyle(
            letterSpacing: 3,
          ),
        ),
      ),
      body: _buildAllPosts(listeningProvider.allPosts),
      floatingActionButton: FloatingActionButton(
        onPressed: _openPostMessageBox,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAllPosts(List<Post> posts) {
    return posts.isEmpty
        ? const Center(
            child: Text('Nothing here...'),
          )
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return MyPostTile(
                post: post,
                onUserTap: () => goUserPage(
                  context,
                  post.uid,
                ), onPostTap: ()=>goPostPage(context,post),
              );
            },
          );
  }
}
