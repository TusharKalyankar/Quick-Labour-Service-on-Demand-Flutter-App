import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:loginmodulepnwr/user_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loginmodulepnwr/main.dart';

class RegisterationPage extends StatefulWidget {
  RegisterationPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  State<StatefulWidget> createState() => _RegistrationPage();
}
enum FormType {login,register}

class _RegistrationPage extends State<RegisterationPage> {
  final formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _city;
  String _phone;
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

  signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyApp(),
      ),
    );
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId =
              await widget.auth.signInWithEmailAndPassword(_email, _password);
          print('Signed in: $userId');
        } else {
          String userId = await widget.auth
              .createUserWithEmailAndPassword(_email, _password);
          print('Registered user: $userId');

          if(userId != Null) {
            Fluttertoast.showToast(
                msg: "User Account Created",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER);
          }
          else{
            Fluttertoast.showToast(
                msg: "Email id is already exist",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER);
          }
              print(FieldPath.documentId);

          final new_user = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .set(
            {
              "Name": _name,
              "User UID": '$userId',
              "Email": _email,
              "Password": _password,
              "City": _city,
              "Phone Number": _phone
            },
          );
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

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  bool _isHidden = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('User Registration'),
            backgroundColor: Colors.white30,
          ),
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
              labelText: 'Name',labelStyle: TextStyle(color: Colors.white),border: OutlineInputBorder()),
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
              labelText: 'Email',labelStyle: TextStyle(color: Colors.white),border: OutlineInputBorder()),
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
                child: Icon(_isHidden? Icons.visibility_sharp: Icons.visibility_off_sharp,color: Colors.white54,size: 15),
              )),
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
              labelText: 'City',labelStyle: TextStyle(color: Colors.white),border: OutlineInputBorder()),
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
              hintText: 'Enter Phone number',hintStyle: TextStyle(color: Colors.white54),
              labelText: 'Phone number',labelStyle: TextStyle(color: Colors.white),border: OutlineInputBorder()),
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
      new Padding(
        padding: const EdgeInsets.only(top: 10.0),
      ),
      Container(),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
    } else {
      return [
        SizedBox(height: 40),
        RaisedButton(
          onPressed: (){
            validateAndSubmit();
            Navigator.pop(context);
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
