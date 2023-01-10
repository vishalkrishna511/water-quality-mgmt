import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:water_quality_management/dashboard.dart';
import 'package:water_quality_management/homepage.dart';

import 'package:water_quality_management/newUser.dart';
import 'errHandler.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = TextEditingController();
    final pass = TextEditingController();
    final List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];
    Future login() async {
      try {
        FocusScope.of(context).requestFocus(new FocusNode());
        await FirebaseFirestore.instance
            .collection("users")
            .where("userId", isEqualTo: user.text)
            .limit(1)
            .get()
            .then(
          (value) async {
            if (value.docs.isEmpty) {
              throw Exception("Login Error");
            } else {
              String _email = value.docs[0]['emailID'];

              await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: _email,
                password: pass.text.trim(),
              );
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const Homepage(),
                ),
              );
            }
          },
        );
      } catch (err) {
        error1(context, err.toString());
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 42, 122, 11),
                Color.fromARGB(255, 125, 206, 19),
                Color.fromARGB(157, 234, 230, 9)
              ],
            ),
          ),
          width: double.infinity,
          height: double.infinity,
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('images/splashBg.png'),
              const Text(
                'WATER QUALITY MANAGEMENT SYSTEM',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: user,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          fillColor: Colors.white,
                          hintText: 'Username:',
                          filled: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: pass,
                        obscureText: true,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          fillColor: Colors.white,
                          hintText: 'Password:',
                          filled: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 15),
                            textStyle: const TextStyle(fontSize: 18)),
                        onPressed: () {
                          login();
                        },
                        child: const Text('LOGIN'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an Account..?",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const newUser()));
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              primary: const Color.fromARGB(255, 66, 24, 233)),
                          child: const Text('Register Here!'),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                          // backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
