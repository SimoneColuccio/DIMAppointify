
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/Buttons/bottomMenu.dart';

import '../Data/category.dart';
import 'accountPage.dart';

class PastAppPage extends StatefulWidget {
  const PastAppPage({super.key, required this.index});

  final int index;

  @override
  State<PastAppPage> createState() => _PastAppPageState(this.index);
}

class _PastAppPageState extends State<PastAppPage>{
  _PastAppPageState(this.ind);
  final int ind;
  final title = "Past Appointments";
  bool filtering = false;
  bool ordering = false;

  var order = ["Ascending", "Descending"];
  String? ascending = "Descending";
  var columns = ["Name", "Date"];
  String? parameter = "Date";

  final dataController = TextEditingController();

  List<String> categories = allCategories;

  final dataFocusNode = FocusNode();

  DateTime date = DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
  String? filteredCategory = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.red,
              automaticallyImplyLeading: false,
              floating: true,
              pinned: true,
              snap: false,
              title: Text(title),
              centerTitle: true,
              leading: ((!filtering & !ordering) & (isLoggedAsUser | isLoggedAsActivity)) ? TextButton(
                  onPressed: () {
                    ordering = true;
                    setState(() {});
                  },//Open filtering options
                  child: const Icon(Icons.list, color: Colors.white,)
              ) : null,
              actions: [
                if ((!filtering & !ordering) & (isLoggedAsUser | isLoggedAsActivity)) TextButton(
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
                    if (ordering) Container(
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
                                    ascending = "Descending";
                                    parameter = "Date";
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
                    if (filtering) Container(
                      height: 140,
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
                                    child: Text("Date")
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
                                          firstDate: DateTime(1970),
                                          lastDate: DateTime.now());

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
                                    date = DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
                                    filtering = false;
                                    dataController.text = "";
                                  }), child: const Text("Reset"),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => setState(() {
                                    filtering = false;
                                    dataController.text = "";
                                  }), child: const Text("Apply"),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    if (filtering & (isLoggedAsUser | isLoggedAsActivity)) const Divider(),
                    if((!filtering & !ordering) & (isLoggedAsUser | isLoggedAsActivity)) Container(
                      height: 1000,
                      color: Colors.white,
                      child: Column(
                        children: [
                          const Text('Appointments to scroll'),
                          Row(children: [
                            Text(parameter!),
                            Text(ascending!)
                          ]),
                        ],
                      ),
                    ),
                    if(!filtering & !(isLoggedAsUser | isLoggedAsActivity)) const SizedBox(
                      height: 200,
                      child: Center(
                        child: Text("You have to log in to see your appointments"),
                      ),
                    )
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
                  Navigator.pushNamed(context, '/');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/incoming');
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
}