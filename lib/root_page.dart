import 'package:flutter/material.dart';
import 'login_page.dart';
import 'auth.dart';
import 'home_page.dart';

class RootPage extends StatefulWidget {
  final String title;
  final BaseAuth auth;

  const RootPage({Key key, this.auth, this.title}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _RootPageState();
  }
}

enum AuthStatus { notSignedIn, signedIn }

class _RootPageState extends State<RootPage> {
  AuthStatus _authStatus = AuthStatus.notSignedIn;

  initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        _authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.notSignedIn:
        return LoginPage(
          title: widget.title,
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return HomePage(
          auth: widget.auth,
          onSignedOut: _signedOut,
        );
    }
  }
}
