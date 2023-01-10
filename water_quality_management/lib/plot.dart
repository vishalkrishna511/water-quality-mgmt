import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:water_quality_management/dashboard.dart';
import 'package:water_quality_management/homepage.dart';
import 'package:water_quality_management/login.dart';

class LinePlot extends StatefulWidget {
  const LinePlot({super.key});

  @override
  State<LinePlot> createState() => _LinePlotState();
}

class _LinePlotState extends State<LinePlot> {
  List<TDSData> chartData = [];
  TooltipBehavior _tooltipBehavior = TooltipBehavior();
  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    chartData = getChartData();
    Timer.periodic(const Duration(seconds: 1), updateDataSource);
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentIndex = 1;
    return SafeArea(
      child: Scaffold(
        body: SfCartesianChart(
          title: ChartTitle(text: 'Time vs TDS!'),
          legend: Legend(isVisible: true),
          tooltipBehavior: _tooltipBehavior,
          series: <ChartSeries<TDSData, String>>[
            SplineSeries<TDSData, String>(
              splineType: SplineType.cardinal,
              cardinalSplineTension: 0.5,
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesController = controller;
              },
              dataSource: chartData,
              name: 'TDS (in ppm)',
              xValueMapper: (TDSData obj, _) => obj.time,
              yValueMapper: (TDSData obj, _) => obj.tds,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              enableTooltip: true,
            )
          ],
          primaryXAxis: CategoryAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            title: AxisTitle(text: 'Time'),
          ),
          primaryYAxis: NumericAxis(
              title: AxisTitle(text: 'TDS (ppm)'),
              labelFormat: '{value} ppm',
              edgeLabelPlacement: EdgeLabelPlacement.hide),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Dashboard(),
                  ),
                );
                break;
              // case 1:
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (BuildContext context) => const LinePlot(),
              //     ),
              //   );
              //   break;
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
      ),
    );
  }

  List<TDSData> getChartData() {
    final List<TDSData> chartsData = [
      TDSData('Null', 0.0),
    ];
    return chartsData;
  }

  Future<void> updateDataSource(Timer timer) async {
    var cloud =
        await FirebaseFirestore.instance.collection('Node$nodeNum').get();
    var index = cloud.docs.length - 2;
    chartData.add(TDSData(cloud.docs[index]['Time'], cloud.docs[index]['TDS']));
    // chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
      addedDataIndex: chartData.length - 1,
    );
  }
}

class TDSData {
  String time;
  double tds;

  TDSData(this.time, this.tds) {
    tds = tds;
    time = time;
  }
}
