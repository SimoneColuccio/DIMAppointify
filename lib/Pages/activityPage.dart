import 'dart:developer';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:my_app/Data/activity.dart';
import 'package:my_app/Data/appointment.dart';
import 'package:my_app/Data/openingTime.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../Widgets/bottomMenu.dart';
import 'accountPage.dart';
import 'bookAppointmentPage.dart';

class ActivityPage {
  final String title;

  ActivityPage(this.title);
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
          automaticallyImplyLeading: false,
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
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: a.image != null ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(a.image!.path),
                                      fit: BoxFit.cover,
                                      width: 70,
                                      height: 70,
                                    ),
                                  ) : Container(
                                    color: Colors.grey.shade100,
                                    width: 70,
                                    height: 70,
                                  )
                                ),
                                Expanded(
                                  child: Text(a.category,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Stack(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    a.position,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        openMap(a.position);
                                      },
                                      icon: const Icon(Icons.map)
                                    ),
                                  ),
                                ],
                              ),
                            ]
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text("Services",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              for(var s in a.appTypes)
                                s != "" ? Text("-  $s") : const SizedBox(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text("Weekly hours",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              for(int i = 0; i < a.hours.length; i++)
                                Row(
                                  children: [
                                    SizedBox(width: 120, child: Text(times.weekDay(i))),
                                    SizedBox(width: 50, child: printTime(
                                        getHour(a.hours[i][0]),
                                        getMinute(a.hours[i][0])
                                      ),
                                    ),
                                    (a.hours[i][0] != -1) ? SizedBox(width: 50, child: printTime(
                                        getHour(a.hours[i][1]),
                                        getMinute(a.hours[i][1])
                                      ),
                                    ) : const SizedBox(),
                                    !a.continued[i] ? const SizedBox(width: 20) : const SizedBox(),
                                    !a.continued[i] ? SizedBox(width: 50, child: printTime(
                                        getHour(a.hours[i][2]),
                                        getMinute(a.hours[i][2])
                                      ),
                                    ) : const SizedBox(),
                                    !a.continued[i] && (a.hours[i][2] != -1) ? SizedBox(width: 50, child: printTime(
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
          physics: const ClampingScrollPhysics(),
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
                    arguments: ActivityPage(activity.name),
                  ),
                }
            );
          },
        ),
        floatingActionButton: showButton(a) ? FloatingActionButton(
          onPressed: () {
            appointmentIndex = appointmentIndex + 1;
            Navigator.pushNamed(
              context,
              '/bookAppointment',
              arguments: BookAppointmentArguments(
                createAppointment(appointmentIndex - 1, user, a),
                "CREATE"
              ),
            );
          },
          child: const Icon(Icons.bookmark_add)
        ) : null,
        bottomNavigationBar: BottomNavigationBar(
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

  Future <void> openMap(String address) async {
    String googleURL = 'https://www.google.com/maps/search/?api=1&query=$address';
    await canLaunchUrlString(googleURL)
      ? await launchUrlString(googleURL)
      : throw 'Could not launch $googleURL';
  }

  bool showButton(a) {
    bool ret = true;
    ret = ret && (a != null);
    ret = ret && (isLoggedAsUser || isLoggedAsActivity);

    double h = 0;
    for(int i = 0; i < a.hours.length; i++) {
      h = h + a.hours[i][0];
    }
    ret = ret && (h > -7.0);

    return ret;
  }
}