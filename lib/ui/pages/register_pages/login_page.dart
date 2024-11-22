import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:twitterclone/service/auth/auth_service.dart';
import 'package:twitterclone/ui/widgets/loading_circle.dart';
import 'package:twitterclone/ui/widgets/textfields.dart';
import 'package:twitterclone/utility/screen_utils.dart';

import '../../../utility/app_padding.dart';
import '../../widgets/buttons.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();


  void login() async {
    showLoading(context);

    try {
      await _auth.loginEmailPassword(
        emailController.text,
        passwordController.text,
      );

      if (mounted) hideLoading(context);
    } catch (e) {
      if (mounted) hideLoading(context);
      if (mounted) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(
                    e.toString(),
                  ),
                ));
      }
      log(
        e.toString(),
      );
    }
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: Dis.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                color: Theme.of(context).colorScheme.primary,
                size: 60,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Welcome back!!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              TextFields(
                hintText: 'Enter your email',
                controller: emailController,
              ),
              SizedBox(
                height: 10.h,
              ),
              TextFields(
                obscure: true,
                hintText: 'Enter your password',
                controller: passwordController,
              ),
              SizedBox(
                height: 30.h,
              ),
              Buttons(
                color: Theme.of(context).colorScheme.secondary,
                h: 50.h,
                w: double.infinity,
                title: 'Login',
                r: 10,
                onTap: login,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'New user?',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onTap,
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
