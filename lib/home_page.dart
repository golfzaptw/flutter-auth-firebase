import 'package:flutter/material.dart';
import 'auth.dart';

class HomePage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  const HomePage({Key key, this.auth, this.onSignedOut}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  void _signOut() async {
    try {
      await widget.auth.sighOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Text(
            'Welcome',
            style: TextStyle(fontSize: 32),
          ),
        ),
      ),
    );
  }
}
