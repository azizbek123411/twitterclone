import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclone/service/database/database_provider.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key});

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersState();
}

class _BlockedUsersState extends State<BlockedUsersPage> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    loadBlockedUsers();
  }

  Future<void> loadBlockedUsers() async {
    await databaseProvider.loadAllBlockedUsers();
  }

  void _showUnblockConfirmationBox(String userId) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Unblock User'),
            content: const Text('Are you sure you want to unblock this user?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await databaseProvider.unblockUsers(userId);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User unblocked'),
                    ),
                  );
                },
                child: const Text('Unblock'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final blockedUsers = listeningProvider.blockedUsers;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Blocked Users'.toUpperCase(),
          style: const TextStyle(letterSpacing: 3),
        ),
      ),
      body: blockedUsers.isEmpty
          ? Center(
              child: Text(
                'No blocked users',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 20,
                ),
              ),
            )
          : ListView.builder(
              itemCount: blockedUsers.length,
              itemBuilder: (context, index) {
                final user = blockedUsers[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text("@${user.username}"),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.block,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => _showUnblockConfirmationBox(user.uid),
                  ),
                );
              },
            ),
    );
  }
}
