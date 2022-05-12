import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screen/Rate_screen.dart';
import 'Screen/Dose_screen.dart';
import 'Screen/Conc_screen.dart';
import 'model.dart';
import 'dart:developer' as dev;

void main() async {
  dev.log('main');
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
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
        ).copyWith(
          secondary: Colors.blue,
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          bodyText2: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
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
                  ElevatedButton(
                    child: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: const Text('OK'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      List<String>? varList = [];
                      addVarList(varList);
                      await prefs.setStringList(presetTitle, varList);
                      _ctlChip.clear();
                      Navigator.pop(context);

                      chipModified.value++;
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
