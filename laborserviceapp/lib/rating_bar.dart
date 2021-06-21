import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginmodulepnwr/user_home_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class rating_bar extends StatefulWidget {

  final int maximumRating;
  final Function(int) onRatingSelected;
  final worker_id;
  var worker_rate;
  rating_bar({this.worker_id,this.maximumRating,this.onRatingSelected,this.worker_rate});

  @override
  _rating_bar createState() => _rating_bar(w_uid: worker_id,w_rate: worker_rate);
}

class _rating_bar extends State<rating_bar> {


  String w_uid;
  var w_rate;

  _rating_bar({this.w_uid,this.w_rate});

  String userId = (FirebaseAuth.instance.currentUser).uid;

  setData() async {
    double curr=_currentRating.toDouble();
    double avg=(w_rate+curr+5)/3;

    print('Current Rating of Worker: $curr  \n');
    print('Average Rating of Worker: $avg  \n');

    if(w_rate!=0){
      FirebaseFirestore.instance
          .collection('workers')
          .doc(w_uid)
          .update({
        "Rating": avg,
        //"Status" : 'available'
      });
    }
    else {
      FirebaseFirestore.instance
          .collection('workers')
          .doc(w_uid)
          .update({
        "Rating": curr,
        //"Status" : 'available'
      });
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Booking')
        .doc(w_uid)
        .delete();
  }

  int _currentRating = 0;

  Widget _buildRatingStar(int index) {
    if (index < _currentRating) {
      return Icon(Icons.star, color: Colors.orange);
    } else {
      return Icon(Icons.star_border_outlined);
    }
  }

  Widget _buildBody() {
    final stars = List<Widget>.generate(this.widget.maximumRating, (index) {
      return GestureDetector(
        child: _buildRatingStar(index),
        onTap: () {
          setState(() {
            _currentRating = index + 1;
          });

          this.widget.onRatingSelected(_currentRating);
        },
      );
    });

    return Column(
      children: [
        SizedBox(height: 30,),
        Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Text('Rate the Work            :      ',style: TextStyle(color: Colors.white,fontSize: 20),),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(40.0)),
                    color: Colors.white54
                ),
                child: Row(
                  children: stars,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: RaisedButton(
            onPressed: () {
              setState(() {
                _currentRating = 0;
              });
              this.widget.onRatingSelected(_currentRating);
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
              padding: const EdgeInsets.fromLTRB(47, 10, 47, 10),
              child: Text(
                'Clear',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          trailing: RaisedButton(
            onPressed: () {
              setData();
              Fluttertoast.showToast(
                  msg: "Thank you for your feedback! ",
                  toastLength: Toast.LENGTH_SHORT);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => userHomePage()),
              );
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
                'Submit',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
            ),
          ),

        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width / 1.2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Rating Page'),
          backgroundColor: Colors.white30,
            automaticallyImplyLeading: false
        ),
        backgroundColor: Colors.black,
        body: _buildBody(),
      ),
    );
  }
}
