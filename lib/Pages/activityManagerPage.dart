

//import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_app/Buttons/bottomMenu.dart';
import 'package:my_app/Data/activity.dart';
//import 'package:string_validator/string_validator.dart';

import '../Data/category.dart';
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

    String name = "";
    String description = "";
    List<String> categories = allCategories;
    String filteredCategory = "";

    name = activity.name;
    controller.text = activity.name;
    description = activity.description;
    descController.text = activity.description;
    filteredCategory = activity.category;

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
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
                      value: filteredCategory,
                      items: categories.map((cat) => DropdownMenuItem<String>(
                        value: cat,
                        child: Text(cat, style: const TextStyle(fontSize: 15),),
                        onTap: () {
                          filteredCategory = cat;
                        },
                      )).toList(),
                      onChanged: (cat) => (){
                        filteredCategory = cat!;
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
                    const Text("Image"),
                    const Divider(),
                    const Text("Location"),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              //setState(() {});
                            }, child: const Text("Discard"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              activity.editActivity(name, filteredCategory, description);
                              controller.text = "";
                              descController.text = "";
                              name = "";
                              description = "";
                              filteredCategory = "";
                              Navigator.pop(context);
                              //setState(() {});
                            },
                            child: const Text("Apply"),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const Divider(
                color: Colors.red,
              ),
            ],
          ),
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
}