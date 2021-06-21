import 'package:flutter/material.dart';
import 'package:loginmodulepnwr/book_worker_history.dart';
import 'package:loginmodulepnwr/user_auth.dart';
import 'package:loginmodulepnwr/user_profile.dart';
import 'package:loginmodulepnwr/user_search.dart';
import 'package:loginmodulepnwr/user_update_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginmodulepnwr/w_b_h_error_page.dart';

class userHomePage extends StatelessWidget {
  userHomePage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        title: "User dashboard",
        home: MyBottomNavigationBar(),
      ),
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;
  String userId = (FirebaseAuth.instance.currentUser).uid;


  final List<Widget> _children =[
    userProfile(),
    userSearch(),
    book_worker_history(),
    user_update(),
  ];

  GetCount() async{
    QuerySnapshot _myDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Booking').get();

    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    // print(_myDocCount.length);
    var res = _myDocCount.length.toInt();
    return res;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black87,
          // onTap: onTappedBar,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.red,
          selectedFontSize: 20,
          unselectedFontSize: 15,
          items:[
            BottomNavigationBarItem(
              icon: new Icon(Icons.person,color: Colors.grey,size: 20),
              title: new Text(
                "Profile",
                style: TextStyle(fontSize: 15,color: Colors.grey),
              ),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.search,color: Colors.grey,size: 20),
              title: new Text(
                "Search",
                style: TextStyle(fontSize: 15,color: Colors.grey),
              ),
            ),

            BottomNavigationBarItem(
              icon: new Icon(Icons.history,color: Colors.grey,size: 20),
              title: new Text(
                "Payments",
                style: TextStyle(fontSize: 15,color: Colors.grey),
              ),
            ),


            BottomNavigationBarItem(
              icon: new Icon(Icons.settings,color: Colors.grey,size: 20),
              title: new Text(
                "Update Profile",
                style: TextStyle(fontSize: 15,color: Colors.grey),
              ),
            )
          ],
          onTap: ( index) async{
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
                      builder: (context) => WbhErrorPage(),
                    ),
                  );
                }
              }
          }
      ),
    );
  }
}
