import 'package:flutter/material.dart';
import '../service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'showData_page.dart';

class HomePage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  const HomePage({Key key, this.auth, this.onSignedOut}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  String title;
  String message;
  String gender;
  
  bool _autoValidate = false;
  List<DropdownMenuItem<String>> items = [
    DropdownMenuItem(
      child: Text('Male'),
      value: 'Male',
    ),
    DropdownMenuItem(
      child: Text('Female'),
      value: 'Female',
    ),
  ];
  GlobalKey<FormState> _key = GlobalKey();

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
      body: Center(
        child: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: Form(
                  key: _key,
                  autovalidate: _autoValidate,
                  child: FormUI(snapshot.data.uid),
                ),
              );
            } else {
              return Text('Loading...');
            }
          },
        ),
      ),
    );
  }

  Widget FormUI(String uid) {
    return Container(
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'Title'),
                  maxLength: 50,
                  validator: validateTitle,
                  onSaved: (val) {
                    title = val;
                  },
                ),
              ),
              SizedBox(
                width: 20,
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton(
                  items: items,
                  value: gender,
                  hint: Text('Gender'),
                  onChanged: (val) {
                    setState(() {
                      gender = val;
                    });
                  },
                ),
              ),
            ],
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Message'),
            maxLength: 256,
            maxLines: 5,
            validator: validateMessage,
            onSaved: (val) {
              message = val;
            },
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RaisedButton(
                  onPressed: _sendToServer,
                  child: Icon(Icons.send),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowDataPage()));
                  },
                  child: Text('Show data'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      DatabaseReference ref = FirebaseDatabase.instance.reference();
      var data = {
        "title": title,
        "gender": gender,
        "message": message,
      };
      ref.child('uid').push().set(data).then((v) {
        _key.currentState.reset();
      });
    } else {
      _autoValidate = true;
    }
  }

  String validateTitle(String val) {
    return val.length == 0 ? "Please enter Title" : null;
  }

  String validateMessage(String val) {
    return val.length == 0 ? "Please enter Message" : null;
  }
}
