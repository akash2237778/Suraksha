
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:suraksha/Services/FirebaseFunctions.dart';
import 'package:suraksha/Views/Login.dart';
import 'package:suraksha/Views/SetContactDetails.dart';
import '../Entity/User.dart' as us;


final FirebaseAuth _auth = FirebaseAuth.instance;

/// Entrypoint example for registering via Email/Password.
class RegisterPage extends StatefulWidget {
  /// The page title.
  final String title = 'Registration';

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _success;
  String _userEmail = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
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
                    child: Text('सुरक्षा Suraksha', style: TextStyle(fontSize: 70, color: Colors.white,), textAlign: TextAlign.center,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      controller: _nameController,
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
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      controller: _emailController,
                      decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Email",
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
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      controller: _mobileController,
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
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      controller: _passwordController,
                      decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Password",
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
                      obscureText: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Confirm Password",
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(32.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }else{
                          if(value != _passwordController.text)
                            return 'Passwords are not same';
                          else
                            return null;
                        }
                      },
                      obscureText: true,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    child: SignInButtonBuilder(
                      icon: Icons.person_add,
                      shape: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(32.0)),
                      backgroundColor: Colors.green,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await _register();
                        }
                      },
                      text: 'Register',
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(_success == null
                        ? ''
                        : (_success
                        ? 'Verification mail sent at $_userEmail'
                        : 'Registration failed')),
                  )
                ],
              ),
            )),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code for registration.
  Future<void> _register() async {
    await Firebase.initializeApp();
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))

        .user;
    if (user != null) {
      setState(() {
        _success = true;
       // user.sendEmailVerification();
        _userEmail = user.email;

        currentUser = us.User( name: _nameController.text, mail: _emailController.text, mobile: _mobileController.text);

        setValue("users", _emailController.text ,{
          'name': _nameController.text,
          'email': _emailController.text,
          'mobile': _mobileController.text,
        }, FirebaseFirestore.instance);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SetContactsDetails()),
        );
      });
    } else {
      _success = false;
    }
  }
}