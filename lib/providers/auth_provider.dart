import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/model/http_exception.dart';
import 'package:http/http.dart' as https;
import '../model/credintial.dart';

class Auth with ChangeNotifier {
  String _tokenId;
  DateTime _expirdTokenTime;
  String _userId;
  Timer _timerToExpired;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_tokenId != null &&
        _expirdTokenTime.isAfter(DateTime.now()) &&
        _expirdTokenTime != null) {
      return _tokenId;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signUpWithMail(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> signInWithMail(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$API_KEY';

    try {
      final res = await https.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final resData = json.decode(res.body) as Map<String, dynamic>;

      if (resData['error'] != null) {
        String message = resData['error']['message'];
        throw HttpException(messageTitle: message);
      }

      _tokenId = resData['idToken'];
      _userId = resData['localId'];
      _expirdTokenTime = DateTime.now().add(
        Duration(
          seconds: int.parse(resData['expiresIn']),
        ),
      );
      _autoSignOut();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _tokenId,
        'userId': _userId,
        'expiredTime': _expirdTokenTime.toIso8601String()
      });

      prefs.setString('userData', userData);
    } catch (err) {
      throw err;
    }
  }

  Future<bool> autoSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiredTime = DateTime.parse(extractedData['expiredTime']);

    if (expiredTime.isBefore(DateTime.now())) {
      return false;
    }

    _tokenId = extractedData['token'];
    _userId = extractedData['userId'];
    _expirdTokenTime = expiredTime;
    notifyListeners();
    _autoSignOut();
    return true;
  }

  Future<void> signOut() async {
    _userId = null;
    _expirdTokenTime = null;
    _tokenId = null;
    if (_timerToExpired != null) {
      _timerToExpired.cancel();
      _timerToExpired = null;
    }

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoSignOut() {
    if (_timerToExpired != null) {
      _timerToExpired.cancel();
    }
    final expiredTimeToSignOut = _expirdTokenTime
        .difference(
          DateTime.now(),
        )
        .inSeconds;
    _timerToExpired = Timer(Duration(seconds: expiredTimeToSignOut), signOut);
  }
}
