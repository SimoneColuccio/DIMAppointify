import 'package:flutter/material.dart';
import 'accountPage.dart';
import 'activityManagerPage.dart';
import 'activityPage.dart';
import 'homePage.dart';
import 'incomingAppointmentsPage.dart';
import 'pastAppointmentsPage.dart';

void main() {
  runApp(const MyApp(title: "Appointify"));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.title});
  final String title;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(index: 0, title: title),
        '/incoming': (context) => const IncomingAppPage(index: 1),
        '/past': (context) => const PastAppPage(index: 2),
        '/account': (context) => const AccountPage(index: 3),
        '/activity': (context) => const ActivityPageScreen(),
        '/addActivity': (context) => const EditActivityPageScreen(),
      },
    );
  }
}


