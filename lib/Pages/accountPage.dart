
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key, required this.index});

  final int index;

  @override
  State<AccountPage> createState() => _AccountPageState(this.index);
}

class _AccountPageState extends State<AccountPage>{
  _AccountPageState(this.ind);
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
                case 2:
                  Navigator.pushNamed(context, '/past');
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