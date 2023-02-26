

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Data/activity.dart';
import 'package:my_app/Data/openingTime.dart';
//import 'package:string_validator/string_validator.dart';

import '../Data/category.dart';
import '../Widgets/bottomMenu.dart';
import 'bookAppointmentPage.dart';
//import 'package:address_search_field/address_search_field.dart';

class EditActivityPage{

  final int index;
  final String title;
  final Activity activity;

  EditActivityPage(this.index, this.title, this.activity);
}

class EditActivityPageScreen extends StatelessWidget {
  const EditActivityPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute
        .of(context)!
        .settings
        .arguments as EditActivityPage;
    int index = args.index;
    String title = args.title;
    Activity activity = args.activity;

    final controller = TextEditingController();
    final focusNode = FocusNode();
    final descController = TextEditingController();
    final descFocusNode = FocusNode();
    final servController = TextEditingController();
    final servFocusNode = FocusNode();
    final appController = TextEditingController();
    final appFocusNode = FocusNode();

    //Activity attributes
    String name = "";
    String selectedCategory = "";
    String description = "";
    String services = "";
    int? duration = 30;
    int concurrentAppointments = 1;
    OpeningTime times = OpeningTime();
    List<List<double>> hours = times.hours;
    List<bool> continued = times.continued;

    //State variables
    List<List<bool>> completed = [
      [false, false, false, false],
      [false, false, false, false],
      [false, false, false, false],
      [false, false, false, false],
      [false, false, false, false],
      [false, false, false, false],
      [false, false, false, false]
    ];
    List<bool> popups = [false, false, false, false, false, false, false];
    bool equals = true;

    name = activity.name;
    controller.text = activity.name;
    description = activity.description;
    descController.text = activity.description;
    services = fromList(activity.appTypes);
    servController.text = fromList(activity.appTypes);
    selectedCategory = activity.category;
    duration = activity.duration;
    concurrentAppointments = activity.concurrentAppointments;
    appController.text = activity.concurrentAppointments.toString();
    times = activity.times;

