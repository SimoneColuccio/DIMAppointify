

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_app/Data/activity.dart';
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

    name = activity.name;
    controller.text = activity.name;
    description = activity.description;
    descController.text = activity.description;
    services = fromList(activity.appTypes);
    servController.text = fromList(activity.appTypes);
    selectedCategory = activity.category;

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
                        const Text("Name: ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextField(
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
                        const Divider(),
                        const Text("Category"),
                        DropdownButtonFormField<String>(
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
                          },
                        ),
                        const Divider(),
                        const Text("Description: ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextField(
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
                        const Divider(),
                        const Text("Services provided: ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextField(
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
                        const Divider(),
                        const Text("Image"),
                        const Divider(),
                        const Text("Location"),
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
                                    //setState(() {});
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
}