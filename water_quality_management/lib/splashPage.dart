import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:water_quality_management/homepage.dart';

import 'login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    gologin();
    super.initState();
  }

  gologin() async {
    await Future.delayed(const Duration(milliseconds: 3000), () {});

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const Homepage();
            } else {
              return const LoginPage();
            }
          }),
    );

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
              Color.fromARGB(157, 234, 230, 9),
            ],
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('images/splashBg.png'),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Water Quality Management System',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(227, 21, 0, 80),
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
