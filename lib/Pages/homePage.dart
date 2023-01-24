

import 'package:flutter/material.dart';
import 'package:my_app/Buttons/bottomMenu.dart';
import 'package:my_app/Data/activity.dart';
import 'package:my_app/Pages/activityPage.dart';

import 'package:intl/intl.dart';

import '../Data/category.dart';

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

  List<Activity> activities = allActivities;

  List<String> categories = allCategories;

  final searchFocusNode = FocusNode();
  final minFocusNode = FocusNode();
  final maxFocusNode = FocusNode();
  final dataFocusNode = FocusNode();

  bool filtering = false;
  bool sug = false;
  bool ordering = false;

  var order = ["Ascending", "Descending"];
  String? ascending = "Ascending";
  var columns = ["Name", "Distance", "Rating"];
  String? parameter = "Name";

  var distances = [0.0, double.infinity];
  DateTime date = DateTime(DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);
  int minRating = 0;
  String? filteredCategory = "";

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(onFocusChanged);
  }

  void onFocusChanged() {
    if(searchFocusNode.hasFocus) {
      controller.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tit),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: CustomScrollView(
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
                if (ordering) SizedBox(
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
                                items: columns.map((cat) => DropdownMenuItem<String>(
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
                              }), child: const Text("Apply"),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
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
                                        if((distances[0] > distances[1])) {
                                          maxController.text = minController.text;
                                          distances[1] = double.parse(minController.text);
                                        }
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
                                        if(distances[1] < distances[0]) {
                                          minController.text = maxController.text;
                                          distances[0] = distances[1];
                                        }
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
                if(!searchFocusNode.hasFocus & !filtering & !ordering) Container(
                  height: 1000,
                  color: Colors.white,
                  child: Column(
                    children: [
                      const Text('Activities to scroll'),
                      Row(children: [
                        Text(parameter!),
                        Text(ascending!)
                      ]),
                      Text(filteredCategory!),
                    ],
                  ),
                ),
              ]
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: ind,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.red.withOpacity(.60),
        onTap: (value) {
          switch (value) {
            case 0:
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
        items: getBottomMenu()
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
}