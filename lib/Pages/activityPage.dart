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
      if(allActivities[i].name.toLowerCase().contains(args.title.toLowerCase())) {
        activities.add(allActivities[i]);
      }
    }

    var a, r;
    for(int i = 0; i < allActivities.length; i++) {
      if(allActivities[i].name == args.title) {
        a = allActivities[i];
        r = a.rating;
        break;
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: a != null ? Text(a.name) : Text("Results for $tit"),
          centerTitle: true,
        ),
        body: a != null ? Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 70,
                  child: Row(
                    children: [
                      Text(a.category,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 135,),
                      Text("$r/5",
                        style: const TextStyle(
                        fontSize: 17,
                        ),
                      ),
                      const Icon(Icons.star,
                        color: Colors.amber,
                        size: 35,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    a.description,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    const Text("Address",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      a.position,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
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
        floatingActionButton: a != null ? FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.bookmark_add)
        ) : null,
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
            items: getBottomMenu(0)
        )
    );

  }
}