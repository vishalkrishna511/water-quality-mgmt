import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:water_quality_management/homepage.dart';
import 'package:water_quality_management/plot.dart';
import 'package:water_quality_management/splashPage.dart';

import 'login.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    var currentIndex = 0;
    Map<String, dynamic> statusofNode;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Dashboard : Node $nodeNum'),
      ),
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
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('Node$nodeNum').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
              // print(nodeNum);
            } else {
              var index = snapshot.data!.docs.length;

              var data =
                  snapshot.data!.docs[index - 2].data() as Map<String, dynamic>;
              statusofNode =
                  snapshot.data!.docs[index - 1].data() as Map<String, dynamic>;
              Dashboard d = const Dashboard();
              // d.time(data['Time']);
              // d.temp(data['Temp']);

              return ListView(
                children: [
                  statusofNode['isLive']
                      ? const Center(
                          child: Text(
                            'Online',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : const Center(
                          child: Text(
                            'Offline',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                  Center(
                    child: Text(
                      'pH ::/* ${data['pH']}*/ ',
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'OoohBaby',
                          fontSize: 20),
                    ),
                  ),
                  Center(
                    child: Text(
                      'TDS :: ${data['TDS']} ppm',
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'OoohBaby',
                          fontSize: 20),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        var collection = FirebaseFirestore.instance
                            .collection('Node$nodeNum');
                        collection
                            .doc('Status')
                            .update({'isLive': false}) // <-- Updated data
                            .then((_) => print('Success'))
                            .catchError((error) => print('Failed: $error'));
                      },
                      child: const Text('Refresh'))
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.cyan[50],
        unselectedLabelStyle:
            const TextStyle(color: Colors.white, fontSize: 14),
        unselectedItemColor: Colors.white,
        currentIndex: currentIndex,
        items: [
          const BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Plot',
            icon: Icon(
              Icons.stacked_line_chart_rounded,
              color: Colors.cyan[50],
            ),
          ),
          BottomNavigationBarItem(
            label: 'Logout',
            icon: Icon(
              Icons.logout_rounded,
              color: Colors.cyan[50],
            ),
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              // print(nodeNum);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const Homepage(),
                ),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const LinePlot(),
                ),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const LoginPage(),
                ),
              );
              break;
          }
        },
      ),
    );
  }
}
