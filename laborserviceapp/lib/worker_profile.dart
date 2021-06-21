import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginmodulepnwr/main.dart';
import 'package:fluttertoast/fluttertoast.dart';


class workerProfile extends StatefulWidget {
  @override
  _workerProfileState createState() => _workerProfileState();
}

class _workerProfileState extends State<workerProfile> {
  String docID;
  String status;

  signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyApp(),
      ),
    );
  }

  setData(String Status) async {
    String userId = (await FirebaseAuth.instance.currentUser).uid;
    FirebaseFirestore.instance
        .collection('workers')
        .doc(userId)
        .update({
      "Status": Status,
    });
    status = Status;
    Fluttertoast.showToast(
        msg: "Now you are $Status" ,
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    String userId = (FirebaseAuth.instance.currentUser).uid;
    CollectionReference users =
        FirebaseFirestore.instance.collection('workers');

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
              .collection('workers')
              .where(FieldPath.documentId, isEqualTo: userId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data.docs.map(
                (getData) {
                  //var url = document['Email'];
                  return Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          getData['Name'].toUpperCase(),
                          style: TextStyle(
                              fontFamily: 'SourceSansPro',
                              fontSize: 20.0,
                              color: Colors.white,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage:
                                AssetImage('person2.png'),
                          ),
                        ),
                        Text(
                          getData['Occupation'].toUpperCase(),
                          //getData['Occupation'].toUpperCase(),
                          style: TextStyle(
                              fontFamily: 'SourceSansPro',
                              fontSize: 18.0,
                              color: Colors.blue,
                              letterSpacing: 2.5,),
                        ),
                        SizedBox(
                          height: 10.0,
                          width: 100.0,
                          child: Divider(
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        Text(
                          getData['City'].toUpperCase(),
                          style: TextStyle(
                              fontFamily: 'SourceSansPro',
                              fontSize: 15.0,
                              color: Colors.white,
                              letterSpacing: 2.5,),
                        ),
                        SizedBox(
                          height: 15.0,
                          width: 70.0,
                          child: Divider(
                            color: Colors.white,
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
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.white),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.grey[850],
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey[600], width: 1),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          margin: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 45.0),
                          child: ListTile(
                            leading: Icon(
                              Icons.mail,
                              color: Colors.red[400],
                              size: 20,
                            ),
                            title: Text(
                              getData['Email'],
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(15.0),
                          child: ListTile(
                            leading: RaisedButton(
                              onPressed: () {
                                setData('available');
                              },
                              textColor: Colors.black,
                              padding: const EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0),
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xFF00E676),
                                      Color(0xFF00E676),
                                      Color(0xFF00E676),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(40.0),
                                  ),
                                ),
                                padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: const Text(
                                  'Available',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            trailing: RaisedButton(
                              onPressed: () {
                                setData('unavailable');
                              },
                              textColor: Colors.black,
                              padding: const EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0),
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xFFF44336),
                                      Color(0xFFF44336),
                                      Color(0xFFF44336),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(40.0),
                                  ),
                                ),
                                padding: const EdgeInsets.fromLTRB(35 , 10, 35, 10),
                                child: const Text(
                                  'Unavailable',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text("You are "+
                          getData['Status']+" now!",
                          //getData['Occupation'].toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            );
          }),
    );
  }
}
