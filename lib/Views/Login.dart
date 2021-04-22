
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:suraksha/Services/notification.dart';

import 'package:suraksha/Views/Homepage.dart';
import 'package:suraksha/Views/Registration.dart';
import '../Entity/User.dart' as us;

us.User currentUser;
final userLoginAct = ValueNotifier<us.User>(currentUser);


final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  bool isProgressing = false;

  @override
  void initState() {
    initialize();
    notitficationPermission();

   // initMessaging();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Center(
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
                      controller: _emailController,
                      decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Username",
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
                      obscureText: true,
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
                      controller: _passwordController,
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
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.green,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        onPressed: () {
                          setState(() {
                            isProgressing = true;
                          });

                          FocusScope.of(context).requestFocus(new FocusNode());
                          if (_emailController != null &&
                              _passwordController != null) {
                            print(_emailController.text);
                            print(_passwordController.text);
                            login(_emailController.text, _passwordController.text,
                                context);
                          }

                          //y_register();
                        },
                        child: Text("Login",
                            textAlign: TextAlign.center,
                            style: style.copyWith(
                                color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Center(
                        child: isProgressing
                            ? CircularProgressIndicator(
                          strokeWidth: 2,
                          backgroundColor: Colors.white,
                        )
                            : Container()),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Center(
                      child: Container(
                        child: Text('Don\'t have account? Click to Sign Up', style: TextStyle(fontSize: 15),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Center(
                      child: Container(
                        child: Text(errorMsg!=null?errorMsg:'', style: TextStyle(fontSize: 15),),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
String errorMsg;

void login(String email, String password, BuildContext context) async {
  await Firebase.initializeApp();
  var user = (await _auth.signInWithEmailAndPassword(email: email, password: password).onError((error, stackTrace){
    errorMsg = error.toString();
  }));
  CollectionReference ref= FirebaseFirestore.instance.collection('users');
  var snapshot = await ref.doc(user.user.email).get();
  print("snapshot :  " +  snapshot.data().toString());
  currentUser = us.User(name: snapshot.data()['name'], mobile: snapshot.data()['mobile'], mail: snapshot.data()['email'], contactData: {'Contact1': snapshot.data()['Contact1'], 'Contact2': snapshot.data()['Contact2']});
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => HomePage()),
  );
}
