
import 'package:flutter/material.dart';

class PastAppPage extends StatefulWidget {
  const PastAppPage({super.key, required this.index});

  final int index;

  @override
  State<PastAppPage> createState() => _PastAppPageState(this.index);
}

class _PastAppPageState extends State<PastAppPage>{
  _PastAppPageState(this.ind);
  final int ind;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: ind,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.red.withOpacity(.60),
            onTap: (value) {
              switch (value) {
                case 0:
                  Navigator.pushNamed(context, '/');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/incoming');
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