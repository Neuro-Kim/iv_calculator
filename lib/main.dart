import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screen/Rate_screen.dart';
import 'Screen/Dose_screen.dart';
import 'Screen/Conc_screen.dart';
import 'model.dart';


void main() async {
  //final prefs = await SharedPreferences.getInstance();
  getAllkeys();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  late String presetTitle;

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
          result = '';
          setState(() {
            selectedIndex = index;
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
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Enter preset title.'),
                content: TextField(
                  onChanged: (value) {
                    setState(() {
                      presetTitle = value;
                    });
                  },
                  controller: _ctlChip,
                ),
                actions: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.cancel_outlined),
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: const Text('Cancel'),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      List<String>? varList = [];
                      varList.add(dose.toString());//0
                      varList.add(rate.toString());//1
                      varList.add(isWeight ? "1" : "0");//2
                      varList.add(weight.toString());//3
                      varList.add(cVol.toString());//4
                      varList.add(cDose.toString());//5
                      varList.add(tInf.toString());//6
                      varList.add(valDoseType.toString());//7
                      varList.add(valcDoseType.toString());//8
                      varList.add(valcVolumeType.toString());//9
                      varList.add(valWeightType.toString());//10
                      varList.add(valTimeType.toString());//11
                      varList.add(valRateType.toString());//12

                      await prefs.setStringList(presetTitle, varList);
                      print ('FAB : $varList');
                      _ctlChip.clear();

                      Navigator.pop(context);

                      setState(() {
                        chipModified.value++ ;

                      });
                    },
                    label: const Text('OK'),
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
