

import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/Data/activity.dart';
import 'package:my_app/Data/openingTime.dart';

import '../Data/category.dart';
import '../Widgets/bottomMenu.dart';
import 'activityPage.dart';

class EditActivityArguments{

  final String title;
  final Activity activity;

  EditActivityArguments(this.title, this.activity);
}

class EditActivityPage extends StatefulWidget {
  const EditActivityPage({super.key});

  @override
  State<StatefulWidget> createState() => EditActivityPageState();
}

class EditActivityPageState extends State<EditActivityPage> {
  XFile? image;

  OpeningTime times = OpeningTime();
  List<List<bool>> completed = initializePickers();
  List<bool> popups = [false, false, false, false, false, false, false];
  bool equals = true;

  final ImagePicker picker = ImagePicker();
  bool modified = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute
        .of(context)!
        .settings
        .arguments as EditActivityArguments;
    String title = args.title;
    Activity activity = args.activity;

    final controller = TextEditingController();
    final focusNode = FocusNode();
    final descController = TextEditingController();
    final descFocusNode = FocusNode();
    final servController = TextEditingController();
    final servFocusNode = FocusNode();
    final posController = TextEditingController();
    final posFocusNode = FocusNode();
    final appController = TextEditingController();
    final appFocusNode = FocusNode();

    //Activity attributes
    String name = activity.name;
    String selectedCategory = activity.category;
    String description = activity.description;
    String services = fromList(activity.appTypes);
    String position = activity.position;
    int? duration = activity.duration;
    int concurrentAppointments = activity.concurrentAppointments;
    File? img = activity.image;
    List<List<double>> hours = activity.hours;
    List<bool> continued = activity.continued;

