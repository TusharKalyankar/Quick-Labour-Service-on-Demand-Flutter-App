import 'package:flutter/material.dart';

class TransactionErrorPAge extends StatefulWidget {
  const TransactionErrorPAge({Key key}) : super(key: key);

  @override
  _TransactionErrorPAgeState createState() => _TransactionErrorPAgeState();
}

class _TransactionErrorPAgeState extends State<TransactionErrorPAge> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage:
                      AssetImage('assets/sad.png'),
                    ),
                  ),
                  Text('Oops !',style: TextStyle(color: Colors.white,fontSize: 30),),
                  SizedBox(height: 5,),
                  Text('There is no Transaction',style: TextStyle(color: Colors.white,fontSize: 30),),
                  SizedBox(height: 10,),
                  Text('Sorry to inform you that, No payments done yet!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),),
                  SizedBox(height: 20,),
                  RaisedButton(
                    onPressed: () {
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
                        'Back',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}


