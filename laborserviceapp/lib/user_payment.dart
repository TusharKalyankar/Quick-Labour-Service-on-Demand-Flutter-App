import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/services.dart';
import 'rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class userPayment extends StatefulWidget {
  final wr_uid;
  var wr_rate;
  var wr_paymentid;
  userPayment({this.wr_uid,this.wr_rate,this.wr_paymentid});
  @override
  _userPaymentState createState() => _userPaymentState(w_uid: wr_uid,w_rate: wr_rate,w_paymentid:wr_paymentid);
}

class _userPaymentState extends State<userPayment> {
  String w_uid;
  var w_rate;
  var name;
  var email;
  var phone;
  var w_paymentid;
  _userPaymentState({this.w_uid,this.w_rate,this.w_paymentid});

  double rating = 3.5;
  String payment;
  static const platform = const MethodChannel("razorpay_flutter");
  TextEditingController textEditingController = new TextEditingController();

  Razorpay _razorpay;
  String date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

  setData(String payment) async {
    print(payment);
    String userId = (await FirebaseAuth.instance.currentUser).uid;
    FirebaseFirestore.instance
          .collection('workers')
          .doc(w_uid)
          .update({
        "Status" : 'available',
      });

      FirebaseFirestore.instance
          .collection('workers')
          .doc(w_uid)
          .collection('UserPaymentHistory')
          .doc(w_paymentid.toString())
          .update({
        "Time": date,
        "Payment":payment
      });
  }

  final formKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    String userId = (FirebaseAuth.instance.currentUser).uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Gateway"),
        backgroundColor: Colors.white30,
      ),
      backgroundColor: Colors.black,
      body: Form(
        key: formKey,
        child: StreamBuilder(
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
              final TextEditingController controller_name = new TextEditingController(text: snapshot.data.docs[0]['Name']);
              final TextEditingController controller_email = new TextEditingController(text: snapshot.data.docs[0]['Email']);
              final TextEditingController controller_phone = new TextEditingController(text: snapshot.data.docs[0]['Phone Number']);
              name = controller_name.text.toString();
              email = controller_email.text.toString();
              phone = controller_phone.text.toString();

              return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(26.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),

                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        SizedBox(
                          height: 90,
                        ),
                        Container(
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            controller: textEditingController,
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
                                labelText: "Enter Amount in ( rupees.)",labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value.isEmpty ? 'Field can\'t be empty' : null,
                            onChanged: (value) => payment = value,
                          ),

                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          onPressed: () {
                            if(validateAndSave()){
                              openCheckout();
                            }
                            // openCheckout();
                          },
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0),
                          ),
                          child: Container(
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
                            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text(
                              'Pay Now',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.right,
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

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_Ua6rFQW9yRs0tX',
      'amount': num.parse(textEditingController.text) * 100,
      "name": "SerOne App",
      "description": "Payment for the service of Worker",
      "prefill": {"contact": "$phone", "email": "$email"},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    int _rating;
    double rating = 3.5;
    Fluttertoast.showToast(
        msg: "Thank you! Payment Successful" );
        print('payment successful');
    setData(payment);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => rating_bar(
            onRatingSelected: (rating) {
              setState(() {
                _rating = rating;
              });
            },maximumRating:5,worker_id: w_uid,worker_rate: w_rate
        ),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " ,
        toastLength: Toast.LENGTH_SHORT);
    print('Error');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " , toastLength: Toast.LENGTH_SHORT);
    print('external wallet');
  }
}
