import 'package:flutter/material.dart';
import 'package:my_app/Buttons/bottomMenu.dart';
import 'package:my_app/Data/activity.dart';

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
    String tit = args.title;

    List<Activity> activities = [];
    for(int i = 0; i < allActivities.length; i++) {
      if(allActivities[i].name.contains(args.title)) {
        activities.add(allActivities[i]);
      }
    }

    var a;
    for(int i = 0; i < allActivities.length; i++) {
      if(allActivities[i].name == args.title) {
        a = allActivities[i];
        break;
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: a != null ? Text(a.name) : Text("Results for $tit"),
          centerTitle: true,
        ),
        body: a != null ? Column(
          children: [
            const Text("Category:"),
            Text(a.category),
            const Text("Description:"),
            Text(a.description),
          ],
        ): ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return ListTile(
                title: Text(
                  activity.name,
                  textAlign: TextAlign.start,
                ),
                onTap: () => {
                  Navigator.pushNamed(
                    context,
                    '/activity',
                    arguments: ActivityPage(0, activity.name),
                  ),
                }
            );
          },
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