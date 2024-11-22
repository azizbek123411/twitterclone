import 'package:flutter/material.dart';
import 'package:twitterclone/ui/pages/drawer_screens/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    );
  }
}
