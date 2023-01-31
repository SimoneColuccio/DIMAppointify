import 'package:flutter/material.dart';

List<BottomNavigationBarItem> getBottomMenu(int notifications) {
  return [
    const BottomNavigationBarItem(
      label: 'Home',
      icon: Icon(Icons.home),
    ),
    notifications != 0 ? BottomNavigationBarItem(
      label: 'Incoming',
      icon: Stack(
        children: <Widget>[
          const Icon(Icons.calendar_today),
          Positioned(
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15),
              ),
              constraints: const BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Text(notifications.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
      //Icon(Icons.calendar_today),
    ) : const BottomNavigationBarItem(
        label: 'Incoming',
    icon: Icon(Icons.calendar_today),
    ),
    const BottomNavigationBarItem(
      label: 'Past',
      icon: Icon(Icons.calendar_month),
    ),
    const BottomNavigationBarItem(
      label: 'Account',
      icon: Icon(Icons.account_circle),
    ),
  ];
}
