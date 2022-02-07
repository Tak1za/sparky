import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sparky_for_reddit/providers/auth.dart';

class RedditRedirect extends StatefulWidget {
  final String query;
  const RedditRedirect(this.query, {Key? key}) : super(key: key);

  @override
  _RedditRedirectState createState() => _RedditRedirectState();
}

class _RedditRedirectState extends State<RedditRedirect> {
  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Login Error"),
          content: const Text("Failed to Login"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Okay"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    String code = auth.extractAuthorisationCodeFromQuery(widget.query);

    return Center(
      child: FutureBuilder(
        future: auth
            .setRedditAuthorisationCode(code)
            .then((_) => auth.setRedditAccessTokenFromCode(code))
            .then(
              (_) => Navigator.of(context).pushReplacementNamed('/home'),
            )
            .catchError(
          (_) {
            Navigator.of(context).pushReplacementNamed('/');
            _showDialog();
          },
        ),
        builder: (ctx, snapshot) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
