import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_payment.dart';

class book_worker_history extends StatefulWidget {
  @override
  _book_worker_historyState createState() => _book_worker_historyState();
}

class _book_worker_historyState extends State<book_worker_history> {
  String userId = (FirebaseAuth.instance.currentUser).uid;
  bool status_flag = false;


  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Booking');
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Booked Workers'),
          backgroundColor: Colors.white30,
        ),
        backgroundColor: Colors.black,
        body: new StreamBuilder(
            stream: users.snapshots(), //.where('user', isEqualTo: userId)
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                status_flag = true;
                print(userId);
                print("Data Found");
                return new ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          color: Colors.grey[850],
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey[600], width: 1.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                isThreeLine: true,
                                title: Text(
                                  snapshot.data.docs[index]
                                      .data()['Name']
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontFamily: 'DancingScript',
                                      letterSpacing: 1,
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      ),
                                ),
                                subtitle: Text(
                                  snapshot.data.docs[index]
                                      .data()['Occupation']
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontFamily: 'SourceSansPro',
                                      letterSpacing: 1,
                                      fontSize: 13.0,
                                      color: Colors.lightBlueAccent,),
                                ),
                                trailing: RaisedButton(
                                  onPressed: () {
                                    String w_uid = snapshot.data.docs[index].data()['user'];
                                    var w_rate = snapshot.data.docs[index].data()['Rating'];
                                    var w_paymentid = snapshot.data.docs[index].data()['PaymentID'];
                                    print(w_rate);
                                    print(w_uid);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => userPayment(
                                              wr_uid: w_uid,
                                              wr_rate: w_rate,
                                              wr_paymentid:w_paymentid),
                                      ),
                                    );
                                  },
                                  textColor: Colors.white,
                                  padding: const EdgeInsets.all(0.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0),
                                  ),
                                  child: Ink(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          Color(0xFF0D47A1),
                                          Color(0xFF1976D2),
                                          Color(0xFF42A5F5),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(40.0),
                                      ),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          35, 10, 35, 10),
                                      child: Text(
                                        'Pay',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
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
            }));
  }
}


