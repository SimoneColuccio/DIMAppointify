
import 'package:flutter/material.dart';
import 'package:my_app/Buttons/bottomMenu.dart';
import 'package:my_app/Pages/pastAppointmentsPage.dart';

import '../Data/activity.dart';
import 'incomingAppointmentsPage.dart';
//Feature/Stream Builder

bool isLoggedAsUser = false;

bool isLoggedAsActivity = false;

class AccountPage extends StatefulWidget {
  const AccountPage({super.key, required this.index});

  final int index;

  @override
  State<AccountPage> createState() => _AccountPageState(this.index);
}

class _AccountPageState extends State<AccountPage>{
  _AccountPageState(this.ind);
  final int ind;
  final title = "Account";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: !(isLoggedAsUser | isLoggedAsActivity) ? Column(
          children: [
            OutlinedButton(
              onPressed: () {
                isLoggedAsUser = true;
                user = "user1";
                setState(() {});
                },
              child: const Text("Log In as user1"),
            ),
            OutlinedButton(
              onPressed: () {
                isLoggedAsUser = true;
                user = "user2";
                setState(() {});
              },
              child: const Text("Log In as user2"),
            ),
            OutlinedButton(
              onPressed: () {
                isLoggedAsActivity = true;
                user = "activity";
                setState(() {});
              },
              child: const Text("Log In as activity"),
            )
          ],
        ) : Column(
          children: [
            OutlinedButton(
              onPressed: () {
                isLoggedAsUser = false;
                isLoggedAsActivity = false;
                user = "";
                appointments = [];
                pastAppointments = [];
                incomingAppointments = [];
                setState(() {});
              },
              child: const Text("Log Out"),
            ),
            isLoggedAsActivity ? OutlinedButton(
              onPressed: () => clearActivities(),
              child: const Text("Clear")
            ) : const Text(""),
          ],
        ),
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
            items: getBottomMenu(0)
        )
    );
  }
}

String user = "";