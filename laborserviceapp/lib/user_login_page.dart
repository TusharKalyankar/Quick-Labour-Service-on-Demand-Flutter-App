import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:loginmodulepnwr/user_auth.dart';
import 'package:loginmodulepnwr/create_user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'forgot_password.dart';


class userLoginPage extends StatefulWidget {
  userLoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => _userLoginPageState();
}

enum FormType {
  login,
  register,
}

class _userLoginPageState extends State<userLoginPage> {
  final formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String _city;
  String _phone;
  FormType _formType = FormType.login;

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
          String userId =
          await widget.auth.signInWithEmailAndPassword(_email, _password);

          Fluttertoast.showToast(
            textColor: Colors.black,
              msg: "User is Logged in",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM);

          print('Signed in: $userId');
        } else {
          String userId = await widget.auth
              .createUserWithEmailAndPassword(_email, _password);
          print('Registered user: $userId');
          print(FieldPath.documentId);
        }
        widget.onSignedIn();
      } catch (e) {
        Fluttertoast.showToast(
            textColor: Colors.black,
            msg: "Wrong Email ID and Password ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
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
      onWillPop: ()async{
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
      Text('Login to get services',style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
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
      Container(
        padding: EdgeInsets.only(left: 20,right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(40.0)),
            color: Colors.white24
        ),
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(labelText: 'Password',labelStyle: TextStyle(color: Colors.white),
            suffix: InkWell(
              onTap: _togglePasswordView,
              child: Icon(_isHidden? Icons.visibility_sharp: Icons.visibility_off_sharp,size: 13,color: Colors.white,),
            ),),
          obscureText: !_isHidden,
          validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
          onSaved: (value) => _password = value,
        ),
      ),
      new Padding(
        padding: const EdgeInsets.only(top: 30.0),
      ),
      GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
        },
        child:RichText(
          text: TextSpan(
            text: 'Forgot Password?',
            style: TextStyle(fontSize: 15.0, color: Colors.white),
            children: <TextSpan>[
              TextSpan(
                text: ' Reset Now',
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
              validateAndSubmit();
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
                'Login',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),

        RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterationPage(
                  auth: Auth(),
                ),
              ),
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
            padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
            child: const Text(
              'Sign Up',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ];
    }
  }
}
