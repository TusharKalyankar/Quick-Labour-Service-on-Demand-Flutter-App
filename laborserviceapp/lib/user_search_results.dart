import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginmodulepnwr/worker_notify.dart';
import 'package:fluttertoast/fluttertoast.dart';


class user_search_result extends StatefulWidget {
  final String city_n;
  final String occupation_n;
  user_search_result({@required this.city_n, this.occupation_n});

  @override
  _user_search_resultState createState() =>
      _user_search_resultState(city: city_n, occupation: occupation_n);
}

class _user_search_resultState extends State<user_search_result> {
  String city;
  String occupation;

  _user_search_resultState({@required this.city, this.occupation});

  bool isEnabled = true;
  enableButton() {
    setState(() {
      isEnabled = true;
    });
  }

  disableButton() {
    setState(() {
      isEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search Results'),
          backgroundColor: Colors.white30,
        ),
        backgroundColor: Colors.black,
        body: Container(
          width: MediaQuery.of(context).size.width / 1,
          padding: EdgeInsets.all(0),
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance
                .collection('workers')
                .where('City', isEqualTo: city.toLowerCase().trim())
                .where('Occupation', isEqualTo: occupation.toLowerCase().trim())
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                Fluttertoast.showToast(
                    msg: "Loading", toastLength: Toast.LENGTH_LONG);
                    return Center(
                      child: CircularProgressIndicator(),
                    );
              }
              return ListView(
                children: snapshot.data.docs.map(
                  (getData) {
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Card(
                          color: Colors.grey[850],
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(color: Colors.grey[600], width: 1.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 5.0),
                              ListTile(
                                leading: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 60,
                                    minHeight: 60,
                                    maxWidth: 60,
                                    maxHeight: 60,
                                  ),
                                  child: CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage:
                                        AssetImage('assets/person2.png'),
                                  ),
                                ),
                                title: Text(
                                  getData['Name'].toUpperCase(),
                                  style: TextStyle(
                                      fontFamily: 'DancingScript',
                                      letterSpacing: 1,
                                      fontSize: 15.0,
                                      color: Colors.white,),
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      getData['Occupation'].toUpperCase(),
                                      style: TextStyle(
                                          fontFamily: 'SourceSansPro',
                                          fontSize: 10.0,
                                          color: Colors.lightBlueAccent,
                                          letterSpacing: 2.5,),
                                    ),
                                    Text(
                                      ' | ',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 15,
                                    ),
                                    Text(
                                      "\t[ " +
                                          getData['Rating'].toStringAsFixed(1) +
                                          " ]",
                                      style: TextStyle(
                                          color: Colors.lightBlueAccent,
                                      fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      ' | ',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    Text(
                                      getData['Status']
                                          .toString()
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.5),
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                color: Colors.grey[850],
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.grey[600], width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadowColor: Colors.black,
                                margin: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 30.0),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.phone,
                                    color: Colors.greenAccent,
                                    size: 20,
                                  ),
                                  title: Text(
                                    getData['Phone Number'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13),
                                  ),
                                ),
                              ),
                              Card(
                                color: Colors.grey[850],
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.grey[600], width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadowColor: Colors.black,
                                margin: EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 30.0),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.mail,
                                    color: Colors.red[400],
                                    size: 20,
                                  ),
                                  title: Text(
                                    getData['Email'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              RaisedButton(
                                onPressed: () {
                                  var status_check = getData['Status'];
                                  if (status_check == 'unavailable') {
                                    Fluttertoast.showToast(
                                        msg: "Worker is Unavailable!",
                                        toastLength: Toast.LENGTH_SHORT);
                                    disableButton();
                                  } else {
                                    var f_phone = getData['Phone Number'];
                                    var f_name = getData['Name'];
                                    var f_occupation = getData['Occupation'];
                                    var f_uid = getData['User UID'];
                                    var f_rating = getData['Rating'];
                                    var f_paymentid = getData['PaymentID'];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => worker_notify(
                                            fetch_phone: f_phone,
                                            fetch_name: f_name,
                                            fetch_occupation: f_occupation,
                                            fetch_uid: f_uid,
                                            fetch_rating: f_rating,
                                            fetch_paymentid: f_paymentid),
                                      ),
                                    );
                                  }
                                },
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60.0),
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
                                        50, 10, 50, 10),
                                    child: Text(
                                      'Book Now',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5.0),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
