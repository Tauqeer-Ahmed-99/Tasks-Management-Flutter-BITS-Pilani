import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class UserProvider extends ChangeNotifier {
  var isLoggedIn = false;
  ParseUser? user;

  UserProvider() {
    loadUser();
  }

  Future<void> loadUser() async {
    final user = await ParseUser.currentUser();

    if (user != null) {
      this.user = user as ParseUser;
      isLoggedIn = true;
      notifyListeners();
    } else {
      await user.logout();
    }
  }

  Future<ParseResponse> signup(
      String username, String password, String email) async {
    final user = ParseUser(username, password, email);

    final response = await user.signUp();

    if (response.success) {
      isLoggedIn = true;
      this.user = user;
      notifyListeners();
    }

    return response;
  }

  Future<ParseResponse> signin(String username, String password) async {
    final user = ParseUser(username, password, null);

    final response = await user.login();

    if (response.success) {
      isLoggedIn = true;
      this.user = user;
      notifyListeners();
    }

    return response;
  }

  Future<ParseResponse> signout() async {
    final user = await ParseUser.currentUser() as ParseUser;

    final response = await user.logout();

    if (response.success) {
      isLoggedIn = false;
      this.user = user;
      notifyListeners();
    }

    return response;
  }
}
