import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitterclone/service/auth/sign_in_or_up.dart';
import 'package:twitterclone/ui/pages/home/home_page.dart';

class AuthGate extends StatelessWidget {
  static const String id='/';
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return const HomePage();
          }else{
            return const SignInOrUp();
          }
        },
      ),
    );
  }
}
