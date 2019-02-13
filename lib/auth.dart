import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String _email, _password);
  Future<String> createUserWithEmailAndPassword(String _email, _password);
}

class Auth implements BaseAuth {
  Future<String> signInWithEmailAndPassword(String _email, _password) async {
    FirebaseUser user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _email, password: _password);
    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(
      String _email, _password) async {
    FirebaseUser user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: _email, password: _password);
    return user.uid;
  }
}
