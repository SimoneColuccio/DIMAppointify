import 'package:flutter/material.dart';
import 'package:my_app/Buttons/bottomMenu.dart';

class ActivityPage {
  final int index;
  final String title;

  ActivityPage(this.index, this.title);
}


class ActivityPageScreen extends StatelessWidget {
  const ActivityPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute
    // settings and cast them as ScreenArguments.
    final args = ModalRoute.of(context)!.settings.arguments as ActivityPage;

    return Scaffold(
        appBar: AppBar(
          title: Text(args.title),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: args.index,
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
                case 3:
                  Navigator.pushNamed(context, '/account');
                  break;
              }
            },
            items: getBottomMenu()
        )
    );

  }
}