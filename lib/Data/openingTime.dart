

import 'dart:developer';

import 'package:flutter/material.dart';

class OpeningTime{

  List<int> allHours = [0] + List<int>.generate(24, (i) => i + 1);
  List<int> allMinutes = [0, 15, 30, 45];

  List<int> checkFuture(int i, List<double> hours) {
    List<int> ret = allHours;
    if (i == 0) {
      return ret;
    }
    for(var k in ret) {
      if(k < hours[i - 1]) {
        ret.remove(k);
      }
    }
    return ret;
  }

  String weekDay(int i) {
    switch(i) {
      case 0:
        return "Monday";
      case 1:
        return "Tuesday";
      case 2:
        return "Wednesday";
      case 3:
        return "Thursday";
      case 4:
        return "Friday";
      case 5:
        return "Saturday";
      case 6:
        return "Sunday";
      default:
        return "Week";
    }
  }
}

List<List<double>> initializeHours() {
  return [
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
  ];
}

List<bool> initializeTurns() {
  return [true, true, true, true, true, true, true];
}

int getHour(double hour) {
  return hour.floor();
}

int getMinute(double hour) {
  return (100 * hour - 100 * hour.floor()).toInt();
}

double toDouble(int h, int m) {
  return h + 0.01 * m;
}

int getWeekDay(DateTime date) {
  return date.weekday - 1;
}

Widget printTime(int i, int j) {
  if(i == -1) return const Text("Closed");
  if (i >= 10 && j >= 10) return Text("$i:$j");
  if (i < 10 && j >= 10) return Text("0$i:$j");
  if (i >= 10 && j < 10) return Text("$i:0$j");
  return Text("0$i:0$j");
}


