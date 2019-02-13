import 'package:flutter/material.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  final String title;
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  const LoginPage({Key key, this.title, this.auth, this.onSignedIn})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

enum formType { login, register }

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  String _email, _password;
  formType _formtype = formType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formtype == formType.login) {
          String userId =
              await widget.auth.signInWithEmailAndPassword(_email, _password);
          print('Sign in: $userId');
        } else {
          String userId = await widget.auth
              .createUserWithEmailAndPassword(_email, _password);
          print('Register : $userId');
        }
        widget.onSignedIn();
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formtype = formType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formtype = formType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildInput() + _buildSubmitButton(),
            ),
          ),
        ));
  }

  List<Widget> _buildInput() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? 'Email can\'t empty' : null,
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Password can\'t empty' : null,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> _buildSubmitButton() {
    if (_formtype == formType.login) {
      return [
        RaisedButton(
          child: Text('Login', style: TextStyle(fontSize: 20)),
          padding: EdgeInsets.all(20),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text(
            'Create an account',
            style: TextStyle(fontSize: 20),
          ),
          onPressed: moveToRegister,
        )
      ];
    } else {
      return [
        RaisedButton(
          child: Text('Create an account', style: TextStyle(fontSize: 20)),
          padding: EdgeInsets.all(20),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text(
            'Have an account ? Login !',
            style: TextStyle(fontSize: 20),
          ),
          onPressed: moveToLogin,
        )
      ];
    }
  }
}
