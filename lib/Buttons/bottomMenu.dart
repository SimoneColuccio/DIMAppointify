import 'package:flutter/material.dart';

List<BottomNavigationBarItem> getBottomMenu() {
  return const [
    BottomNavigationBarItem(
      label: 'Home',
      icon: Icon(Icons.home),
    ),
    BottomNavigationBarItem(
      label: 'Incoming',
      icon: Icon(Icons.calendar_today),
    ),
    BottomNavigationBarItem(
      label: 'Past',
      icon: Icon(Icons.calendar_month),
    ),
    BottomNavigationBarItem(
      label: 'Account',
      icon: Icon(Icons.account_circle),
    ),
  ];
}
