import 'package:flutter/material.dart';
import 'Pages/accountPage.dart';
import 'Pages/homePage.dart';
import 'Pages/incomingAppointmentsPage.dart';
import 'Pages/pastAppointmentsPage.dart';

import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
      },
    );
  }
}


