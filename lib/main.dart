import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'Screen/Rate_screen.dart';
import 'Screen/Dose_screen.dart';
import 'Screen/Conc_screen.dart';
import 'model.dart';

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
  final TextEditingController _ctlChip = TextEditingController();
  late String chipTitle;

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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: () async {
          List<String> varList = [];
          varList.add(dose.toString());
          varList.add(rate.toString());
          varList.add(isWeight ? "1" : "0");
          varList.add(weight.toString());
          varList.add(cVol.toString());
          varList.add(cDose.toString());
          varList.add(tInf.toString());
          varList.add(valDoseType.toString());
          varList.add(valcDoseType.toString());
          varList.add(valcVolumeType.toString());
          varList.add(valWeightType.toString());
          varList.add(valTimeType.toString());
          varList.add(valRateType.toString());

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Enter preset title.'),
                content: TextField(
                  onChanged: (value) {
                    setState(() {
                      chipTitle = value;
                    });
                  },
                  controller: _ctlChip,
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _ctlChip.clear();
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }, // Add Tag, Add Drug의 2가지
      ),
    );
  }
}
