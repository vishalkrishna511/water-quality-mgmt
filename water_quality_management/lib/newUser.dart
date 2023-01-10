import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'errHandler.dart';

class newUser extends StatefulWidget {
  const newUser({super.key});

  @override
  State<newUser> createState() => _newUserState();
}

class _newUserState extends State<newUser> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final emailiD = TextEditingController();
  final userId = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // appBar: AppBar(
      //   title: const Text('Create Account'),
      //   elevation: 0,
      //   centerTitle: true,
      // ),
      body: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Color.fromARGB(255, 42, 122, 11),
                Color.fromARGB(255, 125, 206, 19),
                Color.fromARGB(157, 234, 230, 9)
              ])),
          width: double.infinity,
          height: double.infinity,
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                  child: Text(
                    'Create your new account here...',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 8, right: 8, left: 8),
                child: TextField(
                  controller: firstName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'First Name',
                    fillColor: Colors.white,
                    filled: true,
                    // errorText: 'Enter First Name!!',

                    //focusedBorder:
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: lastName,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: 'Last Name',
                    // errorText: 'Enter Last Name!!',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: userId,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'user ID',
                    border: OutlineInputBorder(),
                    // errorText: 'Enter proper EmailId!!!',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: emailiD,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email ID',
                    border: OutlineInputBorder(),
                    // errorText: 'Enter proper EmailId!!!',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: password,
                  obscureText: true,
                  obscuringCharacter: '*',
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Password',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    // errorText: 'Enter Password',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (password.text.length <= 8) {
                      error1(
                          context, 'Password should be more than 8 characters');
                    } else {
                      if (firstName.text != '' &&
                          lastName.text != '' &&
                          emailiD.text != '' &&
                          userId.text != '' &&
                          password.text != '') {
                        createUser(
                            firstName: firstName.text,
                            lastName: lastName.text,
                            emailiD: emailiD.text,
                            userId: userId.text);
                        final FirebaseAuth _auth = FirebaseAuth.instance;

                        try {
                          await _auth.createUserWithEmailAndPassword(
                            email: emailiD.text,
                            password: password.text,
                          );
                        } on FirebaseAuthException catch (e) {
                          print(e.message);
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const LoginPage()));
                      } else {
                        error1(context, 'Fields can\'t have null value...!');
                      }
                    }
                    firstName.clear();
                    lastName.clear();
                    emailiD.clear();
                    password.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 150, vertical: 12),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  child: const Text('Register'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

createUser(
    {required String firstName,
    required String lastName,
    required String emailiD,
    required String userId}) async {
  final docuser = FirebaseFirestore.instance.collection('users').doc();
  final json = {
    'id': docuser.id,
    'emailID': emailiD,
    'firstName': firstName,
    'lastName': lastName,
    'userId': userId
  };
  await docuser.set(json);
}
