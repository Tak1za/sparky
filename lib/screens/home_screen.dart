import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sparky_for_reddit/providers/auth.dart';
import 'package:sparky_for_reddit/screens/login_screen.dart';

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
                          (_) => Navigator.of(context, rootNavigator: true)
                              .pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) {
                            return const LoginScreen();
                          }), (_) => false),
                        );
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
