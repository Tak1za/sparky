import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sparky_for_reddit/providers/auth.dart';
import 'package:sparky_for_reddit/widgets/navigation.dart';

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
            .then((value) => Navigator.of(context, rootNavigator: true)
                    .pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
                  return const Navigation();
                }), (_) => false))
            .catchError((err) {
          Navigator.of(context).pop();
          _showDialog();
        }),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container();
        },
      ),
    );
  }
}
