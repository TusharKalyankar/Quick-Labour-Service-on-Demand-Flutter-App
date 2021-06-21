import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_sms/flutter_sms.dart';

class worker_notify extends StatefulWidget {
  final fetch_phone;
  final fetch_name;
  final fetch_occupation;
  final fetch_uid;
  final fetch_rating;
  final fetch_paymentid;

  worker_notify(
      {@required this.fetch_phone,
      this.fetch_name,
      this.fetch_occupation,
      this.fetch_uid,
      this.fetch_rating,
      this.fetch_paymentid});

  @override
  _worker_notifyState createState() => _worker_notifyState(
      w_phone: fetch_phone,
      w_name: fetch_name,
      w_occupation: fetch_occupation,
      w_uid: fetch_uid,
      w_rate: fetch_rating,
      w_paymentid: fetch_paymentid);
}

class _worker_notifyState extends State<worker_notify> {
  final formKey = GlobalKey<FormState>();
  String address;
  String purpose;
  String name;
  String w_phone;
  String w_name;
  String w_occupation;
  String w_uid;
  var w_paymentid;
  var w_rate;
  _worker_notifyState(
      {this.w_phone, this.w_name, this.w_occupation, this.w_uid, this.w_rate,this.w_paymentid});
  String userId = (FirebaseAuth.instance.currentUser).uid;
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  getData() async {
    String userId = (await FirebaseAuth.instance.currentUser).uid;
    return FirebaseFirestore.instance.collection('user').doc(userId);
  }

  setData(String name,String phone) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Booking')
        .doc(w_uid)
        .set({
      "Name": w_name,
      "Occupation": w_occupation,
      "Phone Number": w_phone,
      "user": w_uid,
      "Rating": w_rate,
      "PaymentID":w_paymentid
    });
    FirebaseFirestore.instance.collection('workers').doc(w_uid).update({
      "Status": 'unavailable',
    });

    FirebaseFirestore.instance
        .collection('workers')
        .doc(w_uid)
        .collection('UserPaymentHistory')
        .doc(w_paymentid.toString())
        .set({
      "Name": name,
      "Phone Number": phone,
      "Time" : 0,
      "PaymentId":w_paymentid,
      "Payment": 0
    });
    w_paymentid++;

    FirebaseFirestore.instance
        .collection('workers')
        .doc(w_uid)
        .update({
      "PaymentID":w_paymentid
    });
  }

  @override
  Widget build(BuildContext context) {
    String userId = (FirebaseAuth.instance.currentUser).uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Worker'),
        backgroundColor: Colors.black54,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where(FieldPath.documentId, isEqualTo: userId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final TextEditingController controller_address = new TextEditingController();
            final TextEditingController controller_purpose = new TextEditingController();
            final TextEditingController controller_name = new TextEditingController(text: snapshot.data.docs[0]['Name']);
            final TextEditingController controller_email = new TextEditingController(text: snapshot.data.docs[0]['Email']);
            final TextEditingController controller_phone = new TextEditingController(text: snapshot.data.docs[0]['Phone Number']);
            final TextEditingController controller_city = new TextEditingController(text: snapshot.data.docs[0]['City']);
            String name = controller_name.text.toString().toUpperCase();
            String email = controller_email.text.toString();
            String phone = controller_phone.text.toString();
            String city = controller_city.text.toString().toUpperCase();

            return Scaffold(
              backgroundColor: Colors.black,
              body: SafeArea(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Form(
                    key: formKey,
                    child: ListView(
                      children: [
                        Center(
                          child: Text(
                            "*Check your details and enter your address and purpose, then click Send*",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11.5,
                                color: Colors.red),
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),

                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.blueAccent,
                                  size: 20,
                                ),
                                Text("   "+
                                    "$name",
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
                                  Icons.email,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                                Text("   "+
                                    "$email",
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
                                  color: Colors.green,
                                  size: 20,
                                ),
                                Text("   "+
                                    "$phone",
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
                                  Icons.location_on_outlined,
                                  color: Colors.lightBlueAccent,
                                  size: 20,
                                ),
                                Text("   "+
                                    "$city",
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

                        SizedBox(height: 20,),
                        ListTile(
                          title: Container(
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              controller: controller_address,
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
                                labelText: 'Enter your Address',
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(),
                              ),
                              // validator: (value) => value.isEmpty ? 'Address can\'t be empty' : null,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Address can\'t be empty';
                                }
                                return null;
                              },
                              onChanged: (value) => address = value,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Container(
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              controller: controller_purpose,
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
                                labelText: 'Enter Purpose for Worker',
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(),
                              ),
                              // validator: (value) => value.isEmpty ? 'Purpose can\'t be empty' : null,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Purpose can\'t be empty';
                                }
                                return null;
                              },
                              onChanged: (value) => purpose = value,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: RaisedButton(
                            onPressed: () {
                              if (validateAndSave()) {
                                String resut;
                                var message =
                                    '\n Customer Details:\n \nName: $name\n\nEmail : $email \n\nContact: $phone \n\nCity: $city \n\nAddress: $address \n\nYour Job Description: $purpose';
                                setData(name,phone);
                                List<String> ph = [w_phone];
                                _sendSMS(message, ph);
                              }
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
                                padding:
                                    const EdgeInsets.fromLTRB(70, 10, 70, 10),
                                child: Text(
                                  'Send',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

void _sendSMS(var concatenate, List<String> ph) async {
  var con = concatenate.toString();
  String _result =
      await sendSMS(message: con, recipients: ph).catchError((onError) {
    print(onError);
  });
  print(_result);
}
