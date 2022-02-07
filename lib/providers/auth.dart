import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? accessToken;
  String? refreshToken;

  String? get token {
    return accessToken;
  }

  bool get isLoggedIn {
    return token != null;
  }

  String extractAuthorisationCodeFromQuery(String query) {
    List<String> queryList = query.split('&');

    for (String q in queryList) {
      List<String> qval = q.split('=');

      if (qval.length > 1 && qval.first.toLowerCase() == 'code') {
        return qval[1];
      }
    }
    return '';
  }

  Future<void> setRedditAuthorisationCode(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('reddit_oauth_code', code);
  }

  Future<void> setRedditRefreshToken(String token) async {
    refreshToken = token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('reddit_refresh_token', token);
  }

  Future<void> setRedditAccessCode(String code) async {
    accessToken = code;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('reddit_access_code', code);
  }

  Future<void> tryAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('reddit_access_code');
    refreshToken = prefs.getString('reddit_refresh_token');
    notifyListeners();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = null;
    refreshToken = null;
    await prefs.clear();
    notifyListeners();
  }

  String getRedditBasicAuthHeader() {
    var basicAuthStr = "${dotenv.env['CLIENT_ID']}:";
    var bytes = utf8.encode(basicAuthStr);
    var base64Str = base64.encode(bytes);
    return base64Str;
  }

  Future<void> setRedditAccessTokenFromCode(String code) async {
    String basicAuth = getRedditBasicAuthHeader();
    var headers = {
      HttpHeaders.authorizationHeader: 'Basic $basicAuth',
    };
    try {
      final response = await post(
          Uri.parse('https://www.reddit.com/api/v1/access_token'),
          headers: headers,
          encoding: Encoding.getByName('utf-8'),
          body: {
            'grant_type': 'authorization_code',
            'code': code,
            'redirect_uri': dotenv.env['REDIRECT_URI']
          });
      if (response.statusCode == 200) {
        try {
          var responseJson = jsonDecode(response.body);
          await setRedditAccessCode(responseJson['access_token']);
          await setRedditRefreshToken(responseJson['refresh_token']);
          notifyListeners();
        } catch (e) {
          log('redditGetAccessTokenFromCode :: Not able to parse Token',
              error: e);
        }
      } else if (response.statusCode == 401) {
        log('Reddit API Token Revoked ${response.statusCode}');
      } else {
        log('Reddit API Get failed ${response.statusCode}');
      }
    } catch (e) {
      log('redditGetAccessTokenFromCode :: Not able to get Token', error: e);
    }
  }
}
