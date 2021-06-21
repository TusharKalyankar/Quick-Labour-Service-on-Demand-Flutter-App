import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:loginmodulepnwr/user_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loginmodulepnwr/main.dart';

class WorkerRegisterationPage extends StatefulWidget {
  WorkerRegisterationPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => _WorkerRegistrationPage();
}

enum FormType {
  login,
  register,
}

class _WorkerRegistrationPage extends State<WorkerRegisterationPage> {
  final formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String _city;
  String _phone;
  String _occupation;
  String _name;
  FormType _formType = FormType.register;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          // String userId = await widget.auth.signInWithEmailAndPassword(_email, _password);
          // print('Signed in: $userId');
        } else {
          String userId = await widget.auth
              .createUserWithEmailAndPassword(_email, _password);
          Fluttertoast.showToast(
              msg: "Worker Account Created",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER);

          print('Registered user: $userId');
          print(FieldPath.documentId);

          final new_user = await FirebaseFirestore.instance
              .collection('workers')
              .doc(userId)
              .set({
            "Name": _name.toLowerCase().trim(),
            "User UID": '$userId',
            "Email": _email.trim(),
            "Password": _password.trim(),
            "City": _city.toLowerCase().trim(),
            "Phone Number": _phone.trim(),
            "Occupation": _occupation.toLowerCase().trim(),
            "Rating" : 0,
            "Status" : "available",
            "PaymentID": 0
          });
          signOut();
        }
        widget.onSignedIn();
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyApp(),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  bool _isHidden = false;
  String _chosenValue;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Worker Registration'),
            backgroundColor: Colors.white30,
          ),
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                  color: Colors.transparent,
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: buildInputs() + buildSubmitButtons(),
                    ),
                  )),
            ),
          )),
    );
  }

  List<Widget> buildInputs() {
    return [
      Container(
        child: Text('Enter Details',style: TextStyle(color: Colors.white,fontSize: 20),),
      ),
      SizedBox(height: 10,),
      Container(
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.greenAccent[400],
                  width: 1
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.blue,
                  width: 1
              ),
            ),
            hintText: 'Enter Name',hintStyle: TextStyle(color: Colors.white54),
            labelText: 'Name',labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(),),
          validator: (value) => value.isEmpty ? 'Name can\'t be empty' : null,
          onSaved: (value) => _name = value,
        ),
      ),
      SizedBox(height: 10,),
      Container(
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.greenAccent[400],
                  width: 1
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.blue,
                  width: 1
              ),
            ),
            hintText: 'Enter Email',hintStyle: TextStyle(color: Colors.white54),
            labelText: 'Email',labelStyle: TextStyle(color: Colors.white),border: OutlineInputBorder(),),
          // validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          validator: (value) {
            if(value.isEmpty){
              return "Email can\'t be empty";
            }
            if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
              return "Please enter valid email";
            }
            return null;
          },
          onSaved: (value) => _email = value,
        ),
      ),
      SizedBox(height: 10,),
      Container(
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(

              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.greenAccent[400],
                    width: 1
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.blue,
                    width: 1
                ),
              ),
            hintText: 'Enter Password',hintStyle: TextStyle(color: Colors.white54),
            labelText: 'Password',labelStyle: TextStyle(color: Colors.white),border: OutlineInputBorder(),
              suffix: InkWell(
                onTap: _togglePasswordView,
                child: Icon(_isHidden? Icons.visibility_sharp: Icons.visibility_off_sharp,color: Colors.white54,size: 15),)
          ),
          obscureText: !_isHidden,
          validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
          onSaved: (value) => _password = value,
        ),
      ),
      SizedBox(height: 10,),
      Container(
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(

            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.greenAccent[400],
                  width: 1
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.blue,
                  width: 1
              ),
            ),
            hintText: 'Enter City',hintStyle: TextStyle(color: Colors.white54),
              labelText: 'City',labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(),),
          validator: (value) => value.isEmpty ? 'City can\'t be empty' : null,
          onSaved: (value) => _city = value,
        ),
      ),
      SizedBox(height: 10,),
      Container(
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(

            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.greenAccent[400],
                  width: 1
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.blue,
                  width: 1
              ),
            ),
            hintText: 'Enter Phone Number',hintStyle: TextStyle(color: Colors.white54),
            labelText: 'Phone number',labelStyle: TextStyle(color: Colors.white),border: OutlineInputBorder(),),
          // validator: (value) => value.isEmpty ? 'Phone Number can\'t be empty' : null,
          validator: (value) {
            if(value.isEmpty){
              return "Please Enter Phone Number";
            }
            if(value.length < 9){
              return "Please Enter Valid Phone Number";
            }
            return null;
          },
          onSaved: (value) => _phone = value,
        ),
      ),
      SizedBox(height: 10,),
      DropdownButtonFormField<String>(
        dropdownColor: Colors.grey[850],
        decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: const Color(0xFFFF9000),
              width: 5.0,
              style: BorderStyle.solid,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: const Color(0xFF42A5F5),
              width: 1.0,
              style: BorderStyle.solid,
            ),
          ),
        ),
        focusColor:Colors.white,
        value: _chosenValue,
        //elevation: 5,
        style: TextStyle(color: Colors.black),
        iconEnabledColor:Colors.white,
        items: <String>[
          'Electrician',
          'Plumber',
          'Carpenter',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,style:TextStyle(color:Colors.white),),
          );
        }).toList(),
        hint:Text(
          "Please choose Occupation",
          style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
        onChanged: (String value) {
          setState(() {
            _chosenValue = value;
            _occupation=_chosenValue;
          });
        },
      ),

    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
    } else {
      return [
        SizedBox(height: 5,),
        RaisedButton(
          onPressed: (){
            validateAndSubmit();
            // Navigator.pop(context);
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
            padding: const EdgeInsets.fromLTRB(60, 10, 60, 10),
            child: Text(
              'Create',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        SizedBox(height: 20,),
        GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child:RichText(
            text: TextSpan(
              text: 'Have an Account?',
              style: TextStyle(fontSize: 15.0, color: Colors.white),
              children: <TextSpan>[
                TextSpan(
                  text: ' Sign In',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ];
    }
  }
}
