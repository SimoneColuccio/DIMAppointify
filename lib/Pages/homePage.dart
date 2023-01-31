

import 'dart:async';
import 'dart:math';
//import 'dart:developer';

import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:my_app/Buttons/bottomMenu.dart';
import 'package:my_app/Data/activity.dart';
import 'package:my_app/Pages/accountPage.dart';
import 'package:my_app/Pages/activityPage.dart';

import 'package:intl/intl.dart';

import '../Data/category.dart';
import 'activityManagerPage.dart';

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
  var managerParameters = ["Name", "Category", "Date"];
  String? parameter = "Name";

  var distances = [0.0, double.infinity];
  DateTime date = DateTime(DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);
  int minRating = 0;
  String? filteredCategory = "";

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
    setState(() {});
    return Scaffold(
      appBar: AppBar(
        title: Text(tit),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: (!isLoggedAsActivity) ? CustomScrollView(
        slivers: [
          if (!filtering & !ordering) SliverAppBar(
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
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                if(sug & !filtering & !ordering)
                  SizedBox(
                    height: 2000,
                    child: ListView.builder(
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
                            arguments: ActivityPage(ind, activity.name),
                          ),
                          }
                        );
                      },
                    ),
                  ),
                if (ordering) orderActivities(userParameters),
                if (filtering) SizedBox(
                  height: 280,
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
                            SizedBox(
                              width: 260,
                              height: 50,
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
                            SizedBox(
                              width: 250,
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
                                  const SizedBox(width: 100,),
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
                            SizedBox(
                              width: 260,
                              child: Row(
                                children: [
                                  IconButton(onPressed: () {
                                    if (minRating == 1) {
                                      minRating = 0;
                                    } else {
                                      minRating = 1;
                                    }
                                    setState(() {});
                                  }, icon: (minRating < 1) ? const Icon(Icons.star_border) : const Icon(Icons.star)),
                                  IconButton(onPressed: () {
                                    if (minRating == 2) {
                                      minRating = 0;
                                    } else {
                                      minRating = 2;
                                    }
                                    setState(() {});
                                  }, icon: (minRating < 2) ? const Icon(Icons.star_border) : const Icon(Icons.star)),
                                  IconButton(onPressed: () {
                                    if (minRating == 3) {
                                      minRating = 0;
                                    } else {
                                      minRating = 3;
                                    }
                                    setState(() {});
                                  }, icon: (minRating < 3) ? const Icon(Icons.star_border) : const Icon(Icons.star)),
                                  IconButton(onPressed: () {
                                    if (minRating == 4) {
                                      minRating = 0;
                                    } else {
                                      minRating = 4;
                                    }
                                    setState(() {});
                                  }, icon: (minRating < 4) ? const Icon(Icons.star_border) : const Icon(Icons.star)),
                                  IconButton(onPressed: () {
                                    if (minRating == 5) {
                                      minRating = 0;
                                    } else {
                                      minRating = 5;
                                    }
                                    setState(() {});
                                  }, icon: (minRating < 5) ? const Icon(Icons.star_border) : const Icon(Icons.star)),
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
                              child: Text("Available date")
                            ),
                            SizedBox(
                              width: 260,
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
                      ),
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
                if(!searchFocusNode.hasFocus & !filtering & !ordering) SizedBox(
                  height: (categories.length) * 50,
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      if (category != "") {
                        return ListTile(
                          title: Text(
                            category,
                            style: (filteredCategory == category) ? const TextStyle(color: Colors.red) : const TextStyle(color: Colors.black),
                            textAlign: TextAlign.start,
                          ),
                          onTap: () => {
                            if (filteredCategory == category) {
                              filteredCategory = ""
                            } else {
                              filteredCategory = category,
                            },
                            setState(() {})
                          }
                      );
                      } else {
                        return const Divider();
                      }
                    },
                  ),
                ),
                if (!searchFocusNode.hasFocus) const Divider(),
                if(!searchFocusNode.hasFocus & !filtering & !ordering) printActivityColumns(),
                if(!searchFocusNode.hasFocus & !filtering & !ordering) const Divider(),
                if(!searchFocusNode.hasFocus & !filtering & !ordering) printUserActivityElement(),
              ]
            ),
          ),
        ],
      ) : CustomScrollView(
        slivers: [
          SliverAppBar(
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
                    arguments: EditActivityPage(ind, "Add activity", Activity('', '', '', '', 0, DateTime.now())),
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
          ),
            SliverList(
              delegate: SliverChildListDelegate(
                  [
                    if(!filtering & !ordering) printActivityManagerElement(),
                    if (ordering) orderActivities(managerParameters),
                    if (filtering) SizedBox(
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
                                SizedBox(
                                  width: 240,
                                  height: 50,
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
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ]
              )
          )
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        items: getBottomMenu(0)
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

  void sortActivities(String? parameter, String? ascending) {
    switch (parameter) {
      case "Name":
        if(ascending == "Ascending") {
          allActivities.sort((a, b) => a.name.compareTo(b.name));
        } else {
          allActivities.sort((a, b) => - a.name.compareTo(b.name));
        }
        break;
      case "Distance":
        if(ascending == "Ascending") {
          allActivities.sort((a, b) => a.position.compareTo(b.position));
        } else {
          allActivities.sort((a, b) => - a.position.compareTo(b.position));
        }
        break;
      case "Category":
        if(ascending == "Ascending") {
          allActivities.sort((a, b) => a.category.compareTo(b.category));
        } else {
          allActivities.sort((a, b) => - a.category.compareTo(b.category));
        }
        break;
      case "Rating":
        if(ascending == "Ascending") {
          allActivities.sort((a, b) => a.rating.compareTo(b.rating));
        } else {
          allActivities.sort((a, b) => - a.rating.compareTo(b.rating));
        }
        break;
      case "Date":
        if(ascending == "Ascending") {
          allActivities.sort((a, b) => a.dateOfAdding.compareTo(b.dateOfAdding));
        } else {
          allActivities.sort((a, b) => - a.dateOfAdding.compareTo(b.dateOfAdding));
        }
        break;
      default :
        allActivities.sort((a, b) => a.name.compareTo(b.name));
        break;
    }
  }

  Widget printActivityColumns() {
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

  /*Future<Widget>*/ Widget printUserActivityElement() /*async*/ {

    //var currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return SizedBox(
      height: 1000,
      child: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];

          double distance = 0/*calculateDistance(
            activity.coordinates?.latitude,
            activity.coordinates?.longitude,
            currentPosition.latitude,
            currentPosition.longitude
          )*/;

          if((filteredCategory == "" || activity.category == filteredCategory) && (activity.rating >= minRating) && (distance >= distances[0]) && (distance <= distances[1])){
            return ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 138,
                    child: Text(activity.name,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    width: 132,
                    child: Text(activity.category,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(activity.rating.toString(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    width: 59,
                    child: Text(activity.position.toString(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
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
            return const SizedBox(width: 0, height: 0,);
          }
        },
      ),
    );
  }

  Widget printActivityManagerElement () {
    return SizedBox(
      height: 1000,
      child: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          if(filteredCategory == "" || activity.category == filteredCategory) {
            return ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 145,
                    child: Text(activity.name,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    width: 130,
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

  Widget orderActivities (List<String> parameters) {
    return SizedBox(
      height: 140,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                const SizedBox(
                    width: 150,
                    child: Text("Sort by")
                ),
                SizedBox(
                  width: 260,
                  height: 50,
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
                    width: 150,
                    child: Text("Order")
                ),
                SizedBox(
                  width: 260,
                  height: 50,
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
                    sortActivities(parameter, ascending);
                  }), child: const Text("Apply"),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
}