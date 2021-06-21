import 'package:flutter/material.dart';
import 'package:loginmodulepnwr/user_search_results.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'error_page.dart';


class userSearch extends StatefulWidget {
  @override
  _userSearchState createState() => _userSearchState();
}

class _userSearchState extends State<userSearch> {
  String city;
  String occupation;
  var c;
  String _chosenValue;
  String _chosenCityValue;


  final formKey = GlobalKey<FormState>();
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
  GetCount() async{
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('workers')
        .where('City', isEqualTo: city.toLowerCase().trim())
        .where('Occupation', isEqualTo: occupation.toLowerCase().trim()).get();

    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    // print(_myDocCount.length);
    var res = _myDocCount.length.toInt();
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Search"),
        backgroundColor: Colors.white30,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Form(
          key: formKey,
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: <Widget>[
                Container(
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.greenAccent[400], width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1),
                      ),
                      hintText: 'Enter the city which you desire.',
                      hintStyle: TextStyle(color: Colors.white54),
                      labelText: 'City',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                    value.isEmpty ? 'City can\'t be empty' : null,
                    onChanged: (value) => city = value,
                  ),
                ),
                SizedBox(height: 15),
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
                      occupation=_chosenValue;
                    });
                  },
                ),
                SizedBox(height: 10,),
                RaisedButton(
                  onPressed: () async{
                    var c = await GetCount();
                    print('Count of Result: $c');
                    if(c!=0)
                    {
                      if (validateAndSave()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => user_search_result(
                                city_n: city, occupation_n: occupation),
                          ),
                        );
                      }
                    }
                    if(c==0){
                      if (validateAndSave()){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ErrorPage(),
                          ),
                        );
                      }
                    }
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
                    padding: const EdgeInsets.fromLTRB(70, 10, 70, 10),
                    child: Text(
                      'Find',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
