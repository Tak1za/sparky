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
