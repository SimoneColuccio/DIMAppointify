
//import 'dart:developer';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/Buttons/bottomMenu.dart';
import 'package:my_app/Data/activity.dart';
//import 'package:my_app/Data/activity.dart';
import 'package:my_app/Pages/incomingAppointmentsPage.dart';

import '../Data/appointment.dart';
import '../Data/category.dart';
import 'accountPage.dart';

class PastAppPage extends StatefulWidget {
  const PastAppPage({super.key, required this.index});

  final int index;

  @override
  State<PastAppPage> createState() => _PastAppPageState(this.index);
}

List<Appointment> pastAppointments = [];

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

    for(int i = 0; i < allAppointments.length; i++) {
      if (allAppointments[i].user.toLowerCase() == user.toLowerCase() &&
          !pastAppointments.contains(allAppointments[i]) &&
          !incomingAppointments.contains(allAppointments[i]) &&
          !appointments.contains(allAppointments[i])) {
        pastAppointments.add(allAppointments[i]);
      }
    }

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
                    if (ordering) Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 150,
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
                    ),
                    if (filtering) Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 170,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(
                                      width: 130,
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
                                      width: 130,
                                      child: Text("Date")
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
                            const SizedBox(height: 10),
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
                    ),
                    if ((filtering || ordering) && (isLoggedAsUser | isLoggedAsActivity)) const Divider(color: Colors.red),
                    if((!filtering & !ordering) & (isLoggedAsUser | isLoggedAsActivity)) Container(
                      height: 1000,
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: pastAppointments.length,
                        itemBuilder: (context, index) {
                          final appointment = pastAppointments[index];
                          if(filteredCategory == "" || appointment.activity.category == filteredCategory) {
                            return ListTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        appointment.activity.name,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        DateFormat('yy/MM/dd').format(appointment.dateTime),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 144,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) =>
                                                      _buildPopupDialogInfo(appointment),
                                                );
                                              },
                                              icon: const Icon(Icons.info)
                                          ),
                                          appointment.voted == -1 ? IconButton(
                                              onPressed: () async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                    _buildPopupDialogVote(context, appointment),
                                                );
                                                for (var element in allActivities) {
                                                  if(element.name == appointment.activity.name && element.dateOfAdding == appointment.activity.dateOfAdding && element.description == appointment.activity.description) {
                                                    element.voteActivity(appointment.voted);
                                                    break;
                                                  }
                                                }
                                                setState(() {});
                                              },
                                            icon: const Icon(Icons.thumb_up)
                                          ) : const SizedBox(width: 0, height: 0),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pushNamed(context, '/bookAppointment');
                                            },
                                            icon: const Icon(Icons.bookmark_add)
                                          ),
                                        ],
                                      )
                                    ),
                                  ],
                                ),
                                onTap: () => {
                                  //Add to Google Calendar
                                }
                            );
                          } else {
                            return const SizedBox(width: 0, height: 0,);
                          }
                        },
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
            items: getBottomMenu(0)
        )
    );
  }

  Widget _buildPopupDialogVote(BuildContext context, Appointment appointment) {
    int vote = 0;
    return AlertDialog(
      title: const Text('Rate your experience'),
      content: StatefulBuilder(
        builder: (context, StateSetter setState) {
          return SizedBox(
            height: 100,
            child: Column(
              children: [
                Row(
                  children: [
                    for(int i = 1; i <= 5; i++)
                      IconButton(onPressed: () {
                        if (vote == i) {
                          vote = 0;
                        } else {
                          vote = i;
                        }
                        setState(() {});
                      }, icon: (vote < i) ? const Icon(Icons.star_border) : const Icon(Icons.star)),
                  ],
                ),
                const SizedBox(height: 30),
                const Text("The vote cannot be zero"),
              ],
            ),
          );
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Back"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (vote > 0) {
                      appointment.voted = vote;
                      setState(() {});
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Confirm"),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopupDialogInfo(Appointment appointment) {
    return AlertDialog(
      title: const Text('Appointment info'),
      content: SizedBox(
        height: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('yy/MM/dd hh:mm').format(appointment.dateTime),
              style: const TextStyle(fontSize: 19),
            ),
            const SizedBox(height: 10),
            Text(
              appointment.appointType,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 70),
            Text(appointment.activity.name),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("pos"),
                Text(appointment.activity.position),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 100,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Back"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}