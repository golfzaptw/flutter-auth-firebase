// import package
import 'package:flutter/material.dart';
// import file
import 'views/root_page.dart';
import 'service/auth.dart';

void main() => runApp(MyApp(title: 'App firebase login demo'));

class MyApp extends StatelessWidget {
  final String title;
  const MyApp({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: (title),
      theme: ThemeData(primaryColor: Colors.black),
      home: RootPage(
        title: title,
        auth: Auth(),
      ),
    );
  }
}
