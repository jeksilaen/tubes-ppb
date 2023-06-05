import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _email = '';
  String _phoneNumber = '';
  String _password = '';

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {}
  }

  List<Map> dataUser = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: RichText(
                        text: TextSpan(
                          text: 'Register Your ',
                          style: TextStyle(
                            fontFamily: 'Merriweather',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 132, 126, 126),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'author',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 223, 121, 37),
                              ),
                            ),
                            TextSpan(
                              text: ' account!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 132, 126, 126),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 400,
                      height: 500,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 300,
                              height: 50,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Full Name!';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _fullName = value;
                                },
                                cursorColor: Color.fromARGB(255, 132, 126, 126),
                                decoration: InputDecoration(
                                    labelText: 'Full Name',
                                    labelStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 132, 126, 126)),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 223, 121, 37)))),
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: 300,
                              height: 50,
                              child: TextFormField(
                                controller: _controllerEmail,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email!';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _email = value;
                                },
                                cursorColor: Color.fromARGB(255, 132, 126, 126),
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 132, 126, 126)),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 223, 121, 37)))),
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: 300,
                              height: 50,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number!';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _phoneNumber = value;
                                },
                                cursorColor: Color.fromARGB(255, 132, 126, 126),
                                decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                    labelStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 132, 126, 126)),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 223, 121, 37)))),
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: 300,
                              height: 50,
                              child: TextFormField(
                                controller: _controllerPassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password!';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _password = value;
                                },
                                cursorColor: Color.fromARGB(255, 132, 126, 126),
                                obscureText: true,
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 132, 126, 126)),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 223, 121, 37)))),
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                createUserWithEmailAndPassword();
                                if (_formKey.currentState!.validate()) {
                                  register(_fullName, _email, _phoneNumber,
                                      _password, dataUser);
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromARGB(255, 223, 121, 37)),
                              ),
                              child: Text(
                                'Register',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("already have an account?"),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()),
                                      );
                                    },
                                    child: Text("click here"))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Container(
              height: 70,
              width: double.infinity,
              color: Color.fromARGB(
                  255, 223, 121, 37), // replace with the desired color
              child: Center(
                  child: Text(
                'Rojak Reference | 2023',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ))),
        ],
      ),
    );
  }
}

void register(String fullName, String email, String phoneNumber,
    String password, List dataUser) {
  dataUser.add({
    'fullname': '$fullName',
    'email': '$email',
    'phonenumber': '$phoneNumber',
    'password': '$password'
  });
  print(dataUser);
}
