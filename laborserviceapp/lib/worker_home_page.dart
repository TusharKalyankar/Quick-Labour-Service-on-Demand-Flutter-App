import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginmodulepnwr/transaction_error_page.dart';
import 'package:loginmodulepnwr/user_auth.dart';
import 'package:loginmodulepnwr/user_payment_history.dart';
import 'package:loginmodulepnwr/worker_profile.dart';
import 'package:loginmodulepnwr/worker_update_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class worker_HomePage extends StatelessWidget {
  worker_HomePage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Worker dashboard",
      home: MyBottomNavigationBar(),
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    workerProfile(),
    worker_update(),
    UserPaymentHistory(),
  ];

  void onTappedBar(int index) async{
    // setState(() {
    //   _currentIndex = index;
    // });
      var c = await GetCount();
      print('Count of Result: $c');
      if(index!=2)
      {
        setState(
              () {
            _currentIndex = index;
          },);
      }
      if(index==2){
        if(c!=0){
          setState(
                () {
              _currentIndex = index;
            },);
        }
        else{
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionErrorPAge(),
            ),
          );
        }
      }
  }
  String userId = (FirebaseAuth.instance.currentUser).uid;

  GetCount() async{
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('workers')
        .doc(userId)
        .collection('UserPaymentHistory')
        .where('Time', isNotEqualTo: 0)
        .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    // print(_myDocCount.length);
    var res = _myDocCount.length.toInt();
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.person,color: Colors.grey,size: 20,),
            title: new Text(
              "Profile",
              style: TextStyle(fontSize: 15,color: Colors.grey),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.settings,color: Colors.grey,size: 20,),
            title: new Text(
              "Update Profile",
              style: TextStyle(fontSize: 15,color: Colors.grey),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.history,color: Colors.grey,size: 20,),
            title: new Text(
              "Transaction History",
              style: TextStyle(fontSize: 15,color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
