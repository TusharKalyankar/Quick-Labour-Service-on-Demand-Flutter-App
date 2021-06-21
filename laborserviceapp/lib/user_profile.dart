import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginmodulepnwr/main.dart';

class userProfile extends StatefulWidget {
  @override
  _userProfileState createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {
  String docID;

  signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  getData() async {
    String userId = (await FirebaseAuth.instance.currentUser).uid;
    return FirebaseFirestore.instance.collection('user').doc(userId);
  }
  @override
  Widget build(BuildContext context) {

    String userId = (FirebaseAuth.instance.currentUser).uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: new AppBar(
        title: new Text("Profile"),
        backgroundColor: Colors.white30,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 17.0, color: Colors.white),
            ),
            onPressed: () {
              signOut();
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where(FieldPath.documentId, isEqualTo: userId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data.docs.map(
              (getData) {
                return Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                     //
                      Text(
                        getData['Name'],
                        style: TextStyle(
                            fontFamily: 'SourceSansPro',
                            fontSize: 30.0,
                            color: Colors.white,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                          AssetImage('assets/person2.png'),
                        ),
                      ),
                      Text(
                        getData['City'].toUpperCase(),
                        style: TextStyle(
                            fontFamily: 'SourceSansPro',
                            fontSize: 15.0,
                            color: Colors.blue,
                            letterSpacing: 2.5,),
                      ),
                      SizedBox(
                        height: 10.0,
                        width: 80.0,
                        child: Divider(
                          thickness: 1,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                      ),
                      Card(
                        color: Colors.grey[850],
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey[600], width: 1),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        shadowColor: Colors.black,
                        margin: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 45.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.phone,
                            color: Colors.greenAccent,
                            size: 20,
                          ),
                          title: Text(
                            getData['Phone Number'],
                            style: TextStyle(fontSize: 15,color: Colors.white),
                          ),
                        ),
                      ),

                      Card(
                        color: Colors.grey[850],
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey[600], width: 1),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        shadowColor: Colors.black,
                        margin: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 45.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.mail,
                            color: Colors.red[400],
                          ),
                          title: Text(
                            getData['Email'],
                            style: TextStyle(fontSize: 15,color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          );
        },
      ),
    );
    return Scaffold();
  }
}
