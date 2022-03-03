import 'package:flutter/material.dart';
import 'dart:math';
import 'main.dart';

class ScrDose extends StatefulWidget {
  const ScrDose({Key? key}) : super(key: key);

  @override
  _ScrDoseState createState() => _ScrDoseState();
}

class _ScrDoseState extends State<ScrDose> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _ctlRate = TextEditingController();
  final TextEditingController _ctlWeight = TextEditingController();
  final TextEditingController _ctlCDose = TextEditingController();
  final TextEditingController _ctlCVol = TextEditingController();
  final FocusNode _fcNodeWt = FocusNode();
  final FocusNode _fcNodeCDose = FocusNode();
  final FocusNode _fcNodeCVol = FocusNode();

  @override
  void initState() {
    super.initState();

    _ctlRate.addListener(() {
      if (_ctlRate.text == '') {
        rate = null;
      } else {
        rate = double.parse(_ctlRate.text);
        showDose();
      }
    });
    _ctlWeight.addListener(() {
      if (_ctlWeight.text == '') {
        weight = null;
      } else {
        weight = double.parse(_ctlWeight.text);
        showDose();
      }
    });
    _ctlCDose.addListener(() {
      if (_ctlCDose.text == '') {
        cDose = null;
      } else {
        cDose = double.parse(_ctlCDose.text);
        showDose();
      }
    });
    _ctlCVol.addListener(() {
      if (_ctlCVol.text == '') {
        cVol = null;
      } else {
        cVol = double.parse(_ctlCVol.text);
        showDose();
      }
    });
  }

  @override
  void dispose() {
    _ctlRate.dispose();
    _ctlWeight.dispose();
    _ctlCDose.dispose();
    _ctlCVol.dispose();
    _fcNodeWt.dispose();
    _fcNodeCDose.dispose();
    super.dispose();
  }

  void showDose() {
    if (rate == null || weight == null || cDose == null || cVol == null) {
    } else {
      num ratefactor = 1;
      switch (valRateType) {
        case 'cc/min':
          ratefactor = 60;
          break;
        case 'cc/hr':
          ratefactor = 1;
          break;
        case 'cc/day':
          ratefactor = 1 / 24;
      }
      num weightfactor = 1;
      if (isWeight) {
        switch (valWeightType) {
          case 'kg':
            weightfactor = pow(10, 0);
            break;
          case 'gram':
            weightfactor = pow(10, -3);
            break;
          case 'lbs':
            weightfactor = 0.453597;
            break;
        }
      } else {
        weight = 1;
        weightfactor = pow(10, 0);
      }
      num cDosefactor = 1;
      switch (valcDoseType) {
        case 'ng':
          cDosefactor = pow(10, -6);
          break;
        case 'mcg':
          cDosefactor = pow(10, -3);
          break;
        case 'mg':
          cDosefactor = pow(10, 0);
          break;
        case 'gram':
          cDosefactor = pow(10, 3);
          break;
        case 'unit':
          cDosefactor = 1;
      }
      // Convert concentration volume to cc
      num cVolfactor = 1;
      if (valcVolumeType == 'liter') {
        cVolfactor = pow(10, 3);
      }
      num dosefactor = 1;
      switch (valDoseType) {
        case 'mcg':
          dosefactor = pow(10, 0);
          break;
        case 'ng':
          dosefactor = pow(10, 3);
          break;
        case 'mg':
          dosefactor = pow(10, -3);
          break;
        case 'gram':
          dosefactor = pow(10, -6);
          break;
        case 'unit':
          dosefactor = 1;
          break;
      }
      switch (valTimeType) {
        case 'min':
          tInf = 1 / 60;
          break;
        case 'hr':
          tInf = 1;
          break;
        case 'day':
          tInf = 24;
          break;
      }

      double numResult = 1000 *
          (rate! * ratefactor) *
          dosefactor *
          tInf *
          ((cDose! * cDosefactor) / (cVol! * cVolfactor)) /
          (weight! * weightfactor);
      result = numResult.toStringAsFixed(2);
      setState(() {});
    }
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
                  controller: _ctlRate,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Infusion rate',
                    labelText: 'IV Rate',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_fcNodeWt);
                  },
                ),
              ),
              const SizedBox(width: 7),
              DropdownButton(
                  value: valRateType,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  underline: const SizedBox(),
                  items: rateType.map((valueItem) {
                    return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    valRateType = newValue;
                    showDose();
                    setState(() {});
                  }),
              const SizedBox(width: 50),
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
                  showDose();
                  setState(
                    () {},
                  );
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
              const SizedBox(width: 20),
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
                  showDose();
                  setState(() {});
                },
              ),
              const SizedBox(width: 50),
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
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
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
                                  FocusScope.of(context)
                                      .requestFocus(_fcNodeCVol);
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
                                  showDose();
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
                                  showDose();
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
                  (result == null || result.length < 1)
                      ? 'Dose : '
                      : 'Dose : $result ',
                  style: const TextStyle(fontSize: 16),
                ),
                DropdownButton(
                    underline: const SizedBox(),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    value: valDoseType,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: doseType.map((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      valDoseType = newValue;
                      showDose();
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
                  underline: const SizedBox(),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  value: valTimeType,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: timeType.map((valueItem) {
                    return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    valTimeType = newValue;
                    showDose();
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
              dose = null;
              valDoseType = 'mcg';
              valTimeType = 'min';
              isWeight = true;
              weight = null;
              valWeightType = 'kg';
              cDose = null;
              valcDoseType = 'mg';
              cVol = null;
              valcVolumeType = 'cc';
              valRateType = 'cc/hr';
              tInf = 1.0;
              result = '';
              _ctlRate.clear();
              _ctlWeight.clear();
              _ctlCDose.clear();
              _ctlCVol.clear();
              setState(() {});
            },
            label: const Text('Refresh', style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
          ),
        ],
      ),
    );
  }
}
