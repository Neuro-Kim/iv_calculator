//import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

void showConc() {
  if (dose == null || rate == null || weight == null || cVol == null) {
  } else {
    num dosefactor = 1;
    switch (valDoseType) {
      case 'ng':
        dosefactor = pow(10, -3);
        break;
      case 'mcg':
        dosefactor = pow(10, 0);
        break;
      case 'mg':
        dosefactor = pow(10, 3);
        break;
      case 'gram':
        dosefactor = pow(10, 6);
        break;
      case 'unit':
        dosefactor = 1;
        break;
    }
    num cDosefactor = 1;
    switch (valcDoseType) {
      case 'ng':
        cDosefactor = pow(10, 6);
        break;
      case 'mcg':
        cDosefactor = pow(10, 3);
        break;
      case 'mg':
        cDosefactor = pow(10, 0);
        break;
      case 'gram':
        cDosefactor = pow(10, -3);
        break;
      case 'unit':
        cDosefactor = 1;
        break;
    }
    switch (valTimeType) {
      case 'min':
        tInf = 1;
        break;
      case 'hr':
        tInf = 60;
        break;
      case 'day':
        tInf = 60 * 24;
        break;
    }

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

    // Convert concentration volume to cc
    num cVolfactor = 1;
    if (valcVolumeType == 'liter') {
      cVolfactor = pow(10, 3);
    }

    double numResult = (dose! * dosefactor) *
        (weight! * weightfactor) /
        (rate! * ratefactor) *
        (cVol! * cVolfactor) /
        tInf *
        cDosefactor *
        60 /
        1000;
    result = numResult.toStringAsFixed(2);
  }
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
  }
}

void showRate() {
  if (dose == null || weight == null || cDose == null || cVol == null) {
  } else {
    // Convert dose to mg
    num dosefactor = 1;
    switch (valDoseType) {
      case 'mcg':
        dosefactor = pow(10, -3);
        break;
      case 'ng':
        dosefactor = pow(10, -6);
        break;
      case 'mg':
        dosefactor = pow(10, 0);
        break;
      case 'gram':
        dosefactor = pow(10, 3);
        break;
      case 'unit':
        dosefactor = 1;
        break;
    }
    // Convert weight
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
    // Convert concentration dose to mg
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
    switch (valTimeType) {
      case 'min':
        tInf = 60;
        break;
      case 'hr':
        tInf = 1;
        break;
      case 'day':
        tInf = 1 / 24;
        break;
    }
    num ratefactor = 1;
    switch (valRateType) {
      case 'cc/min':
        ratefactor = 1 / 60;
        break;
      case 'cc/hr':
        ratefactor = 1;
        break;
      case 'cc/day':
        ratefactor = 24;
    }

    double numResult = (dose! * dosefactor) *
        (weight! * weightfactor) *
        tInf *
        (cVol! * cVolfactor) *
        ratefactor /
        (cDose! * cDosefactor);
    result = numResult.toStringAsFixed(2);
  }
}

void initAll(TextEditingController c1, c2, c3, c4) {
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
  c1.clear();
  c2.clear();
  c3.clear();
  c4.clear();
}

class PresetItem {
  String? presetName;
  List<String>? varList;

  PresetItem(this.presetName, this.varList);

  void savePreset(PresetItem presetItem) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(presetItem.presetName!, presetItem.varList!);
  }

  void loadPreset(PresetItem presetItem) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getStringList(presetItem.presetName!);
  }
}

Future<List<String>> getAllkeys() async {
  final prefs = await SharedPreferences.getInstance();
  // prefs.reload();
  // final keys = prefs.getKeys();
  // final prefsMap = <String, dynamic>{};
  // for (String key in keys) {
  //   prefsMap[key] = prefs.get(key);
  // }
  return prefs.getKeys().toList();
}
var allKeys = getAllkeys();

Future<List> getVarList(key) async {
  final prefs = await SharedPreferences.getInstance();
  final varList = prefs.getStringList(key) ?? [];
  return varList;
}

ValueNotifier<int> ChipModified = ValueNotifier<int>(0);


