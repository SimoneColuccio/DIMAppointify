
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.index, required this.title});

  final int index;
  final String title;

  @override
  State<HomePage> createState() => _HomePageState(this.index, this.title);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(this.ind, this.tit);
  final int ind;
  final String tit;
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Search for an activity');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tit),
        automaticallyImplyLeading: false, //to prevent automatic return button
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: ind,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.red.withOpacity(.60),
        onTap: (value) {
          switch (value) {
            case 1:
              Navigator.pushNamed(context, '/incoming');
              break;
            case 2:
              Navigator.pushNamed(context, '/past');
              break;
            case 3:
              Navigator.pushNamed(context, '/account');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            label: 'HomePage',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Incoming',
            icon: Icon(Icons.calendar_today),
          ),
          BottomNavigationBarItem(
            label: 'Past Appointments',
            icon: Icon(Icons.calendar_month),
          ),
          BottomNavigationBarItem(
            label: 'Account',
            icon: Icon(Icons.account_circle),
          ),
        ]
      )
    );
  }
}