import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _userId, _token;
  DateTime _expiryDate;

  bool get isAuth => token != null;

  String get token => (_expiryDate != null &&
          _expiryDate.isAfter(DateTime.now()) &&
          _token != null)
      ? _token
      : null;

  String get userId => _userId;

  Future<String> signUpIn(
      {String email, String password, bool isSignUp}) async {
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
    final resData = json.decode(res.body);
    _token = resData['idToken'];
    _userId = resData['localId'];
    _expiryDate =
        DateTime.now().add(Duration(seconds: int.parse(resData['expiresIn'])));
    notifyListeners();
    if (!isSignUp && resData['error'] != null) {
      switch (resData['error']['message']) {
        case 'EMAIL_NOT_FOUND':
          return 'Email not found';
        case 'INVALID_EMAIL':
          return 'Invalid email address.';
        case 'INVALID_PASSWORD':
          return 'Invalid Password';
        case 'WEAK_PASSWORD':
          return 'Please provide a stronger password.';
        case 'TOO_MANY_ATTEMPTS_TRY_LATER : Too many unsuccessful login attempts. Please try again later.':
          return 'Too many failed attempts. Try again later...';
        case 'TOO_MANY_ATTEMPTS_TRY_LATER : We have blocked all requests from this device due to unusual activity. Try again later.':
          return 'Too many failed attempts. Try again later...';
        case 'EMAIL_EXISTS':
          return 'This email is already in use.';
        default:
          return 'Unable to authenticate. Try again later.';
      }
    } else
      return null;
  }
}
