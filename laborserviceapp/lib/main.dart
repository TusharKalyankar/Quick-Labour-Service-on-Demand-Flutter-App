import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loginmodulepnwr/user_root_page.dart';
import 'package:loginmodulepnwr/user_auth.dart';
import 'package:loginmodulepnwr/worker_root_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'SerOne',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: false,
          body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("backround.png"),
                  fit: BoxFit.cover,
                ),
              ),
            // width: MediaQuery
            //     .of(context)
            //     .size
            //     .width / 1,
            // color: Colors.transparent,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "SerOne",
                    style: TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 70,
                      //fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text('Your Home Service Expert',style: TextStyle(color: Colors.white,fontSize: 18),),
                  SizedBox(height: 10),
                  Text('Quick . Affordable . Trusted',style: TextStyle(color: Colors.white,fontSize: 13),),
                  new Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => userRootPage(
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
                        padding: const EdgeInsets.fromLTRB(95, 13, 95, 13),
                        child: Text(
                          'User',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => workerRootPage(
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
                        padding: const EdgeInsets.fromLTRB(85, 13, 85, 13),
                        child: const Text(
                          'Worker',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                   SizedBox(height: 170.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "On Demand Service Provider\n\t\tserone.pvt.ltd@gmail.com",
                          style: TextStyle(color: Colors.white60, fontSize: 13),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}