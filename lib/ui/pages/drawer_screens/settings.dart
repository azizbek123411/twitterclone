import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclone/ui/theme/theme_provider.dart';
import 'package:twitterclone/ui/widgets/settings_tile.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

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
      body: Column(
        children: [
          SettingsTile(
            text: 'Dark Mode',
            action: Switch(
              activeColor: Colors.blue,
              inactiveTrackColor: Colors.grey.shade400,
              inactiveThumbColor: Colors.white,
              value:
                  Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
              onChanged: (bool value) {
                return Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
          )
        ],
      ),
    );
  }
}
