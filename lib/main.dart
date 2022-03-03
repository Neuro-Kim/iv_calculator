import 'package:flutter/material.dart';
import 'scrRate.dart';
import 'scrDose.dart';
import 'scrConc.dart';

double? dose;
double? rate;
bool isWeight = true;
double? weight;
double? cVol;
double? cDose;
double tInf = 1.0;

const doseType = ['ng', 'mcg', 'mg', 'gram', 'unit'];
dynamic valDoseType = 'mcg';
dynamic valcDoseType = 'mg';

const volumeType = ['cc', 'liter'];
dynamic valcVolumeType = 'cc';

const weightType = ['gram', 'kg', 'lbs'];
dynamic valWeightType = 'kg';

const timeType = ['min', 'hr', 'day'];
dynamic valTimeType = 'min';

const rateType = ['cc/min', 'cc/hr', 'cc/day'];
dynamic valRateType = 'cc/hr';

late dynamic result = '';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IV calculator',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'IV calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  final List<Widget> _children = <Widget>[
    const ScrIvRate(),
    const ScrDose(),
    const ScrConc(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xff067a82),
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(child: _children[selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff067a82),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: selectedIndex,
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
            result = '';
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'IV Rate',
            icon: Icon(Icons.watch_later_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Dose',
            icon: Icon(Icons.medication_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Concentration',
            icon: Icon(Icons.waves),
          ),
        ],
      ),
    );
  }
}
