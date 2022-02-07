import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sparky_for_reddit/providers/auth.dart';
import 'package:sparky_for_reddit/screens/home_screen.dart';
import 'package:sparky_for_reddit/screens/login_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return FutureBuilder(
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (auth.isLoggedIn) {
          return const HomeScreen();
        }
        return const LoginScreen();
      }),
      future: auth.tryAutoLogin(),
    );
  }
}
