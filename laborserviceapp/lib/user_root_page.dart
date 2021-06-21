import 'package:flutter/material.dart';
import 'package:loginmodulepnwr/user_home_page.dart';
import 'package:loginmodulepnwr/user_login_page.dart';
import 'package:loginmodulepnwr/user_auth.dart';

class userRootPage extends StatefulWidget {
  userRootPage({this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => _userRootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _userRootPageState extends State<userRootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus =
        userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return userLoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return userHomePage(
          auth: widget.auth,
          onSignedOut: _signedOut,
        );
    }
    return null;
  }
}
