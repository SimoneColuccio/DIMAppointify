import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_app/Data/activity.dart';
import 'package:my_app/Data/appointment.dart';
import 'package:my_app/Data/openingTime.dart';

import '../Widgets/bottomMenu.dart';
import 'accountPage.dart';
import 'activityManagerPage.dart';
import 'bookAppointmentPage.dart';

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

    OpeningTime times = OpeningTime();

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
        body: a != null ?
        CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
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
                                Expanded(
                                  child: Text(a.category,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                //const SizedBox(width: 10,),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
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
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Services Provided",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              for(var s in a.appTypes)
                                s != "" ? Text("- "+s) : const SizedBox(height: 0,),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Weekly hours",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              for(int i = 0; i < a.hours.length; i++)
                                Row(
                                  children: [
                                    SizedBox(width: 100, child: Text(times.weekDay(i))),
                                    SizedBox(width: 50, child: printTime(
                                        getHour(a.hours[i][0]),
                                        getMinute(a.hours[i][0])
                                      ),
                                    ),
                                    SizedBox(width: 50, child: printTime(
                                        getHour(a.hours[i][1]),
                                        getMinute(a.hours[i][1])
                                      ),
                                    ),
                                    !a.continued[i] ? SizedBox(width: 50, child: printTime(
                                        getHour(a.hours[i][2]),
                                        getMinute(a.hours[i][2])
                                      ),
                                    ) : const SizedBox(),
                                    !a.continued[i] ? SizedBox(width: 50, child: printTime(
                                        getHour(a.hours[i][3]),
                                        getMinute(a.hours[i][3])
                                      ),
                                    ): const SizedBox(),

                                  ],
                                ),
                            ]
                          ),
                        )
                      ],
                    ),
                  )
                ]
              ),
            ),
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
        floatingActionButton: a != null ? FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/bookAppointment',
              arguments: BookAppointmentArguments(
                createAppointment(user, a, DateTime.now(), "")
              ),
            );
          },
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