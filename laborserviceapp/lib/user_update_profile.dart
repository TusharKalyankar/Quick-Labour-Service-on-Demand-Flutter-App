import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginmodulepnwr/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class user_update extends StatefulWidget {

  @override
  _user_updateState createState() =>
      _user_updateState();
}

class _user_updateState extends State<user_update> {

  String _email;
  String _password;
  String _city;
  String _phone;
  String _occupation;
  String _name;
  String userId = (FirebaseAuth.instance.currentUser).uid;

  signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }
  //payoutlist

  getData() async {
    String userId = (await FirebaseAuth.instance.currentUser).uid;
    return FirebaseFirestore.instance.collection('users').doc(userId);
  }

  updateData(String _name, String _city, String _phone )
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({
      "Name": _name.toLowerCase().trim(),
      "City": _city.toLowerCase().trim(),
      "Phone Number": _phone.trim(),
      //"Occupation": _occupation.toLowerCase().trim()
    });
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  bool _isHidden = false;


  @override
  Widget build(BuildContext context) {
    String userId = (FirebaseAuth.instance.currentUser).uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        backgroundColor: Colors.white30,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: users
                .where('User UID', isEqualTo: userId)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final TextEditingController controller_name = new TextEditingController(text: snapshot.data.docs[0]['Name']);
              final TextEditingController controller_city = new TextEditingController(text: snapshot.data.docs[0]['City']);
              final TextEditingController controller_phone = new TextEditingController(text: snapshot.data.docs[0]['Phone Number']);
              return Container(
                padding: EdgeInsets.all(20),
                child: SafeArea(
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Edit Your Details",
                          style: TextStyle(fontSize: 25,color: Colors.white),
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                      ),
                      Container(

                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: controller_name,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.greenAccent[400],
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                ),
                              ),
                              labelText: 'Name',labelStyle: TextStyle(color: Colors.white)),
                          validator: (value) => value.isEmpty ? 'Name can\'t be empty' : null,
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                      ),
                      Container(

                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: controller_city,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.greenAccent[400],
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                ),
                              ),

                              labelText: 'City',labelStyle: TextStyle(color: Colors.white)),
                          validator: (value) => value.isEmpty ? 'City can\'t be empty' : null,
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                      ),
                      Container(

                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: controller_phone,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.greenAccent[400],
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                ),
                              ),
                              labelText: 'Phone Number',labelStyle: TextStyle(color: Colors.white)),
                          validator: (value) => value.isEmpty ? 'Phone Number can\'t be empty' : null,
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                      ),


                      RaisedButton(
                        onPressed: () {

                          _name = controller_name.text;
                          _city = controller_city.text;
                          _phone = controller_phone.text;


                          updateData(_name,_city,_phone);

                          Fluttertoast.showToast(
                              msg: "Account Successfully Updated",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER);
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
                            padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                            child: Text(
                              'Update',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}


