import 'package:flutter/material.dart';

class TokenProvider extends ChangeNotifier {
  String? _token;

  void setToken(String value) {
    _token = value;
    notifyListeners();
  }

  String? get getToken => _token;
}
