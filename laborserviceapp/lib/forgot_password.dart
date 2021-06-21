import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loginmodulepnwr/user_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ForgotPassword extends StatefulWidget {
  ForgotPassword({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => _ForgotPasswordState();
}

enum FormType {
  login,
  register,
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();

  String _email;
  FormType _formType = FormType.login;
  final auth = FirebaseAuth.instance;

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
    return WillPopScope(
      onWillPop: () async{
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: Container(
                color: Colors.transparent,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: buildInputs() + buildSubmitButtons(),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      SizedBox(height: 100,),
      Text('Hi, nice to meet you!',style: TextStyle(fontFamily: 'Pacifico',fontSize: 20,color: Colors.white),),
      SizedBox(height: 10,),
      Text('Reset Your Password',style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
      SizedBox(height: 40,),
      Container(
        padding: EdgeInsets.only(left: 20,right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(40.0)),
            color: Colors.white24
        ),
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(labelText: 'Email',labelStyle: TextStyle(color: Colors.white)),
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
      new Padding(
        padding: const EdgeInsets.only(top: 30.0),
      ),
      GestureDetector(
        onTap: (){
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
          Navigator.pop(context);
        },
        child:RichText(
          text: TextSpan(
            text: 'Have an Account?',
            style: TextStyle(fontSize: 15.0, color: Colors.white),
            children: <TextSpan>[
              TextSpan(
                text: ' Login',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 10,),

    ];
  }
  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        Center(
          child: RaisedButton(
            onPressed: (){
              validateAndSave();
              auth.sendPasswordResetEmail(email: _email);
              Navigator.of(context).pop();
              Fluttertoast.showToast(
                  textColor: Colors.black,
                  msg: "Mail has been send for password reset",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.TOP);
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
              padding: const EdgeInsets.fromLTRB(57, 10, 57, 10),
              child: Text(
                'Send Request',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ];
    }
  }
}
