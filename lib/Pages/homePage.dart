

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:haversine_distance/haversine_distance.dart';
import 'package:my_app/Data/activity.dart';
import 'package:my_app/Pages/accountPage.dart';
import 'package:my_app/Pages/activityPage.dart';

import '../Data/category.dart';
import '../Widgets/bottomMenu.dart';
import 'activityManagerPage.dart';
import 'incomingAppointmentsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.index, required this.title});

  final int index;
  final String title;

  @override
  State<HomePage> createState() => _HomePageState(index, title);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(this.ind, this.tit);
  final int ind;
  final String tit;

  final controller = TextEditingController();
  final minController = TextEditingController();
  final maxController = TextEditingController();
  final dataController = TextEditingController();
  final searchFocusNode = FocusNode();
  final minFocusNode = FocusNode();
  final maxFocusNode = FocusNode();
  final dataFocusNode = FocusNode();

  List<Activity> activities = allActivities;
  List<String> categories = allCategories;

  bool filtering = false;
  bool sug = false;
  bool ordering = false;

  var order = ["Ascending", "Descending"];
  String? ascending = "Ascending";
  var userParameters = ["Name", "Distance", "Rating"];
  var managerParameters = ["Name", "Category", "Date of adding"];
  String? parameter = "Name";

  var distances = [0.0, double.infinity];
  DateTime date = DateTime(DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);
  int minRating = 0;
  String? filteredCategory = "";

  double? lat;
  double? lon;

  double scrollHeight = 0;

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(onFocusChanged);
    minFocusNode.addListener(onMinFocusChanged);
    maxFocusNode.addListener(onMaxFocusChanged);
  }

  void onMinFocusChanged() {
    if((distances[0] > distances[1])) {
      maxController.text = minController.text;
      distances[1] = double.parse(minController.text);
    }
  }

  void onMaxFocusChanged() {
    if(distances[1] < distances[0]) {
      minController.text = maxController.text;
      distances[0] = double.parse(maxController.text);
    }
  }

  void onFocusChanged() {
    if(searchFocusNode.hasFocus) {
      controller.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {

    scrollHeight = MediaQuery
        .of(context)
        .copyWith()
        .size
        .height;

      getCurrentLocation().then((value) async {
        lat = value.latitude;
        lon = value.longitude;
        setState(() {});
      });

      liveLocation();
      setState(() {});
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: Text(tit),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: (!isLoggedAsActivity) ? CustomScrollView(
        slivers: [
          if (!filtering & !ordering) getUserMainAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                if (sug & !filtering & !ordering) getSuggestions(),
                if (ordering) orderActivities(userParameters),
                if (filtering) filterUserActivities(),
                if (!searchFocusNode.hasFocus & !filtering & !ordering) printCategoryLabels(),
                if (!searchFocusNode.hasFocus) const Divider(color: Colors.red),
                if (!searchFocusNode.hasFocus & !filtering & !ordering) printUserActivityElement(),
              ]
            ),
          ),
        ],
      ) : CustomScrollView(
        slivers: [
          getManagerMainAppBar(),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  if(!filtering & !ordering) printActivityManagerElement(),
                  if (ordering) orderActivities(managerParameters),
                  if (filtering) filterManagerActivities(),
                  const Divider(color: Colors.red),
                ]
              )
          )
        ]
      ),
      bottomNavigationBar: SizedBox(
        height: 55,
        child: BottomNavigationBar(
          currentIndex: ind,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.red.withOpacity(.60),
          onTap: (value) {
            switch (value) {
              case 0:
                filtering = false;
                ordering = false;
                setState(() {
                });
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
          items: getBottomMenu(incomingAppointments.length)
        ),
      )
    );
  }

  IconButton? createSuffix(){
    return searchFocusNode.hasFocus
        ? IconButton(
          onPressed: (){
            controller.text = "";
            searchFocusNode.unfocus();
            sug = false;
            setState(() {});
            return;
          },
          icon: const Icon(Icons.clear)
        ) : null;
  }

  void searchActivity(String query) {
    final suggestions = allActivities.where((activity) {
      final activityName = activity.name.toLowerCase();
      final input = query.toLowerCase();
      return activityName.contains(input);
    }).toList();
    setState(() => activities = suggestions);
  }

  Widget _buildPopupDialogConfirm(BuildContext context, Activity activity) {
    return AlertDialog(
      title: const Text('Are you sure?'),
      content: const Text("If you delete this activity you'll lose all related data"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  deleteActivity(activity);
                  setState(() {});
                  Navigator.of(context).pop();
                },
                child: const Text("Yes"),
              ),
            )
          ],
        ),
      ],
    );
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  /// Sorts the activities in homepage basing on parameter and ascending passed as method parameters
  List<Activity> sortActivities(String? parameter, String? ascending, List<Activity> acts) {
    switch (parameter) {
      case "Name":
        if(ascending == "Ascending") {
          acts.sort((a, b) => a.name.compareTo(b.name));
        } else {
          acts.sort((a, b) => - a.name.compareTo(b.name));
        }
        break;
      case "Distance":
        if(ascending == "Ascending") {
          acts.sort((a, b) => a.position.compareTo(b.position));
        } else {
          acts.sort((a, b) => - a.position.compareTo(b.position));
        }
        break;
      case "Category":
        if(ascending == "Ascending") {
          acts.sort((a, b) => a.category.compareTo(b.category));
        } else {
          acts.sort((a, b) => - a.category.compareTo(b.category));
        }
        break;
      case "Rating":
        if(ascending == "Ascending") {
          acts.sort((a, b) => a.rating.compareTo(b.rating));
        } else {
          acts.sort((a, b) => - a.rating.compareTo(b.rating));
        }
        break;
      case "Date":
        if(ascending == "Ascending") {
          acts.sort((a, b) => a.dateOfAdding.compareTo(b.dateOfAdding));
        } else {
          acts.sort((a, b) => - a.dateOfAdding.compareTo(b.dateOfAdding));
        }
        break;
      default :
        acts.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    return acts;
  }

  /// Prints Name, Category, Rating and Distance labels for activities
  Widget printActivityLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SizedBox(
          width: 138,
          child: Text("Name",
            style: TextStyle(color: Colors.black),
          ),
        ),
        SizedBox(
          width: 132,
          child: Text("Category",
            style: TextStyle(color: Colors.black),
          ),
        ),
        SizedBox(
          width: 50,
          child: Text("Rating",
            style: TextStyle(color: Colors.black),
          ),
        ),
        SizedBox(
          width: 59,
          child: Text("Distance",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  /// Prints Name, Category, Rating and Distance attributes for all printed user activities
  Widget printUserActivityElement() {
    return SizedBox(
      height: scrollHeight - 280,
      child: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          int distance = -1;
          if((lat != null) && (lon != null) && (activity.lat != null) && (activity.lon != null)) {
            distance = calculateDistance(lat!, lon!, activity.lat!, activity.lon!);
          }

          if((filteredCategory == "" || activity.category == filteredCategory) && (activity.rating >= minRating) && (distance >= distances[0] && distance <= distances[1] || distance == -1)){
            return ListTile(
              title: SizedBox(
                height: 105,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                      child: printActivityImage(activity, 70),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(activity.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          Text(activity.category,
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(distance != -1 ? "\n$distance km" : "\n___ km",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const Icon(Icons.star,
                          color: Colors.amber,
                          size: 35,
                        ),
                        Text("${activity.rating}/5",
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () => {
                Navigator.pushNamed(
                  context,
                  '/activity',
                  arguments: ActivityPage(ind, activity.name),
                ),
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  /// Prints Name and Category attributes plus edit and delete buttons for all printed manager activities
  Widget printActivityManagerElement () {
    return SizedBox(
      height: 1000,
      child: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          if(filteredCategory == "" || activity.category == filteredCategory) {
            return ListTile(
              onTap: () {
                Navigator.pushNamed(context,
                  '/activity',
                  arguments: ActivityPage(ind, activity.name),
                );
              },
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(activity.name,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  Expanded(
                    child: Text(activity.category,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/addActivity',
                                arguments: EditActivityPage(
                                    ind, "Edit category",
                                    activity),
                              ).then(onGoBack);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialogConfirm(
                                        context, activity),
                              );
                            },
                            icon: const Icon(Icons.delete),
                          )
                        ],
                      )
                  )
                ],
              ),
            );
          } else {
            return const SizedBox(width: 0, height: 0,);
          }
        },
      ),
    );
  }

  /// Order activities basing on list parameters passed as method parameter
  Widget orderActivities (List<String> parameters) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 140,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  const SizedBox(
                      width: 130,
                      child: Text("Sort by")
                  ),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: parameter,
                      items: parameters.map((cat) => DropdownMenuItem<String>(
                        value: cat,
                        child: Text(cat, style: const TextStyle(fontSize: 15),
                        ),
                      )).toList(),
                      onChanged: (cat) => setState(() =>  parameter = cat),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  const SizedBox(
                      width: 130,
                      child: Text("Order")
                  ),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: ascending,
                      items: order.map((cat) => DropdownMenuItem<String>(
                        value: cat,
                        child: Text(cat, style: const TextStyle(fontSize: 15),
                        ),
                      )).toList(),
                      onChanged: (cat) => setState(() =>  ascending = cat),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() {
                      ordering = false;
                      ascending = "Ascending";
                      parameter = "Name";
                    }), child: const Text("Reset"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() {
                      ordering = false;
                      allActivities = sortActivities(parameter, ascending, allActivities);
                    }), child: const Text("Apply"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Makes the user filter its activities in homepage
  Widget filterUserActivities() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 300,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  const SizedBox(
                      width: 150,
                      child: Text("Category")
                  ),
                  //const SizedBox(width: 60,),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: filteredCategory,
                      items: categories.map((cat) => DropdownMenuItem<String>(
                        value: cat,
                        child: Text(cat, style: const TextStyle(fontSize: 15),
                        ),
                      )).toList(),
                      onChanged: (cat) => setState(() => filteredCategory = cat),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  const SizedBox(
                      width: 150,
                      child: Text("Distance")
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: TextField(
                              controller: minController,
                              focusNode: minFocusNode,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Min km',
                              ),
                              onChanged: (text) {
                                distances[0] = double.parse(minController.text);
                                setState(() {});
                              },
                              onSubmitted: (text) {
                                distances[0] = double.parse(minController.text);
                                if(distances[0] > distances[1]) {
                                  maxController.text = minController.text;
                                  distances[1] = double.parse(minController.text);
                                }
                                setState(() {});
                              },
                            )
                        ),
                        const SizedBox(width: 75,),
                        Expanded(
                          child: TextField(
                            controller: maxController,
                            focusNode: maxFocusNode,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Max km',
                            ),
                            onChanged: (text) {
                              distances[1] = double.parse(maxController.text);
                              setState(() {});
                            },
                            onSubmitted: (text) {
                              distances[1] = double.parse(maxController.text);
                              if(distances[1] < distances[0]) {
                                minController.text = maxController.text;
                                distances[0] = distances[1];
                              }
                              setState(() {});
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  const SizedBox(
                      width: 150,
                      child: Text("Rating")
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        for(int i = 1; i <= 5; i++)
                          IconButton(onPressed: () {
                            if (minRating == i) {
                              minRating = 0;
                            } else {
                              minRating = i;
                            }
                            setState(() {});
                          }, icon: (minRating < i) ? const Icon(Icons.star_border) : const Icon(Icons.star)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            /*Expanded(
              child: Row(
                children: [
                  const SizedBox(
                      width: 150,
                      child: Text("Available date")
                  ),
                  Expanded(
                    child: TextField(
                      controller: dataController,
                      focusNode: dataFocusNode,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today), //icon of text field
                          labelText: "Enter Date" //label text of field
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.datetime,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100));
                        if (pickedDate != null) {
                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                          date = pickedDate;
                          setState(() {
                            dataController.text = formattedDate; //set output date to TextField value.
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
            ),*/
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() {
                      filteredCategory = "";
                      distances = [0.0, double.infinity];
                      date = DateTime(DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);
                      minRating = 0;
                      filtering = false;
                      minController.text = "";
                      maxController.text = "";
                      dataController.text = "";
                    }), child: const Text("Reset"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() {
                      filtering = false;
                      minController.text = "";
                      maxController.text = "";
                      dataController.text = "";
                    }), child: const Text("Apply"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  /// Makes the manager filter its activities in homepage
  Widget filterManagerActivities() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 150,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  const SizedBox(
                      width: 150,
                      child: Text("Category")
                  ),
                  //const SizedBox(width: 60,),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: filteredCategory,
                      items: categories.map((cat) =>
                          DropdownMenuItem<String>(
                            value: cat,
                            child: Text(cat,
                              style: const TextStyle(
                                  fontSize: 15),
                            ),
                          )).toList(),
                      onChanged: (cat) =>
                          setState(() => filteredCategory = cat),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        setState(() {
                          filteredCategory = "";
                          filtering = false;
                        }), child: const Text("Reset"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        setState(() {
                          filtering = false;
                        }), child: const Text("Apply"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget printActivityImage(Activity activity, double size) {
    if(activity.image != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(activity.image!.path),
          fit: BoxFit.cover,
          width: size,
          height: size,
        ),
      );
    } else {
      return Container(
        color: Colors.grey.shade100,
        width: size,
        height: size,
      );
    }
  }

  /// Returns the real-time suggested activities based on current search
  Widget getSuggestions() {
    return SizedBox(
      height: scrollHeight,
      child: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: printActivityImage(activity, 50),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.name,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        activity.category,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () => {
                Navigator.pushNamed(
                  context,
                  '/activity',
                  arguments: ActivityPage(ind, activity.name),
                ),
              }
          );
        },
      ),
    );
  }

  /// Returns the main user app bar (when he doesn't filter/order)
  Widget getUserMainAppBar () {
    return SliverAppBar(
      toolbarHeight: 55,
      backgroundColor: Colors.redAccent,
      automaticallyImplyLeading: false,
      floating: true,
      pinned: true,
      snap: false,
      leading: TextButton(
          onPressed: () {
            searchFocusNode.unfocus();
            sug = false;
            ordering = true;
            setState(() {});
          },//Open filtering options
          child: const Icon(Icons.list, color: Colors.white,)
      ),
      title: Container(
        width: double.infinity,
        height: 40,
        color: Colors.white,
        child: TextField(
          controller: controller,
          focusNode: searchFocusNode,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search for something...',
            suffixIcon: createSuffix(),
          ),
          onSubmitted: (text) {
            Navigator.pushNamed(
              context,
              '/activity',
              arguments: ActivityPage(ind, text),
            );
            controller.text = "";
            sug = false;
            setState(() {});
          },
          onChanged: searchActivity,
          onTap: () => setState(() {
            sug = true;
          }),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              filtering = true;
              ordering = false;
              searchFocusNode.unfocus();
              sug = false;
              setState(() {});
            },//Open filtering options
            child: const Icon(Icons.filter_alt, color: Colors.white,)
        )
      ],
    );
  }

  /// Returns the main manager app bar (when he doesn't filter/order)
  Widget getManagerMainAppBar () {
    return SliverAppBar(
      backgroundColor: Colors.redAccent,
      automaticallyImplyLeading: false,
      floating: true,
      pinned: true,
      snap: false,
      leading: (!filtering & !ordering) ? TextButton(
          onPressed: () {
            ordering = true;
            filtering = false;
            setState(() {});
          },//Open filtering options
          child: const Icon(Icons.list, color: Colors.white,)
      ) : null,
      title: (!filtering && !ordering) ? SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/addActivity',
                arguments: EditActivityPage(ind, "Add activity", createActivity()),
              ).then(onGoBack);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white
            ),
            child: const Text("Add a new activity",
                style: TextStyle(
                    color: Colors.red
                )
            )
        ),
      ) :  Text(filtering ? "Filter your activities" : "Order your activities",
        textAlign: TextAlign.center,
      ),
      actions: [
        if (!filtering & !ordering) TextButton(
            onPressed: () {
              filtering = true;
              ordering = false;
              setState(() {});
            },//Open filtering options
            child: const Icon(Icons.filter_alt, color: Colors.white,)
        )
      ],
    );
  }

  /// Prints all the categories that can be clicked to easy obtain only the related activities
  Widget printCategoryLabels() {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for(int i = 1; i < categories.length ; i++)
            IconButton(
              onPressed: () => {
                if (filteredCategory == categories[i]) {
                  filteredCategory = ""
                } else {
                  filteredCategory = categories[i],
                },
                setState(() {})
              },
              icon: getIcon(categories[i], filteredCategory),
            ),
        ],
      ),
    );
  }

  /// Returns the distance between two coordinates
  int calculateDistance(double lat1, double lon1, double lat2, double lon2){
    final start = Location(lat1, lon1);
    final end = Location(lat2, lon2);
    final haversineDistance = HaversineDistance();
    return haversineDistance.haversine(start, end, Unit.KM).floor();
  }

  void update() {
    setState(() {});
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if(permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }
    return await Geolocator.getCurrentPosition();
  }

  void liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
          lat = position.latitude;
          lon = position.longitude;
          setState(() {});
    });
  }

}