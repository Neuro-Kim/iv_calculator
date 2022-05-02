import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model.dart';

class ScrIvRate extends StatefulWidget {
  const ScrIvRate({Key? key}) : super(key: key);

  @override
  _ScrIvRateState createState() => _ScrIvRateState();
}

class _ScrIvRateState extends State<ScrIvRate> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _ctlDose = TextEditingController();
  final TextEditingController _ctlWeight = TextEditingController();
  final TextEditingController _ctlCDose = TextEditingController();
  final TextEditingController _ctlCVol = TextEditingController();
  final FocusNode _fcNodeWt = FocusNode();
  final FocusNode _fcNodeCDose = FocusNode();
  final FocusNode _fcNodeCVol = FocusNode();

  @override
  void initState() {
    super.initState();

    _ctlDose.addListener(() {
      if (_ctlDose.text == '' || _ctlDose.text == 'null') {
        dose = null;
      } else {
        dose = double.tryParse(_ctlDose.text);
        showRate();
        setState(() {});
      }
    });
    _ctlWeight.addListener(() {
      if (_ctlWeight.text == '' || _ctlWeight.text == 'null') {
        weight = null;
      } else {
        weight = double.tryParse(_ctlWeight.text);
        showRate();
        setState(() {});
      }
    });
    _ctlCDose.addListener(() {
      if (_ctlCDose.text == '' || _ctlCDose.text == 'null') {
        cDose = null;
      } else {
        cDose = double.tryParse(_ctlCDose.text);
        showRate();
        setState(() {});
      }
    });
    _ctlCVol.addListener(() {
      if (_ctlCVol.text == '' || _ctlCVol.text == 'null') {
        cVol = null;
      } else {
        cVol = double.tryParse(_ctlCVol.text);
        showRate();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _ctlDose.dispose();
    _ctlWeight.dispose();
    _ctlCDose.dispose();
    _ctlCVol.dispose();
    _fcNodeWt.dispose();
    _fcNodeCDose.dispose();
    _fcNodeCVol.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 100),
              Expanded(
                child: TextFormField(
                  controller: _ctlDose,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Dose rate',
                    labelText: 'Dose',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_fcNodeWt);
                  },
                ),
              ),
              DropdownButton(
                  value: valDoseType,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  underline: const SizedBox(),
                  items: doseType.map((valueItem) {
                    return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    valDoseType = newValue;
                    showRate();
                    setState(() {});
                  }),
              isWeight
                  ? const Text(
                      ' / kg / ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : const Text(
                      ' / ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
              DropdownButton(
                value: valTimeType,
                icon: const Icon(Icons.keyboard_arrow_down),
                underline: const SizedBox(),
                items: timeType.map((valueItem) {
                  return DropdownMenuItem(
                    value: valueItem,
                    child: Text(valueItem),
                  );
                }).toList(),
                onChanged: (newValue) {
                  valTimeType = newValue;
                  showRate();
                  setState(() {});
                },
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 20),
              Switch(
                activeColor: const Color(0xff067a82),
                value: isWeight,
                onChanged: (newVal) {
                  isWeight = newVal;
                  if (isWeight) {
                    if (_ctlWeight.text == '') {
                      weight = null;
                    } else {
                      weight = double.parse(_ctlWeight.text);
                    }
                  } else {
                    weight = 1;
                  }
                  showRate();
                  setState(() {});
                },
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  controller: _ctlWeight,
                  enabled: isWeight,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Patient weight',
                    labelText: 'Weight',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_fcNodeCDose);
                  },
                  focusNode: _fcNodeWt,
                ),
              ),
              DropdownButton(
                value: valWeightType,
                underline: const SizedBox(),
                icon: const Icon(Icons.keyboard_arrow_down),
                items: weightType.map((valueItem) {
                  return DropdownMenuItem(
                    value: valueItem,
                    child: Text(valueItem),
                  );
                }).toList(),
                onChanged: (newValue) {
                  valWeightType = newValue;
                  showRate();
                  setState(() {});
                },
              ),
              const SizedBox(width: 105),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            height: 150,
            decoration: const BoxDecoration(
              color: Color(0x1400bd9b),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Image(
                      image: AssetImage('assets/iv-bag.png'),
                      width: 70,
                      height: 70,
                    ),
                    Text(
                      'Concentration',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _ctlCDose,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Medication amount',
                                  labelText: 'Amount',
                                ),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(_fcNodeCVol);
                                },
                                focusNode: _fcNodeCDose,
                              ),
                            ),
                            const SizedBox(width: 15),
                            DropdownButton(
                                underline: const SizedBox(),
                                value: valcDoseType,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: doseType.map((valueItem) {
                                  return DropdownMenuItem(
                                    value: valueItem,
                                    child: Text(valueItem),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  valcDoseType = newValue;
                                  showRate();
                                  setState(() {});
                                }),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _ctlCVol,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Volume of diluent',
                                  labelText: 'Volume',
                                ),
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).unfocus();
                                },
                                focusNode: _fcNodeCVol,
                              ),
                            ),
                            const SizedBox(width: 20),
                            DropdownButton(
                                underline: const SizedBox(),
                                value: valcVolumeType,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: volumeType.map((valueItem) {
                                  return DropdownMenuItem(
                                    value: valueItem,
                                    child: Text(valueItem),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  valcVolumeType = newValue;
                                  showRate();
                                  setState(() {});
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(15, 12, 15, 10),
            decoration: const BoxDecoration(
              color: Color(0x142196F3),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (result == null || result.length < 1) ? 'Infusion rate : ' : 'Infusion rate : $result ',
                  style: const TextStyle(fontSize: 16),
                ),
                DropdownButton(
                  underline: const SizedBox(),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  value: valRateType,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: rateType.map((valueItem) {
                    return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    valRateType = newValue;
                    showRate();
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              initAll(_ctlDose, _ctlWeight, _ctlCDose, _ctlCVol);
              setState(() {});
            },
            label: const Text('Refresh', style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder(
              valueListenable: chipModified,
              builder: (context, value, _) {
                return FutureBuilder<List>(
                  future: getAllkeys(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Wrap(
                        spacing: 20.0,
                        runSpacing: 10.0,
                        children: [
                          for (var preset in snapshot.data!)
                            InputChip(
                              labelPadding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                              label: Text(
                                preset,
                                style: const TextStyle(color: Colors.black),
                              ),
                              padding: const EdgeInsets.all(6.0),
                              backgroundColor: const Color(0xffd2eaec),
                              onSelected: (_selected) async {
                                List varList = await getVarList(preset);
                                setState(() {
                                  dose = double.tryParse(varList[0]);
                                  _ctlDose.text = (varList[0] == 'null') ? '' : varList[0];
                                  rate = double.tryParse(varList[1]);
                                  isWeight = (varList[2] == "1") ? true : false;
                                  weight = double.tryParse(varList[3]);
                                  _ctlWeight.text = (varList[3] == 'null') ? '' : varList[3];
                                  cVol = double.tryParse(varList[4]);
                                  _ctlCVol.text = (varList[4] == 'null') ? '' : varList[4];
                                  cDose = double.tryParse(varList[5]);
                                  _ctlCDose.text = (varList[5] == 'null') ? '' : varList[5];
                                  tInf = double.tryParse(varList[6]);
                                  valDoseType = varList[7];
                                  valcDoseType = varList[8];
                                  valcVolumeType = varList[9];
                                  valWeightType = varList[10];
                                  valTimeType = varList[11];
                                  valRateType = varList[12];
                                  print ('chip : $varList');
                                });
                              },
                              onDeleted: () async {
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.remove(preset);
                                setState(() {
                                  chipModified.value++;
                                });
                              },
                            ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              }),
        ],
      ),
    );
  }
}
