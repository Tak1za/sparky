import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sparky_for_reddit/providers/auth.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Home Screen'),
              Consumer<Auth>(
                builder: (ctx, auth, _) => ElevatedButton(
                  onPressed: () async {
                    auth.logout().then(
                        (_) => Navigator.of(context).pushReplacementNamed('/'));
                  },
                  child: const Text("Logout"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
