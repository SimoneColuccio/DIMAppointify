
//import 'dart:developer';

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/Data/activity.dart';
//import 'package:my_app/Data/activity.dart';
import 'package:my_app/Pages/incomingAppointmentsPage.dart';
import 'package:my_app/Widgets/infoPopup.dart';

import '../Data/appointment.dart';
import '../Data/category.dart';
import '../Widgets/bottomMenu.dart';
import 'accountPage.dart';
import 'bookAppointmentPage.dart';

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

    checkDates();

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
                                      allAppointments = sortAppointments(parameter, ascending, allAppointments);
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
                                        isLoggedAsUser ? appointment.activity.name : appointment.user,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        isLoggedAsUser ? DateFormat('yy/MM/dd').format(appointment.dateTime) : DateFormat('yy/MM/dd kk:mm').format(appointment.dateTime),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                    isLoggedAsUser ? SizedBox(
                                      width: 144,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) =>
                                                      appointmentInfoPopup(appointment, context, "p"),
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
                                              Navigator.pushNamed(
                                                context,
                                                '/bookAppointment',
                                                arguments: BookAppointmentArguments(
                                                  createAppointment(appointment.user, appointment.activity, DateTime.now(), "")
                                                ),
                                              ).then(onGoBack);
                                            },
                                            icon: const Icon(Icons.bookmark_add)
                                          ),
                                        ],
                                      )
                                    ) : SizedBox(
                                        width: 50,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) =>
                                                        appointmentInfoPopup(appointment, context, "p"),
                                                  );
                                                },
                                                icon: const Icon(Icons.info)
                                            ),
                                          ],
                                        )
                                    ) ,
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
            items: getBottomMenu(incomingAppointments.length)
        )
    );
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
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
}