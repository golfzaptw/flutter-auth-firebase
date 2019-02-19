import 'package:flutter/material.dart';
import 'package:flutter_firebase/model/data.dart';
import 'package:firebase_database/firebase_database.dart';

class ShowDataPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ShowDataPageState();
  }
}

class _ShowDataPageState extends State<ShowDataPage> {
  List<Data> allData = [];

  @override
  void initState() {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('uid').once().then((DataSnapshot snapshot) {
      var keys = snapshot.value.keys;
      var data = snapshot.value;
      allData.clear();
      for (var key in keys) {
        var myData = Data(
          data[key]['title'],
          data[key]['gender'],
          data[key]['message'],
        );
        allData.add(myData);
      }
      setState(() {
        print('Length: ${allData.length}');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Data'),
      ),
      body: Container(
        child: allData.length == 0
            ? Center(
                child: Text('No data'),
              )
            : ListView.builder(
                itemCount: allData.length,
                itemBuilder: (_, index) {
                  return UI(
                    allData[index].title,
                    allData[index].gender,
                    allData[index].message,
                  );
                }),
      ),
    );
  }

  Widget UI(String title, gender, message) {
    return Card(
      elevation: 10,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Title: $title',style: Theme.of(context).textTheme.title,),
            Text('Gender: $gender'),
            Text('Message: $message')
          ],
        ),
      ),
    );
  }
}
