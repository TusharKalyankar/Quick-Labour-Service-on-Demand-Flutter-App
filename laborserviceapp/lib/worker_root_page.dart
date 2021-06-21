import 'package:flutter/material.dart';
import 'package:loginmodulepnwr/user_auth.dart';
import 'package:loginmodulepnwr/worker_login.dart';
import 'package:loginmodulepnwr/worker_home_page.dart';

class workerRootPage extends StatefulWidget {
  workerRootPage({this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => _workerRootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _workerRootPageState extends State<workerRootPage> {
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
        return WorkerLoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return worker_HomePage(
          auth: widget.auth,
          onSignedOut: _signedOut,
        );
    }
    return null;
  }
}
