import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _userId, _token;
  DateTime _expiryDate;

  Future<void> signUpIn({String email, String password, bool isSignUp}) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:${isSignUp ? 'signUp' : 'signInWithPassword'}?key=AIzaSyDI0r4LMAIh2IV0a_ZFGILdKEtLYicm-hQ';
    final res = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    print(json.decode(res.body));
  }
}
