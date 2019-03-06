// import package
import 'package:flutter/material.dart';
// import file
import '../service/auth.dart';

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

  String _email, _password, _repassword;
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
          widget.onSignedIn();
        } else {
          if (_password == _repassword) {
            String userId = await widget.auth
                .createUserWithEmailAndPassword(_email, _password);
            print('Register : $userId');
            widget.onSignedIn();
          } else {
            print('password not match');
          }
        }
      } catch (e) {
        _showDialog();
      }
    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Login Fail"),
          content: new Text("Email or password are not match."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    if (_formtype == formType.login) {
      return [
        TextFormField(
          decoration: InputDecoration(labelText: 'Email'),
          validator: validateEmail,
          onSaved: (value) => _email = value,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
          validator: validatePassword,
          onSaved: (value) => _password = value,
        ),
      ];
    } else {
      return [
        TextFormField(
          decoration: InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          validator: validateEmail,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Password'),
          // keyboardType: TextInputType.number,
          validator: validatePassword,
          obscureText: true,
          autofocus: false,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Re Password'),
          // keyboardType: TextInputType.number,
          validator: validateRePassword,
          obscureText: true,
          autofocus: false,
        ),
      ];
    }
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

  Pattern patternEmail =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  Pattern patternPassword = r'(^[0-9]*$)';

  String validateEmail(String value) {
    _email = value;
    RegExp regex = new RegExp(patternEmail);
    if (_email.isEmpty) {
      return 'Email is required';
    } else if (!regex.hasMatch(_email)) {
      return 'Enter Valid Email';
    } else
      return null;
  }

  String validatePassword(String value) {
    _password = value;
    RegExp regExp = RegExp(patternPassword);
    if (_password.length == 0) {
      return "Password is required";
    } else if (_password.length < 6 || _password.length > 20) {
      return "Password should more than 6 and less than 20 character";
    } else if (!regExp.hasMatch(_password)) {
      return "Password is number only!";
    } else {
      return null;
    }
  }

  String validateRePassword(String value) {
    _repassword = value;
    RegExp regExp = RegExp(patternPassword);
    if (_repassword.length == 0) {
      return "Password is required";
    } else if (_repassword.length > 10) {
      return "Password is less than 10 character";
    } else if (!regExp.hasMatch(_password)) {
      return "Password is number only!";
    } else if (_repassword != _password) {
      return "Password and Re-Password are not match";
    } else {
      return null;
    }
  }
}
