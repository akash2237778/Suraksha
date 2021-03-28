import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:suraksha/Services/FirebaseFunctions.dart';
import 'package:suraksha/Views/Homepage.dart';
import 'package:suraksha/Views/Login.dart';


class SetContactsDetails extends StatefulWidget {
  @override
  _SetContactsDetailsState createState() => _SetContactsDetailsState();
}

class _SetContactsDetailsState extends State<SetContactsDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _contact1_name = TextEditingController();
  final TextEditingController _contact1_mobile = TextEditingController();
  final TextEditingController _contact2_name = TextEditingController();
  final TextEditingController _contact2_mobile = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Form(

            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(child: Text('Enter contact details', style: TextStyle(fontSize: 30, color: Colors.white,), textAlign: TextAlign.center,)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Contact 1:', style: TextStyle(fontSize: 20, color: Colors.white,), textAlign: TextAlign.center,),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      controller: _contact1_name,
                      decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Name",
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(32.0),
                            borderSide: BorderSide(color: Colors.black),

                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      controller: _contact1_mobile,
                      decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Phone Number",
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(32.0),
                            borderSide: BorderSide(color: Colors.black),

                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Contact 2:', style: TextStyle(fontSize: 20, color: Colors.white,), textAlign: TextAlign.center,),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      controller: _contact2_name,
                      decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Name",
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(32.0),
                            borderSide: BorderSide(color: Colors.black),

                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      controller: _contact2_mobile,
                      decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Phone Number",
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(32.0),
                            borderSide: BorderSide(color: Colors.black),

                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                        var details = {
                          'Contact1': {
                            'name': _contact1_name.text,
                            'mobile': _contact1_mobile.text,
                          },
                          'Contact2': {
                            'name': _contact2_name.text,
                            'mobile': _contact2_mobile.text,
                          }
                        };
                        currentUser.contactData = details;
                        FocusScope.of(context).unfocus();
                        updateValue('users', FirebaseAuth.instance.currentUser.email, details, FirebaseFirestore.instance);

                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                         alignment: Alignment.center,
                          padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            border: Border.all(
                              color: Colors.green,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Text('Submit', style: TextStyle(color: Colors.white, fontSize: 20),),
                      ),
                    ),
                  ),

                ],
              ),
            )),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _contact1_name.dispose();
    _contact2_name.dispose();
    _contact1_mobile.dispose();
    _contact2_mobile.dispose();
    super.dispose();
  }

}