    return StatefulBuilder(
        builder: (context, setState) {
          return Scaffold(
              appBar: AppBar(
                title: Text(title),
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),
              body: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text("Name *",
                                  style: TextStyle(color: Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 0, 0, 10),
                                  child: TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    decoration: const InputDecoration(
                                      hintText: 'Insert the name of your activity',
                                    ),
                                    onChanged: (text) {
                                      if (isCorrect(controller.text)) {
                                        name = controller.text;
                                      }
                                      //setState(() {});
                                    },
                                  ),
                                ),
                                const Text("Category *",
                                  style: TextStyle(color: Colors.black),
                                ),
                                buildPopups(
                                    0, context, setState, popups, completed),
                                popups[0] ? Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 0, 0, 10),
                                  child: DropdownButtonFormField<String>(
                                      value: selectedCategory,
                                      items: allCategories.map((cat) =>
                                          DropdownMenuItem<String>(
                                            value: cat,
                                            child: Text(cat,
                                              style: const TextStyle(
                                                  fontSize: 15),),
                                            onTap: () {
                                              selectedCategory = cat;
                                            },
                                          )).toList(),
                                      onChanged: (cat) =>
                                          () {
                                        selectedCategory = cat!;
                                        //setState(() {});
                                      }),
                                ) : const SizedBox(),
                                const Text("Description",
                                  style: TextStyle(color: Colors.black),
                                ),
                                buildPopups(
                                    1, context, setState, popups, completed),
                                popups[1] ? Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 0, 0, 10),
                                  child: TextField(
                                    controller: descController,
                                    focusNode: descFocusNode,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      hintText: 'Insert a short description of your activity',
                                    ),
                                    onChanged: (text) {
                                      if (isCorrect(descController.text)) {
                                        description = descController.text;
                                      }
                                      //setState(() {});
                                    },
                                  ),
                                ) : const SizedBox(),
                                const Text("Services provided *",
                                  style: TextStyle(color: Colors.black),
                                ),
                                buildPopups(
                                    2, context, setState, popups, completed),
                                popups[2] ? Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 0, 0, 10),
                                  child: TextField(
                                    controller: servController,
                                    focusNode: servFocusNode,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      hintText: 'Insert the services of your activity, one for each line',
                                    ),
                                    onChanged: (text) {
                                      if (isCorrect(servController.text)) {
                                        services = servController.text;
                                      }
                                      //setState(() {});
                                    },
                                  ),
                                ) : const SizedBox(height: 0),
                                const Text("Image"),
                                buildPopups(
                                    3, context, setState, popups, completed),
                                popups[3] ? const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: null,
                                ) : const SizedBox(),
                                const Text("Location *"),
                                buildPopups(
                                    4, context, setState, popups, completed),
                                popups[4] ? const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: null,
                                ) : const SizedBox(),
                                const Text("Appointment settings *"),
                                buildPopups(
                                    5, context, setState, popups, completed),
                                popups[5] ? Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 0, 0, 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Text("Appointment duration"),
                                          const SizedBox(width: 20),
                                          SizedBox(
                                              width: 60,
                                              child: DropdownButtonFormField<
                                                  int>(
                                                value: duration,
                                                items: [15, 30, 45, 60].map((
                                                    cat) =>
                                                    DropdownMenuItem<int>(
                                                      value: cat,
                                                      child: Text(
                                                        cat.toString(),
                                                        style: const TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    )).toList(),
                                                onChanged: (cat) =>
                                                    setState(() =>
                                                    duration = cat),
                                              )
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text("Concurrent appointments"),
                                          const SizedBox(width: 20),
                                          Container(
                                            width: 50,
                                            color: Colors.white,
                                            child: TextField(
                                              textAlignVertical: TextAlignVertical
                                                  .center,
                                              keyboardType: TextInputType
                                                  .number,
                                              controller: appController,
                                              focusNode: appFocusNode,
                                              onChanged: ((text) {
                                                concurrentAppointments =
                                                    int.parse(
                                                        appController.text);
                                              }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ) : const SizedBox(),
                                const Text("Opening time *"),
                                buildPopups(
                                    6, context, setState, popups, completed),
                                popups[6] ? Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 0, 0, 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .end,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .end,
                                                children: const [
                                                  Text("Break"),
                                                ],
                                              )
                                          ),
                                          SizedBox(
                                            width: 145,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .end,
                                              children: [
                                                const Text("Same Times"),
                                                TextButton(
                                                    style: TextButton.styleFrom(
                                                      minimumSize: const Size(
                                                          20, 20),
                                                      foregroundColor: Colors
                                                          .black,
                                                    ),
                                                    onPressed: () {
                                                      equals = !equals;
                                                      if (!equals &&
                                                          !continued[0]) {
                                                        for (int z = 1; z <
                                                            5; z++) {
                                                          continued[z] = false;
                                                        }
                                                      }
                                                      setState(() {});
                                                    },
                                                    child: equals
                                                        ? const Icon(
                                                        Icons
                                                            .check_box_outlined)
                                                        : const Icon(
                                                        Icons
                                                            .check_box_outline_blank_outlined)
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      for(int i = 0; i < hours.length; i++)
                                        (!equals || i == 0 || i > 4) ? Row(
                                          children: [
                                            SizedBox(width: 75,
                                                child: Text(times.weekDay(
                                                    (equals && i == 0)
                                                        ? 7
                                                        : i))),
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                padding: const EdgeInsets.all(
                                                    1),
                                                fixedSize: const Size(60, 20),
                                                foregroundColor: Colors.black,
                                              ),
                                              onPressed: () =>
                                              {
                                                updateButtons(
                                                    i, 0, setState, completed),
                                              },
                                              child: hours[i][0] == -1
                                                  ? const Text("")
                                                  : printTime(
                                                  getHour(hours[i][0]),
                                                  getMinute(hours[i][0])
                                              ),
                                            ),
                                            const Text(" "),
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                padding: const EdgeInsets.all(
                                                    1),
                                                fixedSize: const Size(60, 20),
                                                foregroundColor: Colors.black,
                                              ),
                                              onPressed: () =>
                                              {
                                                updateButtons(
                                                    i, 1, setState, completed),
                                              },
                                              child: hours[i][1] == -1
                                                  ? const Text("")
                                                  : printTime(
                                                  getHour(hours[i][1]),
                                                  getMinute(hours[i][1])
                                              ),
                                            ),
                                            continued[i]
                                                ? IconButton(
                                                onPressed: () {
                                                  continued[i] = false;
                                                  setState(() {});
                                                },
                                                icon: const Icon(Icons
                                                    .check_box_outline_blank_outlined))
                                                : IconButton(
                                                onPressed: () {
                                                  continued[i] = true;
                                                  hours[i][3] = -1;
                                                  hours[i][4] = -1;
                                                  setState(() {});
                                                },
                                                icon: const Icon(
                                                    Icons.check_box_outlined)),
                                            !continued[i]
                                                ? OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                padding: const EdgeInsets.all(
                                                    1),
                                                fixedSize: const Size(60, 20),
                                                foregroundColor: Colors.black,
                                              ),
                                              onPressed: () =>
                                              {
                                                updateButtons(
                                                    i, 2, setState, completed),
                                              },
                                              child: hours[i][2] == -1
                                                  ? const Text("")
                                                  : printTime(
                                                  getHour(hours[i][2]),
                                                  getMinute(hours[i][2])
                                              ),
                                            )
                                                : const SizedBox(height: 0),
                                            !continued[i]
                                                ? const Text(" ")
                                                : const SizedBox(height: 0),
                                            !continued[i]
                                                ? OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                padding: const EdgeInsets.all(
                                                    1),
                                                fixedSize: const Size(60, 20),
                                                foregroundColor: Colors.black,
                                              ),
                                              onPressed: () =>
                                              {
                                                updateButtons(
                                                    i, 3, setState, completed),
                                              },
                                              child: hours[i][3] == -1
                                                  ? const Text("")
                                                  : printTime(
                                                  getHour(hours[i][3]),
                                                  getMinute(hours[i][3])
                                              ),
                                            )
                                                : const SizedBox(height: 0),
                                          ],
                                        ) : const SizedBox(),
                                      for(int z = 0; z < 7; z ++)
                                        for(int k = 0; k < 4; k ++)
                                          completed[z][k] ? getDatePicker(
                                              z, k, hours, context, setState,
                                              equals) : const SizedBox(),
                                    ],
                                  ),
                                ) : const SizedBox(),
                                const Divider(
                                  color: Colors.red,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          name = "";
                                          description = "";
                                          services = "";
                                          selectedCategory = "";
                                          duration = 30;
                                          concurrentAppointments = 1;
                                          times.initializeHours();
                                          if (!checkInputs(
                                              name, selectedCategory,
                                              toList(services), duration,
                                              concurrentAppointments, times)) {
                                            deleteActivity(activity);
                                          }
                                          Navigator.pop(context);
                                          //setState(() {});
                                        }, child: const Text("Discard"),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (checkInputs(
                                              name, selectedCategory,
                                              toList(services), duration,
                                              concurrentAppointments, times)) {
                                            activity.editActivity(
                                                name,
                                                selectedCategory,
                                                description,
                                                toList(services),
                                                duration,
                                                concurrentAppointments,
                                                times);
                                            controller.text = "";
                                            descController.text = "";
                                            servController.text = "";
                                            name = "";
                                            description = "";
                                            services = "";
                                            selectedCategory = "";
                                            duration = 30;
                                            concurrentAppointments = 1;
                                            times.initializeHours();
                                            Navigator.pop(context);
                                            setState(() {});
                                          }
                                        },
                                        child: const Text("Apply"),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ]
                    ),
                  ),
                ],
              ),

              bottomNavigationBar: BottomNavigationBar(
                  currentIndex: index,
                  selectedItemColor: Colors.red,
                  unselectedItemColor: Colors.red.withOpacity(.60),
                  onTap: (value) {
                    switch (value) {
                      case 0:
                        if (!checkInputs(
                            activity.name, activity.category, activity.appTypes, activity.duration,
                            activity.concurrentAppointments, activity.times)) {
                          deleteActivity(activity);
                        }
                        Navigator.pushNamed(context, '/');
                        break;
                      case 1:
                        if (!checkInputs(
                            activity.name, activity.category, activity.appTypes, activity.duration,
                            activity.concurrentAppointments, activity.times)) {
                          deleteActivity(activity);
                        }
                        Navigator.pushNamed(context, '/incoming');
                        break;
                      case 2:
                        if (!checkInputs(
                            activity.name, activity.category, activity.appTypes, activity.duration,
                            activity.concurrentAppointments, activity.times)) {
                          deleteActivity(activity);
                        }
                        Navigator.pushNamed(context, '/past');
                        break;
                      case 3:
                        if (!checkInputs(
                            activity.name, activity.category, activity.appTypes, activity.duration,
                            activity.concurrentAppointments, activity.times)) {
                          deleteActivity(activity);
                        }
                        Navigator.pushNamed(context, '/account');
                        break;
                    }
                  },
                  items: getBottomMenu(0)
              )
          );
        }
    );
  }

  bool isCorrect(String string) {
    bool c;
    c = string != "";
    c = c && !string.contains("<");
    c = c && !string.contains(">");
    c = c && !string.contains("&");

    return c;
  }

  String fromList(List<String> list) {
    String ret = "";
    for (var element in list) {
      if (element != "") {
        ret = '$ret$element\n';
      }
    }
    return ret.trimRight();
  }

  List<String> toList(String input) {
    List<String> ret = [""];
    List<String> elements = input.split("\n");
    for (var e in elements) {
      if (e != "") {
        ret.add(e);
      }
    }
    return ret;
  }

  bool checkInputs(String name, String selectedCategory, List<String> list,
      int? duration, int concurrentAppointments, OpeningTime times) {
    if (name
        .trim()
        .isEmpty) {
      return false;
    }
    if (selectedCategory == "") {
      return false;
    }

    if (list.length <= 1) {
      return false;
    }

    if (concurrentAppointments == 0) {
      return false;
    }

    if (duration == null) {
      return false;
    }
    double min = 60;
    for (int i = 0; i < 7; i++) {
      for (int j = 1; j < 4; j++) {
        double m = 100 * times.hours[i][j] - 100 * times.hours[i][j - 1];
        if (m < min) {
          min = m;
        }
      }
    }
    if (min < duration) {
      return false;
    }

    for (int i = 0; i < 7; i++) {
      for (int j = 0; j < 4; j++) {
        if (j > 1 && times.continued[i]) {
          continue;
        }
        if (times.hours[i][j] == -1) {
          return false;
        }
        if (j > 0 && times.hours[i][j] == times.hours[i][j - 1]) {
          return false;
        }
      }
    }
    return true;
  }

  Widget buildPopups(int index, BuildContext context, StateSetter setState,
      List<bool> popups, List<List<bool>> completed) {
    return TextButton(
      style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          alignment: Alignment.centerLeft
      ),
      onPressed: () {
        int i = index;
        if (!popups[i]) {
          popups[i] = true;
          for (int j = 0; j < popups.length; j++) {
            if (j != i) {
              popups[j] = false;
            }
          }
        } else {
          popups[i] = false;
        }
        if (!popups[6]) {
          for (int z = 0; z < 7; z ++) {
            for (int k = 0; k < 4; k++) {
              completed[z][k] = false;
            }
          }
        }
        setState(() {});
      },
      child: popups[index] ? const Icon(Icons.arrow_drop_up) : const Icon(
          Icons.arrow_drop_down),
    );
  }

  Widget getDatePicker(int i, int j, List<List<double>> hours,
      BuildContext context, Function(void Function()) setState, bool equals) {
    return SizedBox(
        height: MediaQuery
            .of(context)
            .copyWith()
            .size
            .height / 3,
        child: CupertinoDatePicker(
          initialDateTime: hours[i][j] == -1
              ? DateTime(2023, 1, 1, 0, 0)
              : DateTime(
              2023, 1, 1, getHour(hours[i][j]), getMinute(hours[i][j])),
          onDateTimeChanged: (DateTime newDate) {
            hours[i][j] = newDate.hour + 0.01 * newDate.minute;
            if (equals) {
              for (int z = 0; z < 5; z++) {
                for (int k = 0; k < 4; k++) {
                  hours[z][k] = hours[0][k];
                }
              }
            }
            setState(() {});
          },
          use24hFormat: true,
          minimumDate: DateTime(2023, 1, 1,
              (j == 0 || getHour(hours[i][j - 1]) == -1) ? 0 : getHour(
                  hours[i][j - 1]),
              (j == 0 || getMinute(hours[i][j - 1]) == -1) ? 0 : getMinute(
                  hours[i][j - 1])),
          maximumDate: DateTime(2023, 1, 1,
              (j == 3 || getHour(hours[i][j + 1]) == -1) ? 24 : getHour(
                  hours[i][j + 1]),
              (j == 3 || getMinute(hours[i][j + 1]) == -1) ? 0 : getMinute(
                  hours[i][j + 1])),
          minuteInterval: 15,
          mode: CupertinoDatePickerMode.time,
        )
    );
  }

  void updateButtons(int i, int j, StateSetter setState,
      List<List<bool>> completed) {
    for (int z = 0; z < 7; z ++) {
      for (int k = 0; k < 4; k++) {
        if (z == i && k == j) {
          completed[i][j] = !completed[i][j];
        } else {
          completed[z][k] = false;
        }
      }
    }
    setState(() {});
  }
}

  int getHour(double hour) {
    return hour.floor();
  }

  int getMinute(double hour) {
    return (100 * hour - 100 * hour.floor()).toInt();

  }