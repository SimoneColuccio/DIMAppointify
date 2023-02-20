

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/Data/appointment.dart';
import 'package:my_app/Pages/accountPage.dart';
import '../Data/category.dart';
import '../Widgets/bottomMenu.dart';
import '../Widgets/infoPopup.dart';

class IncomingAppPage extends StatefulWidget {
  const IncomingAppPage({super.key, required this.index});

  final int index;

  @override
  State<IncomingAppPage> createState() => _IncomingAppPageState(this.index);
}

List<Appointment> appointments = [];
List<Appointment> incomingAppointments = [];

class _IncomingAppPageState extends State<IncomingAppPage>{
  _IncomingAppPageState(this.ind);
  final int ind;
  final title = "Incoming Appointments";
  bool filtering = false;
  bool ordering = false;

  final dataController = TextEditingController();

  List<String> categories = allCategories;

  final dataFocusNode = FocusNode();

  var order = ["Ascending", "Descending"];
  String? ascending = "Ascending";
  var columns = ["Name", "Date"];
  String? parameter = "Date";

  DateTime date = DateTime(DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);
  String? filteredCategory = "";

  @override
  Widget build(BuildContext context) {

    for(int i = 0; i < allAppointments.length; i++) {
      if (allAppointments[i].user.toLowerCase() == user.toLowerCase() &&
        !incomingAppointments.contains(allAppointments[i]) &&
        isTodayOrTomorrow(i)) {
        incomingAppointments.add(allAppointments[i]);
      }
    }

    for(int i = 0; i < allAppointments.length; i++) {
      if (allAppointments[i].user.toLowerCase() == user.toLowerCase() &&
          !appointments.contains(allAppointments[i]) &&
          !isTodayOrTomorrow(i) && isFuture(i)) {
        appointments.add(allAppointments[i]);
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
                                      ascending = "Ascending";
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
                            ),
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
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => setState(() {
                                      filteredCategory = "";
                                      date = DateTime(DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    if(!filtering & !ordering) SizedBox(
                      height: 200,
                      child: Center(
                        child: (isLoggedAsUser | isLoggedAsActivity) ? ListView.builder(
                          itemCount: incomingAppointments.length,
                          itemBuilder: (context, index) {
                            final appointment = incomingAppointments[index];
                              return ListTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        appointment.activity.name,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        DateFormat('yyyy/MM/dd, kk:mm').format(appointment.dateTime),
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.red
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        appointmentInfoPopup(appointment, context),
                                  );
                                },
                            );
                          },
                        ) : const Text("You have to log in to see your appointments"),
                      ),
                    ),
                    if (filtering || ordering &(isLoggedAsUser | isLoggedAsActivity)) const Divider(color: Colors.red),
                    if((!filtering & !ordering) & (isLoggedAsUser | isLoggedAsActivity)) Container(
                      height: 1000,
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          final appointment = appointments[index];
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
                                      DateFormat('yyyy/MM/dd, kk:mm').format(appointment.dateTime),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      appointmentInfoPopup(appointment, context),
                                );
                              },
                          );
                          } else {
                            return const SizedBox(width: 0, height: 0,);
                          }
                        },
                      ),
                    ),
                  ]
              ),
            ) ,
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
                case 2:
                  Navigator.pushNamed(context, '/past');
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
  
  bool isTodayOrTomorrow (int i) {
    
    var months30 = [1, 3, 5, 7, 8, 10];
    var months31 = [4, 6, 9, 11];
    
    //today
    if (allAppointments[i].dateTime.year == DateTime.now().year &&
        allAppointments[i].dateTime.month == DateTime.now().month &&
        allAppointments[i].dateTime.day == DateTime.now().day &&
        (allAppointments[i].dateTime.hour >= DateTime.now().hour ||
        allAppointments[i].dateTime.hour == DateTime.now().hour &&
        allAppointments[i].dateTime.minute >= DateTime.now().minute)) {
      return true;
    }
    
    //easy tomorrow
    if (allAppointments[i].dateTime.year == DateTime.now().year &&
        allAppointments[i].dateTime.month == DateTime.now().month &&
        allAppointments[i].dateTime.day == DateTime.now().day + 1) {
      return true;
    }
    
    //today is 31 and tomorrow is 1
    if (allAppointments[i].dateTime.year == DateTime.now().year &&
        months31.contains(DateTime.now().month) && DateTime.now().day == 31 &&
        allAppointments[i].dateTime.month == DateTime.now().month + 1 &&
        allAppointments[i].dateTime.day == 1) {
      return true;
    }

    //today is 30 and tomorrow is 1
    if (allAppointments[i].dateTime.year == DateTime.now().year &&
        months30.contains(DateTime.now().month) && DateTime.now().day == 30 &&
        allAppointments[i].dateTime.month == DateTime.now().month + 1 &&
        allAppointments[i].dateTime.day == 1) {
      return true;
    }

    //today is 28/29 and tomorrow is 1
    if (allAppointments[i].dateTime.year == DateTime.now().year &&
       (DateTime.now().month == 2 && DateTime.now().day == 28 && DateTime.now().year % 4 != 0 ||
        DateTime.now().month == 2 && DateTime.now().day == 29 && DateTime.now().year % 4 == 0) &&
        allAppointments[i].dateTime.month == DateTime.now().month + 1 &&
        allAppointments[i].dateTime.day == 1) {
      return true;
    }
    
    //today is dec 31th and tomorrow is jan 1st
    if(allAppointments[i].dateTime.year == DateTime.now().year + 1 &&
        DateTime.now().month == 12 && DateTime.now().day == 31 &&
        allAppointments[i].dateTime.month == 1 && allAppointments[i].dateTime.day == 1) {
      return true;
    }
    
    return false;
  }

  bool isFuture(int i) {
    //Appointment next year
    if (allAppointments[i].dateTime.year > DateTime.now().year) {
      return true;
    }

    //Appointment next month
    if (allAppointments[i].dateTime.year == DateTime.now().year &&
        allAppointments[i].dateTime.month > DateTime.now().month) {
      return true;
    }

    if (allAppointments[i].dateTime.year == DateTime.now().year &&
        allAppointments[i].dateTime.month == DateTime.now().month &&
        allAppointments[i].dateTime.day > DateTime.now().day + 1) {
      return true;
    }

    return false;
  }

  List<Appointment> getIncomingAppointments() {
    return incomingAppointments;
  }

  List<Appointment> getFutureAppointments() {
    return appointments;
  }
}