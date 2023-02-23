

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Data/activity.dart';
import 'package:my_app/Data/openingTime.dart';
//import 'package:string_validator/string_validator.dart';

import '../Data/category.dart';
import '../Widgets/bottomMenu.dart';
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

    final args = ModalRoute.of(context)!.settings.arguments as EditActivityPage;
    int index = args.index;
    String title = args.title;
    Activity activity = args.activity;

    final controller = TextEditingController();
    final focusNode = FocusNode();

    final descController = TextEditingController();
    final descFocusNode = FocusNode();

    final servController = TextEditingController();
    final servFocusNode = FocusNode();

    String name = "";
    String description = "";
    String services = "";
    List<String> categories = allCategories;
    String selectedCategory = "";
    int? duration = 30;

    bool equals = true;

    OpeningTime times = OpeningTime();
    List<List<double>> hours = times.hours;
    List<bool> continued = times.continued;

    List<bool> popups = [false, false, false, false, false, false];

    name = activity.name;
    controller.text = activity.name;
    description = activity.description;
    descController.text = activity.description;
    services = fromList(activity.appTypes);
    servController.text = fromList(activity.appTypes);
    selectedCategory = activity.category;

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
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                          buildPopups(0, context, setState, popups),
                          popups[0] ? Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: DropdownButtonFormField<String>(
                            value: selectedCategory,
                            items: categories.map((cat) => DropdownMenuItem<String>(
                              value: cat,
                              child: Text(cat, style: const TextStyle(fontSize: 15),),
                              onTap: () {
                                selectedCategory = cat;
                              },
                            )).toList(),
                            onChanged: (cat) => (){
                              selectedCategory = cat!;
                              //setState(() {});
                            }),
                          ) : const SizedBox(),
                          const Text("Description",
                            style: TextStyle(color: Colors.black),
                          ),
                          buildPopups(1, context, setState, popups),
                          popups[1] ? Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                              onTap: () {
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
                          buildPopups(2, context, setState, popups),
                          popups[2] ? Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                              onTap: () {
                                if (isCorrect(servController.text)) {
                                  services = servController.text;
                                }
                                //setState(() {});
                              },
                            ),
                          ) : const SizedBox(height: 0),
                          const Text("Image"),
                          buildPopups(3, context, setState, popups),
                          popups[3] ? const Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: null,
                          ) : const SizedBox(),
                          const Text("Location *"),
                          buildPopups(4, context, setState, popups),
                          popups[4] ? const Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: null,
                          ) : const SizedBox(),
                          const Text("Opening time"),
                          buildPopups(5, context, setState, popups),
                          popups[5] ? Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("App. duration"),
                                    const SizedBox(width: 20),
                                    SizedBox(
                                      width: 55,
                                      child: DropdownButtonFormField<int>(
                                            value: duration,
                                            items: [15, 30, 45, 60].map((cat) => DropdownMenuItem<int>(
                                              value: cat,
                                              child: Text(cat.toString(), style: const TextStyle(fontSize: 15),
                                              ),
                                            )).toList(),
                                            onChanged: (cat) => setState(() => duration = cat),
                                          )
                                    ),
                                    const SizedBox(width: 50),
                                    const Text("Break"),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          const Text("Same Times"),
                                          TextButton(
                                              style: TextButton.styleFrom(
                                                minimumSize: const Size(20, 20),
                                                foregroundColor: Colors.black,
                                              ),
                                              onPressed: () {
                                                equals = !equals;
                                                for(int i = 0; i < 5; i ++){
                                                  for(int j = 0; j < 4; j++){
                                                    if(equals) {
                                                      if(hours[0][j] != -1){
                                                        hours[i][j] = hours[0][j];
                                                        log(hours[i][j].toString());
                                                      }
                                                    } else {
                                                      hours[i][j] = -1;
                                                    }
                                                  }
                                                }
                                                setState(() {});
                                              },
                                              child: equals ? const Icon(
                                                  Icons.check_box_outlined) : const Icon(
                                                  Icons.check_box_outline_blank_outlined)
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                for(int i = 0; i < hours.length; i++)
                                  Column(
                                    children: [
                                      (!equals || i == 0 || i > 4) ? Row(
                                        children: [
                                          SizedBox(width: 75, child: Text(times.weekDay((equals && i == 0) ? 7 : i))),
                                          OutlinedButton(
                                            style: TextButton.styleFrom(
                                              fixedSize: const Size(60, 20),
                                              foregroundColor: Colors.black,
                                            ),
                                              onPressed: () => {
                                                updateButtons(i, 0, setState, times),
                                              },
                                              child: hours[i][0] == -1 ? const Text("") : Text(hours[i][0].toString()),
                                          ),
                                          const Text(" "),
                                          OutlinedButton(
                                            style: TextButton.styleFrom(
                                              fixedSize: const Size(60, 20),
                                              foregroundColor: Colors.black,
                                            ),
                                            onPressed: () => {
                                              updateButtons(i, 1, setState, times),
                                            },
                                            child: hours[i][1] == -1 ? const Text("") : Text(hours[i][1].toString()),
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
                                                setState(() {});
                                              },
                                              icon: const Icon(
                                                  Icons.check_box_outlined)),
                                          !continued[i]
                                              ? OutlinedButton(
                                            style: TextButton.styleFrom(
                                              fixedSize: const Size(60, 20),
                                              foregroundColor: Colors.black,
                                            ),
                                            onPressed: () => {
                                              updateButtons(i, 2, setState, times),
                                            },
                                            child: hours[i][2] == -1 ? const Text("") : Text(hours[i][2].toString()),
                                          )
                                              : const SizedBox(height: 0),
                                          !continued[i]
                                              ? const Text(" ")
                                              : const SizedBox(height: 0),
                                          !continued[i]
                                              ? OutlinedButton(
                                            style: TextButton.styleFrom(
                                              fixedSize: const Size(60, 20),
                                              foregroundColor: Colors.black,
                                            ),
                                            onPressed: () => {
                                              updateButtons(i, 3, setState, times),
                                            },
                                            child: hours[i][3] == -1 ? const Text("") : Text(hours[i][3].toString()),
                                          )
                                              : const SizedBox(height: 0),
                                        ],
                                      ) : const SizedBox(),
                                    ],
                                  ),
                                for(int z = 0; z < 7; z ++)
                                  for(int k = 0; k < 4; k ++)
                                    times.completed[z][k] ? getDatePicker(z, k, hours, context, setState) : const SizedBox(),
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
                                    if(!checkInputs(name, selectedCategory, toList(services))) {
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
                                    if(checkInputs(name, selectedCategory, toList(services))) {
                                      activity.editActivity(name, selectedCategory, description, toList(services));
                                      controller.text = "";
                                      descController.text = "";
                                      servController.text = "";
                                      name = "";
                                      description = "";
                                      services = "";
                                      selectedCategory = "";
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
      );
    }

  bool isCorrect (String string) {
    bool c;
    c = string != "";
    c = c && !string.contains("<");
    c = c && !string.contains(">");
    c = c && !string.contains("&");

    return c;
  }

  String fromList(List<String> list) {
    String ret = "";
    for(var element in list) {
      if(element != "") {
        ret = '$ret$element\n';
      }
    }
    return ret.trimRight();
  }

  List<String> toList(String input) {
    List<String> ret = [""];
    List<String> elements = input.split("\n");
    for(var e in elements) {
      if(e != "") {
        ret.add(e);
      }
    }
    return ret;
  }

  bool checkInputs(String name, String selectedCategory, List<String> list) {
    if(name.trim().isEmpty) {
      return false;
    }
    if(selectedCategory == "") {
      return false;
    }

    if(list.length <= 1) {
      return false;
    }
    return true;
  }

  Widget buildPopups(int index, BuildContext context, StateSetter setState, List<bool> popups) {
    return TextButton(
      style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          alignment: Alignment.centerLeft
      ),
      onPressed: () {
        int i = index;
        if (!popups[i]) {
          popups[i] = true;
          for(int j = 0; j < popups.length; j++) {
            if (j != i) {
              popups[j] = false;
            }
          }
        } else {
          popups[i] = false;
        }
        setState(() {});
      },
      child: popups[index] ? const Icon(Icons.arrow_drop_up) : const Icon(Icons.arrow_drop_down),
    );
  }

  Widget getDatePicker(int i, int j, List<List<double>> hours, BuildContext context, Function(void Function()) setState) {
    return SizedBox(
        height: MediaQuery.of(context).copyWith().size.height / 3,
        child: CupertinoDatePicker(
          initialDateTime: hours[i][j] == -1 ? DateTime(2023, 10, 10, 0, 0) : DateTime(2023, 10, 10, hours[i][j].floor(), (100 * hours[i][j] - 100 * hours[i][j].floor()).toInt()),
          onDateTimeChanged: (DateTime newDate) {
            hours[i][j] = newDate.hour + 0.01 * newDate.minute;
            setState(() {});
            log(hours[i][j].toString());
          },
          use24hFormat: true,
          maximumDate: DateTime(2023, 10, 10, 24, 0),
          minuteInterval: 15,
          mode: CupertinoDatePickerMode.time,
        )
    );
  }

  void updateButtons(int i, int j, StateSetter setState, OpeningTime times) {
    for(int z = 0; z < 7 ; z ++) {
      for(int k = 0; k < 4; k++) {
        if(z == i && k == j) {
          times.completed[i][j] = !times.completed[i][j];
        } else {
          times.completed[z][k] = false;
        }
      }
    }
    setState(() {});
  }
}