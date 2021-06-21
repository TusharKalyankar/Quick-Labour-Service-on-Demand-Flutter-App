import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserPaymentHistory extends StatefulWidget {
  @override
  _UserPaymentHistoryState createState() => _UserPaymentHistoryState();
}

class _UserPaymentHistoryState extends State<UserPaymentHistory> {
  String userId = (FirebaseAuth.instance.currentUser).uid;
  bool status_flag = false;

  @override
  Widget build(BuildContext context) {

    return Scrollbar(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Transaction History'),
            backgroundColor: Colors.white30,
          ),
          backgroundColor: Colors.black,
          body: new StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('workers')
                  .doc(userId)
                  .collection('UserPaymentHistory')
                  .where('Time', isNotEqualTo: 0).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  status_flag = true;
                  print("Data Found");
                  return new ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Card(
                            color: Colors.grey[850],
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey[600], width: 1.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.date_range,
                                          color: Colors.lightBlueAccent,
                                          size: 20,
                                        ),
                                        Text("   "+
                                            snapshot.data.docs[index].data()['Time'].toString(),
                                          style: TextStyle(
                                            fontFamily: 'DancingScript',
                                            letterSpacing: 1,
                                            fontSize: 15.0,
                                            color: Colors.white,),
                                        ),
                                        Text("                      \u{20B9} "+
                                            snapshot.data.docs[index].data()['Payment'].toString(),
                                          style: TextStyle(
                                              fontFamily: 'DancingScript',
                                              letterSpacing: 1,
                                              fontSize: 15.0,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: Colors.lightBlueAccent,
                                          size: 20,
                                        ),
                                        Text("   "+
                                            snapshot.data.docs[index].data()['Name'].toUpperCase(),
                                          style: TextStyle(
                                            fontFamily: 'DancingScript',
                                            letterSpacing: 1,
                                            fontSize: 15.0,
                                            color: Colors.white,),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          color: Colors.lightBlueAccent,
                                          size: 20,
                                        ),
                                        Text("   "+
                                            snapshot.data.docs[index].data()['Phone Number'].toUpperCase(),
                                          style: TextStyle(
                                            fontFamily: 'DancingScript',
                                            letterSpacing: 1,
                                            fontSize: 15.0,
                                            color: Colors.white,),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }
                else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                    Text('Loading...',
                      style: TextStyle(
                          fontFamily: 'DancingScript',
                          letterSpacing: 1,
                          fontSize: 20.0,
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }
              })),
    );
  }
}
