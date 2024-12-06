import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclone/service/auth/auth_service.dart';
import 'package:twitterclone/ui/theme/theme_provider.dart';
import 'package:twitterclone/ui/widgets/settings_tile.dart';
import 'package:twitterclone/utility/app_padding.dart';
import 'package:twitterclone/utility/screen_utils.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  void confirmDeletion(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete Account'),
              content:
                  const Text('Are you sure you want to delete your account?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await AuthService().deleteAccount();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  },
                  child: const Text('Delete'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text(
          'settings'.toUpperCase(),
          style: const TextStyle(
            letterSpacing: 3,
          ),
        ),
      ),
      body: Padding(
        padding: Dis.only(lr: 10.w),
        child: Column(
          children: [
            SettingsTile(
              text: 'Dark Mode',
              action: Switch(
                activeColor: Colors.blue,
                inactiveTrackColor: Colors.grey.shade400,
                inactiveThumbColor: Colors.white,
                value: Provider.of<ThemeProvider>(context, listen: false)
                    .isDarkMode,
                onChanged: (bool value) {
                  return Provider.of<ThemeProvider>(
                    context,
                    listen: false,
                  ).toggleTheme();
                },
              ),
            ),

            SettingsTile(
                text: 'Delete account',
                action: IconButton(
                  onPressed: () {
                    confirmDeletion(context);
                  },
                  icon: Icon(
                    Icons.delete,
                  ),
                ))

            // SettingsTile(
            //   text: 'Blocked Users',
            //   action: IconButton(
            //     onPressed:()=> goToBlockedUsersPage(context),
            //     icon: const Icon(
            //       Icons.arrow_forward,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