    controller.text = activity.name;
    descController.text = activity.description;
    servController.text = fromList(activity.appTypes);
    posController.text = activity.position;
    appController.text = activity.concurrentAppointments.toString();

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
                                    0, context, setState, focusNode),
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
                                              setState(() {});
                                            },
                                          )).toList(),
                                      onChanged: (cat) =>
                                          () {
                                        selectedCategory = cat!;
                                        setState(() {});
                                      }),
                                ) : const SizedBox(),
                                const Text("Description",
                                  style: TextStyle(color: Colors.black),
                                ),
                                buildPopups(
                                    1, context, setState, focusNode),
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
                                    2, context, setState, focusNode),
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
                                    3, context, setState, focusNode),
                                popups[3] ? Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      image == null && img != null ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.file(
                                            //to show image, you type like this.
                                            File(img.path),
                                            fit: BoxFit.cover,
                                            width: 150,
                                            height: 150,
                                          ),
                                        ) : const SizedBox(),
                                      image != null ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          //to show image, you type like this.
                                          File(image!.path),
                                          fit: BoxFit.cover,
                                          width: 150,
                                          height: 150,
                                        ),
                                      )
                                      : const SizedBox(),
                                      (img == null && image == null) ? ElevatedButton(
                                          onPressed: () {
                                            myAlert(context, setState);
                                          },
                                          child: const Text('Upload Photo'),
                                        ) : Padding(
                                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            myAlert(context, setState);
                                          },
                                          child: const Text('Change Photo'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ) : const SizedBox(),
                                const Text("Location *"),
                                buildPopups(
                                    4, context, setState, focusNode),
                                popups[4] ? Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: TextField(
                                    controller: posController,
                                    focusNode: posFocusNode,
                                    keyboardType: TextInputType.streetAddress,
                                    autofillHints: const [AutofillHints.postalAddress],
                                    decoration: const InputDecoration(
                                      hintText: 'Insert the address of your activity',
                                    ),
                                    onChanged: (text) {
                                      position = posController.text;
                                    },
                                  ),
                                ) : const SizedBox(),
                                const Text("Appointment settings *"),
                                buildPopups(
                                    5, context, setState, focusNode),
                                popups[5] ? Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 0, 0, 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          selectedCategory != "Hotels and travels" ? const Text("Appointment duration") : const SizedBox(),
                                          selectedCategory != "Hotels and travels" ? const SizedBox(width: 20) : const SizedBox(),
                                          selectedCategory != "Hotels and travels" ? SizedBox(
                                              width: 60,
                                              child: DropdownButtonFormField<
                                                  int>(
                                                value: duration,
                                                items: [15, 30, 45, 60, 120, 180].map((
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
                                          ) : const SizedBox(),
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
                                    6, context, setState, focusNode),
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
                                          Row(
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
                                              children: [
                                                const Expanded(child: SizedBox()),
                                                OutlinedButton(
                                                    onPressed: () {
                                                      hours = initializeHours();
                                                      continued = initializeTurns();
                                                      completed = initializePickers();
                                                      setState(() {});
                                                    },
                                                    child: const Text("Clear all",
                                                      style: TextStyle(color: Colors.black),
                                                    )
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
                                                updateButtons(i, 0, setState),
                                              },
                                              onLongPress: () {
                                                if(equals && i < 5) {
                                                  for(int k = 0; k < 5; k++) {
                                                    hours[k][0] = -1;
                                                  }
                                                } else {
                                                  hours[i][0] = -1;
                                                }
                                                updateButtons(
                                                    i, 0, setState);
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
                                                    i, 1, setState),
                                              },
                                              onLongPress: () {
                                                if(equals && i < 5) {
                                                  for(int k = 0; k < 5; k++) {
                                                    hours[k][1] = -1;
                                                  }
                                                } else {
                                                  hours[i][1] = -1;
                                                }
                                                updateButtons(
                                                    i, 1, setState);
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
                                                  if(equals){
                                                    for(int k = 0; k < 5; k ++) {
                                                      continued[k] = false;
                                                      hours[k][2] = hours[i][2];
                                                      hours[k][3] = hours[i][3];
                                                    }
                                                  }
                                                  setState(() {});
                                                },
                                                icon: const Icon(Icons
                                                    .check_box_outline_blank_outlined))
                                                : IconButton(
                                                onPressed: () {
                                                  continued[i] = true;
                                                  if(equals){
                                                    for(int k = 0; k < 5; k ++) {
                                                      continued[k] = true;
                                                      hours[k][2] = -1;
                                                      hours[k][3] = -1;
                                                    }
                                                  }
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
                                                    i, 2, setState),
                                              },
                                              onLongPress: () {
                                                if(equals && i < 5) {
                                                  for(int k = 0; k < 5; k++) {
                                                    hours[k][2] = -1;
                                                  }
                                                } else {
                                                  hours[i][2] = -1;
                                                }
                                                updateButtons(
                                                    i, 2, setState);
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
                                                updateButtons(i, 3, setState),
                                              },
                                              onLongPress: () {
                                                if(equals && i < 5) {
                                                  for(int k = 0; k < 5; k++) {
                                                    hours[k][3] = -1;
                                                  }
                                                } else {
                                                  hours[i][3] = -1;
                                                }
                                                updateButtons(
                                                    i, 3, setState);
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
                                          ) : const SizedBox(),
                                    ],
                                  ),
                                ) : const SizedBox(),
                                Text(
                                  checkInputs(name, selectedCategory, toList(services), position, duration, concurrentAppointments, hours, continued, "FEEDBACK"),
                                  style: TextStyle(
                                    color: checkInputs(name, selectedCategory, toList(services), position, duration, concurrentAppointments, hours, continued, "FEEDBACK") != "CORRECT"
                                        ? Colors.red
                                        : Colors.green
                                  ),
                                ),
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
                                          if (checkInputs(
                                              activity.name, activity.category, activity.appTypes, activity.position, activity.duration,
                                              activity.concurrentAppointments, activity.hours, activity.continued, "DISCARD") != "CORRECT") {
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
                                              toList(services), position, duration,
                                              concurrentAppointments, hours, continued, "APPLY") == "CORRECT") {
                                            activity.editActivity(
                                                name,
                                                selectedCategory,
                                                description,
                                                toList(services),
                                                position,
                                                duration,
                                                concurrentAppointments,
                                                hours,
                                                continued,
                                                image,
                                            );
                                            Navigator.pushNamed(context,
                                              '/activity',
                                              arguments: ActivityPage(activity.name),
                                            );
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
                  selectedItemColor: Colors.red,
                  unselectedItemColor: Colors.red.withOpacity(.60),
                  onTap: (value) {
                    switch (value) {
                      case 0:
                        if (checkInputs(
                            activity.name, activity.category, activity.appTypes, activity.position, activity.duration,
                            activity.concurrentAppointments, activity.hours, activity.continued, "PAGE") != "CORRECT") {
                          deleteActivity(activity);
                        }
                        Navigator.pushNamed(context, '/');
                        break;
                      case 1:
                        if (checkInputs(
                            activity.name, activity.category, activity.appTypes, activity.position, activity.duration,
                            activity.concurrentAppointments, activity.hours, activity.continued, "PAGE") != "CORRECT") {
                          deleteActivity(activity);
                        }
                        Navigator.pushNamed(context, '/incoming');
                        break;
                      case 2:
                        if (checkInputs(
                            activity.name, activity.category, activity.appTypes, activity.position, activity.duration,
                            activity.concurrentAppointments, activity.hours, activity.continued, "PAGE") != "CORRECT") {
                          deleteActivity(activity);
                        }
                        Navigator.pushNamed(context, '/past');
                        break;
                      case 3:
                        if (checkInputs(
                            activity.name, activity.category, activity.appTypes, activity.position, activity.duration,
                            activity.concurrentAppointments, activity.hours, activity.continued, "PAGE") != "CORRECT") {
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

  String checkInputs(String name, String selectedCategory, List<String> list, String position,
      int? duration, int concurrentAppointments, List<List<double>> hours, List<bool> continued, String place) {
    if (name.trim().isEmpty) {
      return "Insert the name of your activity";
    }
    if (selectedCategory == "") {
      return "Select the category of your activity";
    }

    if (list.length <= 1) {
      return "Insert the services of your activity";
    }

    if(position == "") {
      return "Insert the address of your activity";
    }

    if (concurrentAppointments <= 0) {
      return "Insert a valid number for concurrent appointments";
    }

    if (duration == null) {
      return "Insert the duration of your appointments";
    }
    double a = 0;
    for(int i = 0; i < hours.length; i++) {
      a = a + hours[i][0];
    }
    if(a == -7.0) {
      return "Your activity cannot be always closed";
    }

    double min = 180;
    for (int i = 0; i < 7; i++) {
      for (int j = 1; j < 4; j++) {
        if (j > 1 && continued[i] || hours[i][j] == -1) {
          continue;
        }
        double m = 100 * hours[i][j] - 100 * hours[i][j - 1];
        if (m < min) {
          min = m;
        }
      }
    }
    if (min < duration) {
      return "Opening time has to be greater than the duration of an appointment";
    }

    for (int i = 0; i < 7; i++) {
      if(place != "FEEDBACK") {
        if(hours[i][2] == -1) {
          continued[i] = true;
        }
      }

      for (int k = 0; k < 4; k = k + 2) {
        if (hours[i][k] == -1 && hours[i][k+1] != -1 ||
            hours[i][k] != -1 && hours[i][k+1] == -1) {
          return "Insert correct opening times";
        }
      }
    }
    return "CORRECT";
  }

  Future getImage(ImageSource media, Function(void Function()) setState) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      image = img;
    });
  }

  void myAlert(BuildContext context, Function(void Function()) setState) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery, setState);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera, setState);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildPopups(int index, BuildContext context, StateSetter setState, FocusNode focusNode) {
    return TextButton(
      style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          alignment: Alignment.centerLeft
      ),
      onPressed: () {
        focusNode.unfocus();
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
      BuildContext context, Function(void Function()) setState) {
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

  void updateButtons(int i, int j, StateSetter setState) {
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
